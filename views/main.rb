
row() {
  div().style! flex: 1
  
  div(onclick: "open_window(\"workorders\", \"/hanley/cmms/view/workorders\")"){
    h2() {
	  "Work Orders"
    }.style! 'vertical-align': :top
    img(src: '/img/wo.png').style! width:3.em    
  }.style! margin: :auto, 'min-width': 20.vw, cursor: :pointer,flex:1


  div(onclick: "popup(\"/view/departments\")"){
    h2() {
	  "Equipment"
    }.style! 'vertical-align': :top
    img(src: '/img/equip.svg').style! width:3.em
  }.style! margin: '', 'min-width': 20.vw, cursor: :pointer, flex:1, 'vertical-align': :bottom

  div(onclick: "window.open(\"/hanley/cmms/view/inventory\", \"inventory\")") {
    h2() {
	  "Inventory"
    }.style! 'vertical-align': :top
    img(src: '/img/inv.png').style! width:3.em
  }.style!(margin: :auto, 'min-width': 20.vw, cursor: :pointer, flex: 1)
  
  div().style! flex: 1
}.style!(flex: 1, 'text-align': :center)

row() {
  span() {"Hanley Plant - CMMS v0.1 (c) km-does.xyz 2020"}.style! margin: :auto
}.style! flex:1, 'text-align': :center 

script {
  """
  window.name='cmms-main';
  
if ('serviceWorker' in navigator) {
  navigator.serviceWorker
    .register('/service-worker.js')
    .then(() => {
      console.log('Service worker registered');
    })
    .catch(err => {
      console.log('Service worker registration failed: ' + err);
    });
}  
  """
}        
