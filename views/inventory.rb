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

  self << List.new(id: :inventory, header: ["ID", "Location", "Qty", "Cost", "Ext. Cost", "Vendor", "Model", "Description"], columns: [0, 0, 0, 0,1, 1,1,3] ,data: data.map do |pt| 
      [pt["order"], pt["location"], pt["quantity"], pt["price"], pt["price"]*pt["quantity"], pt["manufacturer"], pt["model_no"], pt["description"]]
    end) {
    this=self
    render do |_,r,c|
      id = "inv-header"
      id = data[r]["_id"] if r > 0 && c == 0
      q=4.em
      q=20.px if c==0
      q=2.em if c == 1 or c == 2
      qq=:unset
      qq=:end if c==3 or c==2 or c==4
      h={id: id}

      h= {id: id, onclick: "popup(\"/view/inventory/#{data[r]["order"]}\")"} if r > 0
      h[:class] = 'anchor' if r > 0 && c == 0
      h[:class] = "#{h[:class]} ext-cost".strip if c == 4
      ele(:div, h) {
        if r < 0
          self << e=DataList.new(filter: 'inventory',options:fields[c], value:"", label: _)
          next
        end
   
        _ = "$#{"%.2f" % _}" if c == 3 or c==4
        
        s=span {_}.style! cursor: :pointer,'text-overflow': :ellipsis
        s.style! color: :red if c == 3
        s.style! color: :black if c == 2
      }.style!("min-width": q,"text-align": qq).style! 'font-family': :monospace, cursor: :pointer, 'overflow-x': :hidden
    end
  }
  
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
        price: id('inv-cost').value,
        manufacturer: id('input-inv-vendor').value,
        model_no: id('inv-model').value,
        description: id('inv-description').value
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
        window.location = '/view/inventory';
      });
    } 
    
    function update_inventory(pt) {
      obj = populate_inventory_item();
      http('put','/api/inventory/'+pt, obj, function(resp) {
        console.log(resp);
        window.location = '/view/inventory#'+pt;
        location.reload();
      });
    }     
    
    id(location.hash.split('#')[1]).scrollIntoView();   
    """
  }
