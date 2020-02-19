  fields = [
    [],
    data.map do |e| e["location"] end.uniq,
    [],
    data.map do |e| e["manufacturer"] end.uniq,
    data.map do |e| e["model"] end.uniq,
    []
  ]
  
  tc=0.0
  data.map do |e| 
    tc+= (e["price"] = e["price"].to_s.gsub("$",'').to_f) 
  end
  
  row() {
    div() {
      span(class: :total_cost) {"Total Inventory Cost: "}
      b() {
        em() {
          span() {"$%.2f" % tc}.style! color: :black
        }
      }
    }.style! flex: 1
    
    button(onclick: "popup(\"/view/additem\")") {"Add Item"}.style! flex: 0,"min-width": "fit-content"
    hr()
  }.style! "background-color": "#00ced1"
  self << List.new(id: :inventory, colors: ["gainsboro", "antiquewhite"], header: ["ID", "Location", "Cost", "Vendor", "Model", "Description"], columns: [0, 0, 0, 1,1,3] ,data: data.map do |pt| 
      [pt["order"], pt["location"], pt["price"], pt["manufacturer"], pt["model_no"], pt["description"]]
    end) {
    this=self
    render do |_,r,c|
      id = "inv-header"
      id = data[r]["_id"] if r > 0 && c == 0
      q=60
      q=20 if c==0
      qq=:unset
      qq=:end if c==2
      h={id: id}

      h= {id: id, onclick: "popup(\"/view/inventory/#{data[r]["order"]}\")"} if r > 0
      h[:class] = 'anchor' if r > 0 && c == 0
      ele(:div, h) {
        if r < 0
          self << e=DataList.new(filter: 'inventory',options:fields[c], value:"", label: _)
          
          next
        end
        
   
        _ = "$#{"%.2f" % _}" if c == 2
        
        s=span {_}.style! cursor: :pointer,'text-overflow': :ellipsis
        s.style! color: :red if c == 2
      }.style!("min-width": q.px,"text-align": qq).style! 'font-family': :monospace
    end
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
      http('delete','/api/inventory/'+pt, {}, function(resp) {
        console.log(resp);
        id(pt).outerHTML = '';
        window.location = '#page';
      });
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
