require 'mongo'

class Store
  attr_reader :site, :db
  def initialize site
    @site = site
    @db = Mongo::Client.new("mongodb://localhost",database:"#{site}")
  end
  
  def to_bson_id(id) BSON::ObjectId.from_string(id) end
  def from_bson_id(obj) obj.merge({'_id' => obj['_id'].to_s, 'time' => obj['_id'].to_time}) end  
  
  def get thing, opts={}
    opts[:_id] = to_bson_id(opts[:_id]) if opts[:_id]
    
    a=db[thing].find(opts).to_a.map do |o| 
      o = from_bson_id(o)
      next yield o if block_given? 
      next o
    end
    
    if opts[:_id] or opts[:order] or opts["_id"] or opts["order"]
      return a.first
    end
    
    return a
  end
  
  def put thing, opts={}
    opts[:_id] = to_bson_id(opts[:_id]) if opts[:_id]
    data=opts.delete(:data) || opts.delete("data")
    db[thing].update_many(opts, {'$set' => data.reject{|k,v| k == '_id'}}).documents
  end

  def post thing, *things
  things=things.flatten
    s = (db[thing].distinct("order").last ||0) rescue 0
   
    things.each do |t| ;t[:order]=(s+=1) end
    db[thing].insert_many(things).inserted_ids.map do |o| 
      next yield o.to_str if block_given? 
      next o.to_str
    end
  end
  
  def delete thing, opts={}
    opts[:_id] = to_bson_id(opts[:_id]) if opts[:_id]  
    db[thing].delete_many(opts).documents
  end
  
  def clear thing
    db[thing].drop
    {}
  end
  
  def json method, *o, &b
    send(method, *o, &b).to_json
  end
  
  def routes ins
    store = self
    ins.instance_eval do
      get "/:site/api/:thing"          do store.get(params[:thing]).to_json end
      get "/:site/api/:thing/:id"      do store.get(params[:thing],  _id:   params[:id]).to_json end
      get "/:site/api/:thing/order/:o" do store.get(params[:thing],  order: params[:o]).to_json end
      post "/:site/api/:thing"       do store.post(params[:thing],   JSON.parse(request.body.read)).to_json end
      put "/:site/api/:thing"        do store.put(params[:thing],    JSON.parse(request.body.read)).to_json end
      put "/:site/api/:thing/:id"    do store.put(params[:thing],    _id: params[:id], data: JSON.parse(request.body.read)).to_json end      
      delete "/:site/api/:thing/:id" do store.delete(params[:thing], _id: params[:id]).to_json end
      delete "/:site/api/:thing"     do store.delete(params[:thing], JSON.parse(request.body.read)).to_json end
    end
  end
  
  def client uri="http://localhost:4567"
    Client.new(site, uri+"/#{site}")
  end
  
  $ECHO_HTTP = true
  
  class Client
    attr_reader :uri, :site
    def initialize site, uri
      @uri = uri; @site = site
    end
    
	def http method, *o, data: {}
	  cmd="curl -X #{method.to_s.upcase} -d '#{data.to_json}' #{uri}/api/#{o.join("/")} 2>/dev/null"
	  puts cmd if $ECHO_HTTP
	  JSON.parse(`#{cmd}`)
	end    
    
    def get thing,*o
      h = {}
      h = o.pop if o[-1].is_a?(Hash)
    
      http :get,thing,*o
    end
    
    def post thing, obj
      http :post, thing, data: obj
    end
    
    def put thing, *o, obj
      http :put, thing, *o, data: obj
    end
  end
end

class Array
  def every i
    n = []
    e=-1
    while e <= length-1
      n << self[(e+1)..(e+i)]
      e = e+i
    end
    n
  end
end

if __FILE__ == $0
require 'pry'
store = Store.new('test')
require 'sinatra'
store.routes self
Thread.new do
binding.pry
end
end
