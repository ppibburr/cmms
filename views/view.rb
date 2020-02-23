require './tool.rb'
require 'json'

obj= JSON.parse gets
data=d=obj["data"]

f = "./views/"+obj["view"]

puts eval(open(f).read, binding, f, 1)
