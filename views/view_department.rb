fields = [
  [],
  [],
  [],
  []
]

row() {
  self << List.new(colors: ["gainsboro", "antiquewhite"], header: ["ID", "Location", "Downtime", "Name"], columns: [0, 1, 0,2] ,data: data["equipment"].map do |e| [e["order"], e["location"], e["downtime"], e["name"]] end) {
	this=self
	render do |_,r,c|
	  ele(:div) {
		if r < 0
		  self << (DataList.new(id: "filter#{c+1}",options:fields[c], value:"", label: _) {
			
		  })
		  next
		end
		span(onclick: "window.open(\"/view/equipment/#{data["equipment"][r]["order"]}\", \"equipment\")") {_}
	  }.style!('min-width': c < 1 ? 20.px : 50.px).style! 'font-family': :monospace
	end
  }
}.style! flex:1
