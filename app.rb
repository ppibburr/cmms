require 'rubygems'
require 'sinatra'
require 'mongo'
require 'json'

DB = Mongo::Client.new("mongodb://localhost",database:"mydb")
require 'open3'
get '/' do
  Open3.popen3("ruby ./views/workorder.rb") do |i,o,e,w|
    i.puts DB["todos"].find.to_a.map{|t| from_bson_id(t)}.to_json
    succ = o.read
    err = e.read
    if err.empty?
     succ
    else
      err.gsub("\n","<br>")
    end 
  end
end

get '/todo' do
  haml :todo, :attr_wrapper => '"', :locals => {:title => 'MongoDB Backed TODO App'}
end

get '/api/:thing' do
  DB[params[:thing]].find.to_a.map{|t| from_bson_id(t)}.to_json
end

get '/api/:thing/:id' do
  from_bson_id(DB[params[:thing]].find_one(to_bson_id(params[:id]))).to_json
end

post '/api/:thing' do
  oid = DB[params[:thing]].insert_one(JSON.parse(request.body.read.to_s))
  p oid=oid.inserted_id
  "{\"_id\": \"#{oid.to_s}\"}"
end

delete '/api/:thing/:id' do
  DB[params[:thing]].delete_one('_id' => to_bson_id(params[:id]))
  ""
end

put '/api/:thing/:id' do
  DB[params[:thing]].update_one({'_id' => to_bson_id(params[:id])}, {'$set' => JSON.parse(request.body.read.to_s).reject{|k,v| k == '_id'}})
  ""
end

def to_bson_id(id) BSON::ObjectId.from_string(id) end
def from_bson_id(obj) obj.merge({'_id' => obj['_id'].to_s}) end
