require './site'
require './build'

require './loader'

def content!
  self << eval(open(f=$data["file"]).read, binding, f, 1)
end

common = "./sites/#{site}/common.rb"
common = "./common.rb" if !File.exist?(common)

puts eval(open(common).read, binding, common, 1).to_s
