  data = get :inventory

  fields = [
    [],
    data.map do |e| e["location"] end.uniq,
    [],
    [],
    [],
    data.map do |e| e["manufacturer"] end.uniq,
    data.map do |e| e["model"] end.uniq,
    []
  ]
  
  tc=0.0
  data.map do |e| 
    tc+= ((e["price"] = e["price"].to_s.gsub("$",'').to_f)*e["quantity"]) 
  end
  
  row() {
    span() {"Hanley Inventory Items"}
  }.style! flex: 0
  
  row() {
    div() {
      span(class: :total_cost) {"Total Inventory Cost: "}
      b() {
        em() {
          span() {"$%.2f" % tc}.style! color: :black
        }
      }
    }.style! flex: 1, 'border-style': :inset
    
    button(onclick: "popup(\"/view/additem\")") {"Add Item"}.style! flex: 0,"min-width": "fit-content"
    hr()
  }.style! "background-color": "#00ced1"

  div(id: "inventory") {
    div(class: 'loader')
  }.style! flex: 1
  
  button() {
    "Inventory Print View"
  }


  script() {
    """
    /*
    function update_cost(pt, o) {
      val = prompt('Enter new cost', ''+o);
      event.target.innerText = \"$\"+val;
      http('put','/api/inventory/'+pt, {price: parseInt(val)}, function(j) {
        alert(j);
      });
    }
    */
    
    
    function populate_inventory_item() {
      obj = {
        location: id('input-inv-location').value,
        price: parseInt(id('inv-cost').value),
        manufacturer: id('input-inv-vendor').value,
        model_no: id('inv-model').value,
        description: id('inv-description').value,
        fill: parseInt(id('stock').value),
        min: parseInt(id('reorder').value),
        quantity: parseInt(id('qty').value)
      };
      console.log(\"create inventory item\");
      console.log(obj);
      return obj;    
    }

    function delete_inventory(pt) {
      if(confirm('Delete inventory item?')) {
        http('delete','/api/inventory/'+pt, {}, function(resp) {
          console.log(resp);
          id(pt).outerHTML = '';
          window.location = '#page';
        })
      };
    } 
    
    function add_inventory() {
      obj = populate_inventory_item();
      http('post','/api/inventory', obj, function(resp) {
        console.log(resp);
        window.location = '/hanley/cmms/view/inventory';
      });
    } 
    
    function update_inventory(pt) {
      obj = populate_inventory_item();
      http('put','/api/inventory/'+pt, obj, function(resp) {
        console.log(resp);
        window.location = '/hanley/cmms/view/inventory#'+pt;
        location.reload();
      });
    }     
    
    page('/view/inventory/list', function(html) {
      id('inventory').outerHTML=html;
      id(location.hash.split('#')[1]).scrollIntoView();   
    });
    """
  }
