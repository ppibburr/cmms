require './build'
require 'json'
require "./tool"
o=JSON.parse(gets)

d=o["equipment"].map do |e|
  [e["order"], e["location"], e["downtime"], e["name"]]
end

puts(Node.new(:div,id:"popup") {
  
  self << FlexTable.new() {
    row() {
      "#{o["department"].to_s} Equipment List"
    }.style! flex: 0,"background-color": :darkblue, color: :azure

    fields = [
      [],
      [],
      [],
      []
    ]

    row() {
      self << List.new(colors: ["gainsboro", "antiquewhite"], header: ["ID", "Location", "Downtime", "Name"], columns: [0, 1, 0,2] ,data: d) {
        this=self
        render do |_,r,c|
          ele(:div) {
            if r < 0
              self << (DataList.new(id: "filter#{c+1}",options:fields[c], value:"", label: _) {
                
              })
              next
            end
            span(onclick: "window.open(\"/view/equipment/#{d[r][0]}\", \"equipment\")") {_}
          }.style!('min-width': c < 1 ? 20.px : 50.px).style! 'font-family': :monospace
        end
      }
    }.style! flex:1
    
    row() {
      span() {""}
    }.style! flex: 0, padding:1.em
    
    head() { 
      default_style 
      default_script 
      script() {
        """		

        """
      }
    }
    button(onclick: "do_close()") {"Close"}  
  }.add_class("popup")
}.style!(display: 'unset').to_s)
