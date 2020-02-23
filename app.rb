require 'rubygems'
require 'sinatra'
require 'mongo'
require 'json'
require 'sinatra'

set :static_cache_control, [:public, :private,:max_age => 0]

DB = Mongo::Client.new("mongodb://localhost",database:"mydb")
require './build'

def build view, data
  rbml view, data
end

get '/hanley/cmms/' do
cache_control :public, :no_cache
  build "page.rb", {"view": "main.rb", "title": "Home", "data": {}}
end

get '/hanley/cmms/view/workorders' do
cache_control :public, :no_cache
  build "page.rb", {"view": "workorder.rb", title: "Work Orders"}
end

get "/hanley/cmms/view/workorders/list" do
  build "view.rb", {"view": "list_workorders.rb", data: DB["workorders"].find(closed: nil).to_a.map{|t| from_bson_id(t)}}
end

get "/hanley/cmms/view/inventory/list" do
  build "view.rb", {"view": "list_inventory.rb"}#data: DB["inventory"].find(closed: nil).to_a.map{|t| from_bson_id(t)}}
end

get '/hanley/cmms/create/workorder' do
   build "popup.rb", view: "view_workorder.rb", title: "Create Work Order", data: {date: Time.now.to_s,description: params["description"], department: params["department"]}
end

get '/hanley/cmms/view/workorder/:id' do
  build "popup.rb", view: "view_workorder.rb", title: "Work Order: #{params[:id]}", data: get_thing_by_field(:workorders,"order", params[:id].to_i)
end

get "/hanley/cmms/print/inventory" do
  content_type 'text/plain'
  "<code>"+`ruby ./print_inventory.rb`.gsub("\n","<br>").gsub(" ","&nbsp;")+"</code>"
end

get "/hanley/cmms/view/print/workorder/:id" do
  build "page.rb", {view: "print_wo.rb", title: "Print Work Order: #{id=params[:id]}", data: {id: id}} 
end

get '/hanley/cmms/view/inventory' do
  build "page.rb", {"view": "inventory.rb", title: "Inventory"}
end

get "/hanley/cmms/view/inventory/:id" do
  build "popup.rb", {"view": "additem.rb", title: "Modify Inventory Item: #{params[:id]}", data:{id: params[:id].to_i}}
end

get "/hanley/cmms/view/additem" do
  build "popup.rb", {"view": "additem.rb", title: "Add Inventory Item", data:{}}
end


get "/hanley/cmms/view/departments" do
  build "popup.rb", {"view": "view_departments.rb", title: "Department List", data:{}}
end

get "/hanley/cmms/view/department/:dept" do
  build "popup.rb", {view: "view_department.rb", title: "#{params[:dept]} Equipment List", data: {department: params[:dept], equipment: find_thing(:equipment, "department": params[:dept])}}
end

get '/hanley/cmms/view/equipment/:id' do
cache_control :public, :no_cache
  build "page.rb", {"view": "view_equipment.rb", title: "Equipment #{params[:id]}", data: get_thing_by_field(:equipment,"order", params[:id].to_i)}
end

get '/hanley/cmms/view/workhistory/:id' do
  build "popup.rb", {"view": "view_work_history.rb", title: "Equipment ID: #{params[:id]} Work History", "data": get_thing_by_field(:equipment,"order", params[:id].to_i)}
end

get "/hanley/cmms/api/inventory/locations" do
  DB["inventory"].find.to_a.map do |i| i["location"] end.uniq.to_json 
end

get "/hanley/cmms/api/inventory/locations" do
  DB["inventory"].find.to_a.map do |i| i["location"] end.uniq.to_json 
end

get "/hanley/cmms/api/vendors" do
  DB["inventory"].find.to_a.map do |i| i["manufacturer"] end.uniq.to_json 
end

get "/hanley/cmms/api/workorder_types" do
  [
    :PM,
    :SAFETY,
    :REACT,
    :PROJ
  ].to_json
end

get "/hanley/cmms/api/workorder_priorities" do
  [
    :ASAP,
    :EMERG,
    :SCHD
  ].to_json
end

get "/hanley/cmms/api/crafts" do
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

get "/hanley/cmms/api/departments" do
  DB["departments"].find.to_a.map{|t| from_bson_id(t)}.to_json
