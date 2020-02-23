require 'json'

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

if ARGV[0]
$ECHO_HTTP=true
require 'pry'
begin
  pids = JSON.parse(File.open('pid.json','r').read)
  pids.keys.each do |k|
    c="kill -9 #{pids[k]}"
    puts c
    `#{c}`
  end
rescue Errno::ENOENT
end

DB      = IO.popen("mongod")
sleep 3
SERVICE = IO.popen("ruby app.rb -o 0.0.0.0")

File.open('pid.json', 'w') do |f|
  f.puts({
    db: DB.pid,
    service: SERVICE.pid
  }.to_json)
end

Thread.new do
  loop do
    puts SERVICE.gets
    #puts DB.gets
  end
end

#sleep 1
end

def http method, *o, data: {}
  cmd="curl -X #{method.to_s.upcase} -d '#{data.to_json}' http://localhost:4567/hanley/cmms/api/#{o.join("/")} 2>/dev/null"
  puts cmd if $ECHO_HTTP
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
  http :delete, type
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

def create_many type, a
  http :post, type, data: a
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

def init type: nil
  h={
    departments: "./dept.rb",  
    inventory:   "./inv.rb",      
    equipment:   "./import_ceric.rb"      ,
    workorders:  "./wo.rb 1 1",      
  }

  if !type
    h.keys.each do |k|
      init type: k
    end 
  else
    rb = h[type]
    puts "Init DB: #{type} ..."
    system "ruby #{rb} 2>/dev/null"
    puts "done."
  end
end

def dump

end

def restore type: nil
  if type
  
    return 
  end
  
  
end

def amount of: nil
  if of
    get(of).length
  else
    puts "No type of"
  end
end

if ARGV[0]
  binding.pry
else
  #send(JSON.parse(gets))
end

