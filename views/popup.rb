require './build'
require 'json'
require "./tool"

obj   = JSON.parse(gets)
data  = obj["data"]
title = obj["title"]
view  = obj["view"]

puts(FlexTable.new() {
    row() {
      title || "Untitled"
    }.style! flex: 0,"background-color": :darkblue, color: :azure

    eval(open("./views/#{view}").read)
  

    button(onclick: "do_close()") {"Close"}  
  }.add_class("popup"))
