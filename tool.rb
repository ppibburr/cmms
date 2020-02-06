

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
  JSON.parse(`curl -X #{method.to_s.upcase} -d '#{data.to_json}' http://localhost:4567/api/#{o.join("/")} 2>/dev/null`)
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

if ARGV[0]
  binding.pry
else
  send(JSON.parse(gets))
end

