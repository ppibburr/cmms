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
  build "main.rb", {}.to_json
end

get '/view/workorders' do
  build "workorder.rb", DB["workorders"].find.to_a.map{|t| from_bson_id(t)}.to_json
end

get '/create/workorder' do
   build "view_workorder.rb", {date: Time.now.to_s,description: params["description"]}.to_json
end

get '/view/workorder/:id' do
  build "view_workorder.rb", get_thing_by_field(:workorders,"order", params[:id].to_i)
end

get "/view/departments" do
  build "view_departments.rb", {}
end

get "/view/department/:dept" do
  build "view_department.rb", {department: params[:dept], equipment: find_thing(:equipment, "department": params[:dept])}.to_json
end

get '/view/equipment/:id' do
  build "view_equipment.rb", get_thing_by_field(:equipment,"order", params[:id].to_i)
end

get '/view/workhistory/:id' do
  build "view_work_history.rb", get_thing_by_field(:equipment,"order", params[:id].to_i)
end

get "/api/workorder_types" do
  [
    :PM,
    :SAFETY,
    :REACT,
    :PROJ
  ].to_json
end

get "/api/workorder_priorities" do
  [
    :ASAP,
    :EMERG,
    :SCHD
  ].to_json
end

get "/api/crafts" do
  [
    :ELE_1,
    :ELE_2,
    :MECH_1,
    :MECH_2,
    :CTRL_1,
    :LUBE_1,
    :CONTR
  ].to_json
end

get "/api/departments" do
  [
    "office",
    "packaging",
    "manufacturing",
    "grinding",
    "magroom",
    "crushing",
    "thinbrick",
    "warehouse",
    "parkinglot",
    "maintenance"
  ].to_json
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

def find_thing thing, h={}
  DB[thing].find(h).to_a.map do |obj|
    from_bson_id(obj)
  end
end

get "/api/find/:thing" do
  h = JSON.parse(request.body.read.to_s)
  find_thing(params[:thing], h).to_json
end

get '/api/:thing/:id' do
  get_thing(params[:thing], params[:id])
end

post '/api/:thing' do
  obj = JSON.parse(request.body.read.to_s)
  obj["order"] = DB[params[:thing]].distinct("order").sort.last+1 rescue 1
  oid = DB[params[:thing]].insert_one(obj)
  oid=oid.inserted_id
  "{\"_id\": \"#{oid.to_s}\", \"order\": #{obj["order"]}}"
end

delete '/api/:thing/:id' do
  DB[params[:thing]].delete_one('_id' => to_bson_id(params[:id]))
  {delete: params[:id]}.to_json
end

put '/api/:thing/:id' do
  DB[params[:thing]].update_one({'_id' => to_bson_id(params[:id])}, {'$set' => JSON.parse(request.body.read.to_s).reject{|k,v| k == '_id'}})
  {_id: params[:id]}.to_json
end

def to_bson_id(id) BSON::ObjectId.from_string(id) end
def from_bson_id(obj) obj.merge({'_id' => obj['_id'].to_s}) end
