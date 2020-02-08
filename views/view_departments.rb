require './build'
require 'json'
require "./tool"
d=JSON.parse(gets)

puts(Node.new(:div, id: :popup) {
  self << FlexTable.new() {
    row() {
      span() {
        "Hanley Department List"
      }
    }.style! 'background-color': :darkblue, color: :azure
  
    self << (FlexTable.new() {
    http(:get, :departments).each do |d|
      row() {
        span(id: d, onclick: "popup(\"/view/department/#{d.capitalize}\")") {
          d.upcase
        }.style! margin: :auto, 'min-height': 2.em, 'padding-top': 1.em
      }.style! flex: 0
    end
    }.style!(height:100.px,flex:1, overflow: :auto, position: :relative))
    
    head() { 

      self << '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
      default_style 

    }
    
    row(){
      button(onclick: "do_close()") {"close"}
    }.style! flex:0
  }.add_class("popup")

  button(onclick: "close()") {"Close"}  
  }.style!(display: 'unset').to_s)
