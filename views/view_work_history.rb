require './build'
require 'json'
require "./tool"
d=JSON.parse(gets)

puts(Node.new(:div,id:"popup") {
  
  self << FlexTable.new() {
    row() {
      "Equipment ID: #{d["order"].to_s} Work History"
    }.style! flex: 0,"background-color": :darkblue, color: :azure

    row() {
      fields = [
        [],
        [],
        [:ASAP,:EMERG,:SCHD],
        [:PM,:REACT,:SAFETY,:PROJ],
        [:ELE,:MECH,:PM,:CTRL,"Replace", "Weld","clean","lubricate","check","adjust","tension", "tighten", "inspect"]
      ]
      self << List.new(colors: ["gainsboro", "antiquewhite"], header: ["ID", "Date", "Priority", "Type", "Description"], columns: [0, 1,0, 0, 2] ,data: []) {
        this=self
        render do |_,r,c|
          ele(:div) {
            if r < 0
              self << (DataList.new(id: "filter#{c+1}",options:fields[c], value:"", label: _) {
                
              })
              next
            end
            span {_}
          }.style!('min-width': c < 1 ? 20.px : 50.px).style! 'font-family': :monospace
        end
      }
    }.style! flex:1
    
    row() {
      span() {"#{d["tasks"].length} tasks"}
    }.style! flex: 0, padding:1.em
    
    head() { 
      title {"Hanley CMMS | Work History"}
      self << '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
      default_style  
      script() {
        """
	    function view_work_history(id) {
			fetch('/view/workhistory/'+id)
			.then((response) => {
			  return response.text();
			})
			.then((html) => {
			  c=document.getElementById('popup');
			  c.outerHTML = html;
			});
		}
		
        """
      }
    }
    button(onclick: "do_close()") {"Close"}  
  }.add_class("popup")
}.style!(display: 'unset').to_s)
