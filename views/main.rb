require './build'
require 'json'
require "./tool"
gets
puts(Node.new(:div) {
  self << FlexTable.new() {
    row() {
      img(src: "/img/gg-logo.jpg") {}.style! margin: :auto
    }.style! flex: 0,"background-color": :white

    row() {
      span() {
        "Hanley CMMS"
      }
    }.style! 'background-color': :darkblue, color: :azure
  


    row() {
      span( onclick: "window.open(\"/view/workorders\",\"workorders\")") {
        "Work Orders"
      }.style! margin: :auto, 'min-height': 2.em, 'padding-top': 1.em
    }  

    row() {
      span( onclick: "popup(\"/view/departments\")") {
        "Equipment"
      }.style! margin: :auto, 'min-height': 2.em, 'padding-top': 1.em
    } 
    
    row() {
      a(href:"#", onclick: "/view/inventory") {
        "Inventory"
      }.style! margin: :auto, 'min-height': 2.em, 'padding-top': 1.em
    }         
    
    head() { 
      title {"Hanley CMMS | Main"}
      self << '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
      default_style 
      default_script()
    }
  }.style!(flex:0, "background-color": "azure", color: "darkblue","min-height": "100vh", "max-height": "100vh", width: "55vw", "min-width": "358px",margin: :auto, border: "solid 1px")

  div(id: "popup") {
  
  }
}.to_s)
