require 'date'
$ECHO_HTTP = true
a,b,_ = ARGV
ARGV.clear

require './store/lib/store'

$store = Store.new('hanley-cmms')

if b
  $store.clear :workorders

  $store.put :tasks, interval: 0, data: {interval: 20}

  $store.get(:tasks).each do |t|
    t["next_perform"] = Date.today.prev_day(17).next_day(t["interval"]+rand(9)).to_s
    $store.put :tasks, _id: t["_id"], data: {next_perform: t["next_perform"]}
  end
end

def complete_task t
  t=$store.get(:tasks, order: t)
  s=Date.today
  e=s.next_day(t["interval"])
  $store.put :tasks, _id: t["_id"], data: {next_perform: e.to_s} 
end

def generate_wo
  orders = {}
  
  open = $store.get(:workorders, closed: nil)
  e={}
  $store.get(:tasks).find_all do |t|
    q=Date.parse(t["next_perform"])
    (Date.today-q).to_i >= 0
  end.find_all do |t|
    !open.find do |wo| wo["tasks"].map do |wt| wt["_id"] end.index t["_id"] end
  end.each do |t|
    q=(e[t["equip"]]||=$store.get(:equipment, order: t["equip"]))

    o = ((orders[t["craft"]]||={})[q["department"]] ||= {tasks: [],
     type: "PM", priority: "ASAP",
     dept: "#{q["department"]}",
     description: "Time Generated PM: #{t["craft"]}"
    })
    

    o[:tasks] << t["_id"]
  end
  
  puts(orders.map do |k,v| v end)
  a = orders.map do |k,v| 
   v.map do |kk,vv|
     vv
   end
  end.flatten
  a.every(10).each do |s|
    $store.post :workorders, s
  end
rescue => e
 p e
 p e.backtrace.join
end

generate_wo if a
