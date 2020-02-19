  mod = false
  if data["id"]
    data = find_one(:inventory, order: data['id'].to_i)
    mod  = data["_id"]
  else
    data = {
    
    }
  end

  self << (FlexTable.new(class: 'invadd') {

  self << DataList.new(value: data["location"].to_s, id: 'inv-location', label: "Location", options: http(:get, :inventory, :locations)).style!(flex: 0)
  
  input(value: data["price"].to_s,type: :text, placeholder: "Cost", id: "inv-cost") {}.style!(flex: 0)

  self << DataList.new(value: data["manufacturer"].to_s, id: "inv-vendor", label: "Vendor", options: http(:get, :vendors)).style!(flex: 0)

  input(value: data["model_no"].to_s, type: :text, id: "inv-model", placeholder: "Model #").style!(flex: 0)
  
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