end

get "/hanley/cmms/api/departments/:dept/locations" do
  DB["departments"].find_one(name: params[:dept])["locations"].to_json
end


get "/hanley/cmms/api/departments/:dept" do
  DB["departments"].find(name: params[:dept]).to_a.map{|t| from_bson_id(t)}[0].to_json
end


get '/hanley/cmms/api/:thing' do
  DB[params[:thing]].find.to_a.map{|t| from_bson_id(t)}.to_json
end

def get_thing_by_field thing,fld,val
  h={}
  h[fld]=val
  DB[thing].find(h).to_a.map do |obj|
    from_bson_id(obj)
  end[0]
end

def get_thing thing,id
  from_bson_id(DB[thing].find("_id": to_bson_id(id)).to_a[0])
end

def find_thing thing, h={}
  DB[thing].find(h).to_a.map do |obj|
    from_bson_id(obj)
  end
end

get "/hanley/cmms/api/find/:thing" do
  h = JSON.parse(request.body.read.to_s)
  find_thing(params[:thing], h).to_json
end

get '/hanley/cmms/api/:thing/:id' do
  get_thing(params[:thing], params[:id]).to_json
end

post '/hanley/cmms/api/:thing' do
  obj = JSON.parse(request.body.read.to_s)
  if !obj.is_a?(Array)
    obj["order"] = DB[params[:thing]].distinct("order").sort.last+1 rescue 1
    oid = DB[params[:thing]].insert_one(obj)
    oid=oid.inserted_id
    "{\"_id\": \"#{oid.to_s}\", \"order\": #{obj["order"]}}"
  else
    order = DB[params[:thing]].distinct("order").sort.last || 0 rescue 0
    obj.each do |o|
      o["order"] = (order+=1)
    end
    DB[params[:thing]].insert_many(obj)
    obj.to_json
  end
end

delete '/hanley/cmms/api/:thing/:id' do
  DB[params[:thing]].delete_one('_id' => to_bson_id(params[:id]))
  {delete: params[:id]}.to_json
end

put '/hanley/cmms/api/:thing/:id' do
  DB[params[:thing]].update_one({'_id' => to_bson_id(params[:id])}, {'$set' => JSON.parse(request.body.read.to_s).reject{|k,v| k == '_id'}})
  {_id: params[:id]}.to_json
end

delete '/hanley/cmms/api/:type' do
  DB[params[:type]].delete_many
  "{\"delete\": 200}"
end

def to_bson_id(id) BSON::ObjectId.from_string(id) end
def from_bson_id(obj) obj.merge({'_id' => obj['_id'].to_s}) end


#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'haml'

$pwd = "/home/i3/km-does"

def file_listing(directory)
  Dir.glob(directory + '/*')
end

get '/upload' do
  haml :upload
end

post '/upload' do 
  puts file = params[:file]
  puts filename = file[:filename]
  tempfile = file[:tempfile]
  File.open(File.join($pwd, filename), 'w') {|f| f.write tempfile.read}
  redirect '/browse'
end

get '/download/:filename' do |filename|
  file = File.join($pwd, filename)
  send_file(file, :disposition => 'attachment')
end

get '/browse' do
  @files = file_listing($pwd)
  haml :index
end

get '/bfile.rb' do
  file = File.join($pwd, 'bfile.rb')
  send_file(file, :disposition => 'attachment')
end

get '/system' do
  if $download_file
    file = File.join($pwd, $download_file)
    send_file(file, :disposition => 'attachment')
  else
    redirect '/browse'
  end
end

__END__

@@ layout
%html
  %a{:href => '/browse'}Browse Files
  %a{:href => '/upload'}Upload a File
  = yield
  

@@ index
%h1 File Server
%table
  %tr
    %th File
    %th Size
  - for file in @files
    - if File.file?(file)
      %tr
        %td
          %a{:title => file, :href => '/download/' + File.basename(file)}=File.basename(file)
        %td= File.size(file).to_s + "b"

@@upload
%h1 Upload

%form{:action=>"/upload",:method=>'post',:enctype=>"multipart/form-data"}
  %input{:type => "file",:name => "file"}
  %input{:type => "submit",:value => "Upload"}
