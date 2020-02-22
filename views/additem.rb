  mod = false
  if data["id"]
    data = find_one(:inventory, order: data['id'].to_i)
    mod  = data["_id"]

  else
    data = {
    
    }
  end

  self << (FlexTable.new(class: 'invadd') {
  
  row() {
    label(for: 'input-inv-location') {"Location:"}.style! flex: 1
    self << DataList.new(value: data["location"].to_s, id: 'inv-location', label: "Location", options: http(:get, :inventory, :locations)).style!(flex: 2, 'min-width': 6.em)
  }.style! flex: 0
  
  row() {
    label(for: :cost) {"Cost:"}.style! flex: 1
    input(id: :cost, value: (data["price"] || 0.0).to_s.gsub("$",'').to_f,type: :number, step: 0.5, placeholder: "Cost", id: "inv-cost") {}.style!(flex: 2)
  }.style! flex: 0
  
  row() {
    label(for: 'input-inv-vendor') {"Vendor:"}.style! flex: 1  
    self << DataList.new(value: data["manufacturer"].to_s, id: "inv-vendor", label: "Vendor", options: http(:get, :vendors)).style!(flex: 2)
  }.style! flex: 0

  row() {
    label(for: 'input-inv-model') {"Model #:"}.style! flex: 1   
    input(value: data["model_no"].to_s, type: :text, id: "inv-model", placeholder: "Model #").style!(flex: 2)
  }.style! flex: 0
  
  row() {
    label(for: :qty) {"Quantity:"}.style! flex:1
    label(for: :reorder) {"Reorder at:"}.style! flex:1
    label(for: :stock) {"Restock level:"}.style! flex:1
    
  }.style! flex:0
  row() {
    input(id: :qty, value: data["quantity"] || 0, type: :number, step: 1, placeholder: "Quantity").style! flex: 1,width:2.em
    input(id: :reorder, value: data["min"] || 1,      type: :number, step: 1, placeholder: "Reorder level").style! flex: 1,width:2.em
    input(id: :stock, value: data["fill"] || 2,     type: :number, step: 1, placeholder: "Fill amount").style! flex: 1,width:2.em
  }.style! flex: 0
    
  
  textarea(id: 'inv-description', placeholder: "Enter item description and useful information....") {
    data["description"].to_s
  }.style! flex: 1
    
  script() {
    """

    """
  }

  row() {
    if mod
      button(onclick: "delete_inventory(\"#{mod}\")") {"Delete"}
      button(onclick: "update_inventory(\"#{mod}\")") {"Update Item"}
    else
      button(onclick: "add_inventory()") {
        "Add Item"
      }
    end
  }.style! flex: 0
  }.style!(flex: 1))
