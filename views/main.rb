row() {
  div(onclick: "window.open(\"/view/workorders\",\"workorders\")"){
    img(src: '/img/wo.png').style! width:3.em
    h2() {
	  "Work Orders"
    }.style! 'vertical-align': :top
  }.style! margin: :auto, 'min-width': 20.vw, cursor: :pointer
}.style! flex: 1    

row() {
  div(onclick: "popup(\"/view/departments\")"){
    img(src: '/img/equip.svg').style! width:3.em
    h2() {
	  "Equipment"
    }.style! 'vertical-align': :top
  }.style! margin: :auto, 'min-width': 20.vw, cursor: :pointer
}.style! flex: 1   

row() {
  div(onclick: "window.open(\"/view/inventory\", \"inventory\")") {
    img(src: '/img/inv.png').style! width:3.em
    h2() {
	  "Inventory"
    }.style! 'vertical-align': :top
  }.style! margin: :auto, 'min-width': 20.vw, cursor: :pointer
}.style! flex: 1

row() {}.style! flex:1 

script {
  """
  window.name='cmms-main';
  """
}        
