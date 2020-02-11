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
