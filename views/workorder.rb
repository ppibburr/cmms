require "./build.rb"

def main
  Node.new(:html) {
    self << '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
    style {
      """
      html, body {
        margin: 0;
        padding: 0;
      }
      
      .flex-row {
        display: flex;
        flex-direction: row;
      }
      
      .flex-table {
        display: flex;
        flex-direction: column;
      }    
      """
    }
    

    require "json"
    
    d = JSON.parse(gets)

    fields = [nil,"order","dept","equip", "text"]
    
    d=d.map do |r| 
      ["",r["order"],"ASAP","PM",{
        dept:  "Packaging",
        equip: "Inspection Chains G190",
        desc:  r["text"]
      }]
    end
    
    self << FlexTable.new() {
      div() {
            img(src: "/img/gg-logo.jpg").style! display: :inline
    h3 {"work orders"}.style! display: :inline
    input type: :text, placeholder: "What needs done?"
    hr
      }.style! flex:0
      list(grow_rows: true, columns: [0,0,0,0,1], header: ["", :ID, :Urgency, :Type, :Task], data: d) {
        render do |_, r,c|
          ele(:div) {
            next _ unless r >= 0
            next _ if c < 4
            
            span() {
              _[:dept]
            }
            span() {
              _[:equip]
            }
            div() {
              em() {_[:desc]}
            }
          }.style! "min-width": "#{c < 4 && c > 1 ? 60 : 20}px", "padding-left": "2px", "flex-basis": :auto
        end
      }.style! flex: 1, overflow: "hidden"
      row() {
        "footer"
      }.style! flex:0
    }.style!(flex:1,"min-height": "100vh", "max-height": "100vh")
  }
end

puts main.to_s
