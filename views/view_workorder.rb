order = data

row() {
  self << DataList.new(id: :priority, label: "Priority", options: [
    "ASAP",
    "EMRG",
    "SCHD",
  ], value: order["priority"])
  
  self << DataList.new(id: :type, label: "TYPE", options: [
    "PM",
    "SAFETY",
    "REACT",
  ], value: order["type"])

  self << DataList.new( id: :department, value: order["dept"], label: "Dept", options: get(:departments).map do |dept| dept["name"] end.push("pm").sort)

  list = find(:equipment, department: order["department"]).map do |e|
     e["order"].to_s+" "+e["name"]
  end

  equip = find(:equipment, order: order["equipment"]) || []
  equip = equip[0] || {"name":"MISC equipment"}
  equip = equip["name"]

  self << DataList.new(id: :equipment, label: "Equip", options: list, value: equip)
}.style! flex: 0, "min-height": "fit-content"

row(id: :date) {
  order["date"]
}.style! flex: 0, "min-height": "fit-content", 'font-family': :monospace

textarea(id: :description) {
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

self << List.new(header: ["Interval", "Craft", "Dept","Equip" "Description"], columns: [0, 0,1,1, 3] ,data: (data["tasks"]||[]).map do |t| [t["interval"],t["craft"], (e=find_one(order: t["equip"]))["dept"], e["name"], t["description"]] end) {
  this=self
  render do |_,r,c|
    ele(:div) {
      next _ if r < 0
      span {_}
    }.style!("min-width": 60.px).style! 'font-family': :monospace
  end
}

row() {
  if order["order"]
    button(onclick: "window.open(\"/hanley/cmms/view/print/workorder/#{order["order"]}\",\"print\")") {"Print"}
    button(onclick: "delete_workorder(\"#{order["_id"]}\")") {"Delete"}
    button(onclick: "close_workorder(\"#{order["_id"]}\")") {"Close"}
    button(onclick: "update_workorder(\"#{order["_id"]}\")") {"Update"}
  else
    button(onclick: "create_workorder(\"#{order["_id"]}\")") {"Create"}
  end
}.style! "justify-content": "space-between"

