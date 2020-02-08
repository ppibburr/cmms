require "./build.rb"



def build
  Node.new(:div, id: :popup) {
    self << '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
    
    self << FlexTable.new() {
      row() {
        "Create Work Order"
      }.style! color: :azure, "background-color": :darkblue
  
      row() {
        self << DataList.new(label: "Priority", options: [
          "ASAP",
          "EMRG",
          "SCHD",
        ])
        
        self << DataList.new(label: "TYPE", options: [
          "PM",
          "SAFETY",
          "REACT",
        ])

        self << DataList.new(label: "Dept", options: [
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
        ])

      }.style! flex: 0
      row() {
        gets
      }.style! flex: 1, border: "solid 1px rosybrown"
        div() {
          self << DataList.new(value: "", label: "Craft", options: [
            "ELEC",
            "MECH",
            "CTRL",
            "CNTR"
          ]).style!(flex:1)
          self << DataList.new(label: "Task", options: [
            "ELEC",
            "MECH",
            "CTRL",
            "CNTR"
          ]).style!(flex:1)
          button(){
            "Add"
          }.style! height: "fit-content",flex: 0  
        }.style! display: :flex, "flex-direction": "row", flex: 0
      self << List.new(header: ["Craft", "Description"], columns: [0, 1] ,data: []) {
        this=self
        render do |_,r,c|
          ele(:div) {
            next _ if r < 0
            span {_}.style! 'font-family': :monospace
          }
        end
      }
      
      row() {
        button(onclick: "submit_workorder()") {"Submit"}
        button(onclick: "cancel_create_workorder()") {"Cancel"}
      }
      
  
    }.style!("min-height": "60vh", "max-height": "60vh", "min-width":"76vw", margin: "20bh 12vw","border": "solid 1px darkblue", "background-color": "aliceblue")
  
    
  
    default_style
    
  }.style! height: "100vh", width: "100vw", position: :fixed, top: 0, left: 0, "background-color": "rgba(39, 55, 77, 0.59)"
end

puts build
