require 'rubygems'
require 'sinatra'
require 'mongo'
require 'json'

DB = Mongo::Client.new("mongodb://localhost",database:"mydb")
require 'open3'
def build file, data
  Open3.popen3("ruby ./views/#{file}") do |i,o,e,w|
    i.puts data
    succ = o.read
    err = e.read
    if err.empty?
     succ
    else
      err.gsub("\n","<br>")
    end 
  end
end

get '/' do
  build "workorder.rb", DB["workorders"].find.to_a.map{|t| from_bson_id(t)}.to_json
end

get '/create/workorder' do
  build "create_workorder.rb", params["description"]
end

get '/view/workorder/:id' do
  build "view_workorder.rb", get_thing_by_field(:workorders,"order", params[:id].to_i)
end

get '/api/:thing' do
  DB[params[:thing]].find.to_a.map{|t| from_bson_id(t)}.to_json
end

def get_thing_by_field thing,fld,val
  DB[thing].find("#{fld}": val).to_a[0].to_json
end

def get_thing thing,id
  from_bson_id(DB[thing].find("_id": to_bson_id(id)).to_a[0]).to_json
end

get '/api/:thing/:id' do
  get_thing(params[:thing], params[:id])
end

post '/api/:thing' do
  obj = JSON.parse(request.body.read.to_s)
  obj["order"] = DB[params[:thing]].distinct("order").sort.last+1 rescue 1
  oid = DB[params[:thing]].insert_one(obj)
  oid=oid.inserted_id
  "{\"_id\": \"#{oid.to_s}\"}"
end

delete '/api/:thing/:id' do
  DB[params[:thing]].delete_one('_id' => to_bson_id(params[:id]))
  {delete: params[:id]}.to_json
end

put '/api/:thing/:id' do
  DB[params[:thing]].update_one({'_id' => to_bson_id(params[:id])}, {'$set' => JSON.parse(request.body.read.to_s).reject{|k,v| k == '_id'}})
  ""
end

def to_bson_id(id) BSON::ObjectId.from_string(id) end
def from_bson_id(obj) obj.merge({'_id' => obj['_id'].to_s}) end
