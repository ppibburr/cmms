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
      q=60
      q=20 if c==0
      qq=:unset
      qq=:end if c==2
      h={}
      h = {onclick: "update_cost(\"#{(pt=data[r])["_id"]}\", #{pt["price"]})"} if c==2
              
      ele(:div, h) {
        if r < 0
          self << e=DataList.new(filter: 'inventory',options:fields[c], value:"", label: _)
          
          next
        end
        
   
        _ = "$#{"%.2f" % _}" if c == 2
        
        span {_}.style! cursor: :pointer,'text-overflow': :ellipsis
      }.style!("min-width": q.px,"text-align": qq).style! 'font-family': :monospace
    end
  }


  script() {
    """
    function update_cost(pt, o) {
      val = prompt('Enter new cost', ''+o);
      event.target.innerText = \"$\"+val;
      http('put','/api/inventory/'+pt, {price: parseInt(val)}, function(j) {
        alert(j);
      });
    }
    """
  }
