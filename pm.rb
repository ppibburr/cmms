
require './tool'
today = 2
wo = {}
open_orders = find :workorders, open: true

get(:tasks).find_all do |t|
  t['next_perform'].to_i >= today
end.find_all do |t|
  !open_orders.find do |o| o.tasks.index(t) end
end.each do |t|
  (c = wo[t["machine"]] ||= {
    description: "Time Generated PM",
    type: :PM,
    priority: :ASAP,
    equip: t["machine"],
    date:     "#{Time.now.to_s}",
    dept: find(:equipment, order: t["machine"])[0]["department"],
    tasks: []
  })
  
  c[:tasks] << t
end

wo.each do |o,h|
  http :post, :workorders, data: h
end

p wo
