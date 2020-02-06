require "./build.rb"

class DataList < Node
  attr_accessor :options
  def initialize *o, &b
    label = o[0].delete :label
    @options = o[0].delete :options
    
    super :div, *o do
      this = self
     
      t=Time.now.to_f
     
      l="list-#{t}"
      
      div() {
        input(list: t, id: l, placeholder: label).style! flex:1, width:"20px"
           
        datalist(id: t) {
          this.options.each do |o|
            option(value: o)
          end
        }
      }.style! display: :flex, flex:1
      
      instance_exec b.binding, &b if b
    end
    style! "flex": 1
  end
end

def build
      
  Node.new(:div, id: :create) {
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
            span {_}
          }
        end
      }
      
      row() {
        button(onclick: "submit_workorder()") {"Submit"}
        button(onclick: "cancel_create_workorder()") {"Cancel"}
      }
      
  
    }.style!("min-height": "60vh", "max-height": "60vh", "min-width":"76vw", margin: "20% 12% 20% 12%","border": "solid 1px darkblue", "background-color": "aliceblue")
  
    
  
    default_style
    
  }.style! height: "100vh", width: "100vw", position: :fixed, top: 0, left: 0, "background-color": "rgba(39, 55, 77, 0.59)"
end

puts build
