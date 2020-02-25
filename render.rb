require './site'
require './build'
require './loader'

puts eval(open(file).read, binding, file, 1).to_s
