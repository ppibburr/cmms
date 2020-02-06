require 'json'

def create_work_order priority,type, dept, equip, task
  data = {
    department: dept,
    equipment:  equip,
    priority:   priority,
    type:       type,
    task:       task
  }
  puts data.to_json()
  cmd = %Q[curl -X POST -d #{data.to_json().inspect} http://localhost:4567/api/workorders]
  `#{cmd}`
end

def clear id
  cmd = %Q[curl -X DELETE http://localhost:4567/api/workorders/#{id}]
  `#{cmd}`
end

def list
  cmd = %Q[curl http://localhost:4567/api/workorders]
  JSON.parse(`#{cmd}`)
end

if ARGV[0] == "--clear"
  list.each do |o| clear(o["_id"]) end
  exit
end

puts create_work_order(*ARGV)


