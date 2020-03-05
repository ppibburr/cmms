require './store/lib/store'

$store = Store.new('hanley-cmms')

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

if __FILE__ == $0
require 'pry'
store = Store.new('hanley-cmms')
require 'sinatra'
store.routes self
Thread.new do
binding.pry
end
end
