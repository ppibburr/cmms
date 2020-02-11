row() {
  fields = [
	[],
	[],
	[:ASAP,:EMERG,:SCHD],
	[:PM,:REACT,:SAFETY,:PROJ],
	[:ELE,:MECH,:PM,:CTRL,"Replace", "Weld","clean","lubricate","check","adjust","tension", "tighten", "inspect"]
  ]

  self << List.new(id: 'workhistory', colors: ["gainsboro", "antiquewhite"], header: ["ID", "Date", "Priority", "Type", "Description"], columns: [0, 1,0, 0, 2] ,data: []) {
	this=self
	render do |_,r,c|
	  ele(:div) {
		if r < 0
		  self << (DataList.new(filter: "workhistory",options:fields[c], value:"", label: _) {
			
		  })
		  next
		end
		span {_}
	  }.style!('min-width': c < 1 ? 20.px : 50.px).style! 'font-family': :monospace
	end
  }
}.style! flex:1

row() {
  span() {"#{7} tasks"}
}.style! flex: 0, padding:1.em

