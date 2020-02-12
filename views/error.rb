require './build'
require 'json'

obj = JSON.parse(gets)
err = obj["error"]
backtrace = obj["backtrace"].map do |i| [i] end

puts(Node.new(:div) {
self << List.new(header: ["Error: #{err}"], data: backtrace, columns: [1]) {
	this=self
	render do |_,r,c|
	  ele(:div) {
	    _
	  }
	end
}.style!(flex:1)
}.style!(border: :solid, flex:1, display: :flex).to_s)
