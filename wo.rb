require 'date'
$ECHO_HTTP = true
a,b,_ = ARGV
ARGV.clear

require './tool.rb'

if b
  clear :workorders

  update_many :tasks, interval: 0, data: {interval: 20}

  get(:tasks).each do |t|
    t["next_perform"] = Date.today.prev_day(20).next_day(t["interval"]).to_s
    http :put, :tasks, t["_id"], data: {next_perform: t["next_perform"]}
  end
end

def complete_task t
  t=find(:tasks, order: t)[0]
  s=Date.today
  e=s.next_day(t["interval"])
  http :put, :tasks, t["_id"], data: {next_perform: e.to_s} 
end

def generate_wo
  orders = {}
  
  open = find :workorders, closed: nil
  e={}
  get(:tasks).find_all do |t|
    q=Date.parse(t["next_perform"])
    (Date.today-q).to_i >= 0
  end.find_all do |t|
    !open.find do |wo| wo["tasks"].map do |wt| wt["_id"] end.index t["_id"] end
  end.each do |t|
    q=(e[t["equip"]]||=find_one(:equipment, order: t["equip"]))
  
    o = ((orders[t["craft"]]||={})[q["department"]] ||= {tasks: [],
     equip: "#{t["craft"]} routine",
     type: "PM", priority: "ASAP",
     dept: "#{q["department"]}",
     date: Date.today.to_s, description: "Time Generated PM: #{t["craft"]}"
    })
    
    t["equip-name"] = q["name"]
    t["department"] = q["department"]
    o[:tasks] << t
  end
  
  puts(orders.map do |k,v| v end)
  a = orders.map do |k,v| 
   v.map do |kk,vv|
     vv
   end
  end.flatten
  a.every(10).each do |s|
    create_many :workorders, s
  end
rescue => e
 p e
 p e.backtrace.join
end

generate_wo if a
