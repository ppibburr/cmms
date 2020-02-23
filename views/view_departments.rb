self << (FlexTable.new() {
http(:get, :departments).sort do |a,b| a["name"]<=>b["name"] end.each do |d|
  row() {
	span(id: d["name"], onclick: "popup(\"/view/department/#{d["name"]}\")") {
	  d["name"].upcase
	}.style! margin: :auto, 'min-height': 2.em, 'padding-top': 1.em
  }.style! flex: 0, cursor: :pointer
end
}.style!(height:100.px,flex:1, overflow: :auto, position: :relative))
