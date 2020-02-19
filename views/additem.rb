
  self << DataList.new(label: "Location", options: http(:get, :inventory, :locations)).style!(flex: 0)
  
  input(type: :text, placeholder: "Cost") {}.style!(flex: 0)

  self << DataList.new(label: "Vendor", options: http(:get, :vendors)).style!(flex: 0)

  self << DataList.new(label: "Model #", options: []).style!(flex: 0)
  
  textarea(id: :part_description, placeholder: "Enter item description and useful information....") {
  
  }.style! flex: 1
  
  button() {
    "Add Item"
  }

