  d=data=get :inventory

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

  List.new(id: :inventory, header: ["ID", "Location", "Qty", "Cost", "Ext. Cost", "Vendor", "Model", "Description"], columns: [0, 0, 0, 0,1, 1,1,3] ,data: data.map do |pt| 
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
   
        _ = "$#{"%.2f" % _}" rescue _ if c == 3 or c==4
        
        s=span {_}.style! cursor: :pointer,'text-overflow': :ellipsis
        s.style! color: :red if c == 3
        s.style! color: :black if c == 2
      }.style!("min-width": q,"text-align": qq).style! cursor: :pointer, 'overflow-x': :hidden
    end
  }
