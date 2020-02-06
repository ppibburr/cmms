require "./build.rb"

class WorkOrders < FlexTable
  def initialize d,*o,&b
    super *o do
      div() {
        img(src: "/img/gg-logo.jpg").style! display: :"inline-block"
        h3 {"work orders"}.style! display: :"inline-block"
        input(type: :text, placeholder: "What needs done?").style! display: :block, "font-size": "x-large"
        hr
      }.style! flex:0
      
      list(grow_rows: true, columns: [0,0,0,0,1], header: ["", :ID, :Urgency, :Type, :Task], data: d) {
        render do |_, r,c|
          ele(:div) {
            next _ unless r >= 0
            next _ if c < 4
            
            span() {
              _["department"]
            }.style! color: :"#009688"
            span() {
              _["equipment"]
            }.style! color: :"#009688"
            div() {
              em() {_["task"]}
            }
          }.style! "min-width": "#{c < 4 && c > 1 ? 60 : 20}px", "padding-left": "2px", "flex-basis": :auto
        end
      }.style! flex: 1, overflow: "hidden","background-color": "aliceblue" 
      row() {
        "footer"
      }.style! flex:0
    end 
    
    self.style!(flex:1, color: "darkblue","min-height": "100vh", "max-height": "100vh", width: "55vw", "text-align": "-webkit-center", "min-width": "358px")
  end
end

def main
  Node.new(:html) {
    self << '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
    style {
      """
      html, body {
        margin: 0;
        padding: 0;
      }
      
      body {
        text-align: -webkit-center;
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
    
    head() { title {"Hanley CMMS"}}

    require "json"
    
    d = JSON.parse(gets).reverse

    fields = [nil,"order","dept","equip", "text"]
    
    d=d.map do |r| 
      ["",r["order"],"ASAP","PM",r]
    end
    
    self << WorkOrders.new(d)
  }
end

puts main.to_s
