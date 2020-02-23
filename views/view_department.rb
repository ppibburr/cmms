fields = [
  [],
  [],
  [find_one(:departments, name: data["department"])["locations"].map do |l| l end.sort],
  [],
  []
]

row() {
  self << List.new(id: 'equipment', colors: ["gainsboro", "antiquewhite"], header: ["ID", "Tasks", "Location", "Downtime", "Name"], columns: [0, 0, 1, 0,2] ,data: data["equipment"].map do |e| [e["order"], e["tasks"].length, "&nbsp;&nbsp;"+e["location"], e["downtime"], e["name"]] end.sort do |a,b| a[-2] <=> b[-2] end) {
	this=self
	render do |_,r,c|
	  q=''
      q = :right if c==1
			
	  ele(:div) {
		if r < 0
		  self << (DataList.new(filter: "equipment",options:fields[c], value:"", label: _) {
			
		  })
		  next
		end

		span(onclick: "open_window(\"equipment\", \"/hanley/cmms/view/equipment/#{data["equipment"][r]["order"]}\")") {_}
	  }.style!('min-width': c < 2 ? 25.px : 50.px).style! 'font-family': :monospace, cursor: :pointer,'text-align-last': q
	end
  }
}.style! flex:1

row() {
  span() {"#{data["equipment"].length} equipment."}.style! flex: 1
  span() {"#{data["equipment"].map do |e| e["tasks"] end.flatten.length} PM Tasks."}.style! flex:1
}.style! flex:0, height: 1.em
