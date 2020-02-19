

if ARGV[0]
require 'pry'

DB      = IO.popen("mongod")
SERVICE = IO.popen("ruby app.rb -o 0.0.0.0")

Thread.new do
  loop do
    puts SERVICE.gets
  end
end

sleep 0
end

def http method, *o, data: {}
  cmd="curl -X #{method.to_s.upcase} -d '#{data.to_json}' http://localhost:4567/api/#{o.join("/")} 2>/dev/null"
  puts cmd if false
  JSON.parse(`#{cmd}`)
end

def create_workorder priority: nil, type: nil, dept: nil, equip: nil, tasks: [], description: "dummy order"
  wo = {
    priority: priority,
    type:     type,
    dept:     dept,
    equip:    equip,
    tasks:    tasks,
    description: "#{description}",
    date:     "#{Time.now.to_s}"
  }
  
  resp = http :post, :workorders, data: wo

  http(:get, :workorders, resp["_id"])
end

def delete type, id
  http(:delete, type, id)
end

def get(type,*o)
  http(:get, type,*o)
end

def clear type
  get(type).each do |r| delete type, r['_id'] end
end

def find type, h={}
  http(:get, :find, type, data: h)
end

def find_one type, h={}
  find(type,h)[0]
end

def update type, order, data={}
  obj = find(type, order: order)
  obj.map do |q|
    http(:put, type, q["_id"], data: data)
  end
end

def update_many type, h={}
  data = h.delete :data
  obj = find(type, h)
  obj.map do |q|
    http(:put, type, q["_id"], data: data)
  end
end

def csv *o
  i=0
  find(*o).map do |q|
    o=[]
    a=q.keys
    o << a.join(",") if i == 0
    o << a.map do |k|
      q[k]
    end.join(",")
    o
  end.join("\n")
end

if ARGV[0]
  binding.pry
else
  #send(JSON.parse(gets))
end

