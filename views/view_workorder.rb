require "./build.rb"
require 'json'


def build(order)
  Node.new(:div, id: :popup) {
    self << '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
    
    self << FlexTable.new() {
      row() {
        "Work Order #{order["order"]}"
      }.style! color: :azure, "background-color": :darkblue
  
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
      }.style! flex: 0, "min-height": "fit-content"
      
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

      self << List.new(header: ["Craft", "Description"], columns: [0, 1] ,data: order["tasks"]) {
        this=self
        render do |_,r,c|
          ele(:div) {
            next _ if r < 0
            span {_}
          }.style!("min-width": "60px")
        end
      }
      
      row() {
        button(onclick: "delete_workorder()") {"Delete"}
        button(onclick: "close_workorder()") {"Close"}
        button(onclick: "update_workorder()") {"Update"}
      }
      
  
    }.style!("min-height": "60vh", "max-height": "60vh", "min-width":"76vw", margin: "20% 12% 20% 12%","border": "solid 1px darkblue", "background-color": "aliceblue")
  
    
  
    default_style
    
  }.style! height: "100vh", width: "100vw", position: :fixed, top: 0, left: 0, "background-color": "rgba(39, 55, 77, 0.59)"
end

puts build(JSON.parse(gets))
