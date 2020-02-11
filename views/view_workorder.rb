order = data

row() {
  self << DataList.new(label: "Priority", options: [
    "ASAP",
    "EMRG",
    "SCHD",
  ], value: order["priority"])
  
  self << DataList.new(label: "TYPE", options: [
    "PM",
    "SAFETY",
    "REACT",
  ], value: order["type"])

  self << DataList.new( value: order["dept"], label: "Dept", options: [
    "Packaging",
    "Manufacturing",
    "Thinbrick",
    "Grinding",
    "Crusher",
    "Office",
    "Warehouse",
    "Scale",
    "Ace's",
    "Parking"
  ])

  self << DataList.new(label: "Equip", options: [
    "PM",
    "SAFETY",
    "REACT",
  ], value: order["equip"])
}.style! flex: 0, "min-height": "fit-content"

row() {
  order["date"]
}.style! flex: 0, "min-height": "fit-content", 'font-family': :monospace

row() {
  order["description"]
}.style! flex: 1, border: "solid 1px rosybrown"

div() {
  self << DataList.new(value: "", label: "Craft", options: [
    "ELEC",
    "MECH",
    "CTRL",
    "CNTR"
  ]).style!(flex:1)
  
  self << DataList.new(value: "", label: "Task", options: [
    "ELEC",
    "MECH",
    "CTRL",
    "CNTR"
  ]).style!(flex:1)
  
  button(){
    "Add"
  }.style! height: "fit-content",flex: 0  
}.style! display: :flex, "flex-direction": "row", flex: 0,"min-height": "fit-content"

self << List.new(header: ["Craft", "Description"], columns: [0, 1] ,data: data["tasks"]) {
  this=self
  render do |_,r,c|
    ele(:div) {
      next _ if r < 0
      span {_}
    }.style!("min-width": 60.px).style! 'font-family': :monospace
  end
}

row() {
  button(onclick: "delete_workorder()") {"Delete"}
  button(onclick: "do_close()") {"Close"}
  button(onclick: "update_workorder()") {"Update"}
}

