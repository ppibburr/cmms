require 'json'
id = ARGV.shift
require './tool.rb'

o = find_one(:workorders, order: id.to_i)
e = find_one(:equipment, order: o["equip"])
puts """
#{o["date"]}\n#{o["dept"]} #{e["location"]} #{e["name"]}
--------------------------------------------------------------
#{o["description"]}

#{o["tasks"].map do |t| 
  t=http(:get, :tasks, t["_id"]) 
  "#{t["craft"]} - #{t["description"]}"
end.join("\n")}
"""
