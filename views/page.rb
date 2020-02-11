require './build'
require 'json'
require "./tool"

obj   = JSON.parse(gets)
view  = obj["view"]
d = data = obj["data"]
title = obj["title"]

puts(Node.new(:html) {
  head() { 
    title {"Hanley CMMS | #{title}"}

    self << '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
    self << '<meta name="mobile-web-app-capable" content="yes">'
    link(rel: "stylesheet", href: "/css/default.css")
    script(src: "/js/core.js")  
  } 

  self << FlexTable.new() {
    row() {
      img(src: "/img/gg-logo.jpg") {}.style! margin: :auto
      span(onclick: "window.close()") {"X"}.add_class("close-button")
    }.style! flex: 0,"background-color": :white
  
    eval(open("./views/"+view).read)
    
  }.add_class(:main)
   
  div(id: "popup") {
  
  }
}.to_s)
