
FILES=[
  "./pkg.csv"
]


DB = {}
require 'json'
class Task
  attr_accessor :interval, :description, :craft
  def initialize desc, interval
    @description = desc 
    @interval    = interval
    
    @craft = :ELE_1 if desc =~/lectri/
    @craft = :LUBE_1 if desc =~ /ubri/
    @craft = :PM_1 if desc =~ /ension/
    @craft = :PM_1 if desc =~ /lean/
    @craft = :MECH_1 if desc =~ /echanical/   
    @craft = :PM_1 if desc =~ /nuemat/         
  
    @craft ||= :PM_1
  end
  
  def to_h
    {
      description: description,
      interval:    interval,
      craft:       craft
    }
  end
  
  def to_json *o
    to_h.to_json
  end
end

class Machine
  attr_accessor :name, :tasks, :location, :department, :inventory, :downtime, :prev_downtime

  def initialize name
    @name = name
    @tasks = []
    @inventory = []
    @downtime = 0.0
    @prev_downtime = 0.0
    @@machines << self
  end

  def to_h
    {
      name: name,
      tasks: tasks,
      location: location,
      department: department,
      inventory: inventory,
      downtime: downtime,
      prev_downtime: prev_downtime
    }
  end
  
  def to_json *o
    to_h.to_json
  end
  
  @@machines=[]
  
  def self.iter
    @@machines
  end
end

require "./tool.rb"

FILES.each do |f|
  go = false
  buff=open(f).read.encode('UTF-8', :invalid => :replace).gsub(/\r/,'').split("\n")
  data = [] 
  
  buff.each do |l|
    row = l.split(",")
    if row[0] && row[0].strip != ""
      go = true
    end
    
    if go
      data << row
    end
  end
  machine = []
  dupli = false
  data.each do |row|
    if row[0] && row[0].strip != ""
      if row[1] =~ /(\([0-9]+\))/
    
        n=$1
        row[1]=row[1].gsub($1,"").strip
       
        dupli = true if n && (n != "(1)")
        dupli = false if n =~ /1/
      end
      machine = [Machine.new(row[1].clone)]
      if dupli
        machine[0].name << " #1"
        machine << m=Machine.new(row[1])
        m.name << " #2"
      end
      puts "Machine: #{machine}"
    end
   
    if machine[0] && (!row[0] || row[0].strip == "")

      row.uniq[-1] =~ /\(([0-9]+) Days\)/
      if row[1] != ""
        next unless row[1]
        machine.each do |m| 
          m.location = "dehacker"
          m.department = "Packaging"
          puts  Task.new(row[1],$1).to_h.to_json()
          resp = http(:post, :tasks, data: Task.new(row[1],$1).to_h) 
          m.tasks << resp
        end
      end
    end
  end
end



p(Machine.iter.map do |m|
  obj = http(:post,"equipment", data: m.to_h)
  m.tasks.each do |t|
    http(:put, :tasks, t["_id"], data: {machine: obj["order"]})
  end
  m.name
end)
