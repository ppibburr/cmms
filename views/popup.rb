require './build'
require 'json'
require "./tool"

obj   = JSON.parse(d=gets)
data  = obj["data"]
title = obj["title"]
view  = obj["view"]

puts(FlexTable.new() {
    row() {
      span() {title || "Untitled"}
      img(src: "/img/close.png", onclick: 'do_close()').style! height:1.em
    }.style! flex: 0,"background-color": "#a090af", color: 'black', 'justify-content': 'space-between'

    begin
      eval(open("./views/"+view).read,binding, "./views/"+view, 1)
    rescue => e
      self << rbml("error.rb", {object: obj, error: e.to_s, backtrace: e.backtrace, silent: true})
    end
   #button(onclick: "do_close()") {"Close"}  
  }.add_class("popup"))
