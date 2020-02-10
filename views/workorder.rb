require "./build.rb"

class WorkOrders < FlexTable
  def initialize d,*o,&b
    super *o do
      fields = [
        [],
        [],
        [:ASAP,:EMERG,:SCHD],
        [:REACT,:PM,:SAFETY, :PROJ],
        [:ELE,:PM,:MECH,:CONTRACT,:CTRL,:Packaging, :Manufacturing, :Thinbrick, :Warehouse, :Magroom, :Grinding, :Crushing, :Scrubber, :Kiln, :Haulage]
      ]
    
      div() {
        img(src: "/img/gg-logo.jpg").style! display: :"inline-block"
        span(onclick: "window.close()") {"X"}.add_class("close-button")
        input(id: :new, type: :text, placeholder: "What needs done?").style! display: :block, "font-size": "x-large", "margin-top": 0.2.em 
        hr
      }.style! flex:0, "background-color": :white
      
      list(grow_rows: true, columns: [0,0,0,0,1], header: ["", :ID, :Urgency, :Type, :Task], data: d) {
        render do |_, r,c|
          ele(:div) {
            if r < 0
              self << DataList.new(id: "filter#{c+1}",options:fields[c], value:"", label: _)
              next
            end
            next _ if c < 4
            
            span() {
              _["dept"]
            }.style! color: :"#009688"
            span() {
              _["equip"]
            }.style! color: :"#009688"
            div(onclick: "popup(\"/view/workorder/#{_["order"]}\")") {
              em() {
                _["tasks"].map do |t| 
                  div() {
                    span() {t[0]+": "}.style! flex: 0
                    span() {t[1]}.style! flex: 1
                  }.style! display: :flex, 'flex-direction': :row
                end
              }
            }.style! overflow: :auto, position: :relative, height: 2.8.em,'background-color': 'floralwhite', border: 'dashed 1px', 'border-radius': 0.3.em
          }.style! "min-width": "#{c < 4 && c > 1 ? 60 : 20}px", "padding-left": "2px", "flex-basis": :auto
        end
      }.style! flex: 1, overflow: "hidden","background-color": "aliceblue" 
      row() {
        "footer"
      }.style! flex:0
    end 
    
    self.style!(flex:1, color: "darkblue","min-height": "100vh", "max-height": "100vh", width: "55vw", "text-align": "-webkit-center", "min-width": "358px", margin: :auto)
  end
end

def main
  Node.new(:html) {
    self << '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
    default_style
    
    head() { title {"Hanley CMMS | Work Orders"}}

    require "json"
    
    d = JSON.parse(gets).reverse

    fields = [nil,"order","dept","equip", "text"]
    
    d=d.map do |r| 
      ["",r["order"],r["priority"], r["type"], r]
    end
    
    self << WorkOrders.new(d,id: 'workorders')
    
    div(id: :popup).style! "z-index": 100

    default_script()
    
    script() {
      """
  function submit_workorder() {
    id('popup').style.display='none';
  }
  
  function cancel_create_workorder() {
    id('popup').style.display='none';
  }
    
  function delete_workorder() {
    id('popup').style.display='none';
  }
    
  function close_workorder() {
    id('popup').style.display='none';
  }
    
  function update_workorder() {
    id('popup').style.display='none';
    window.location='/';
  }      

  id('new').addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
        event.preventDefault();
        id('new').blur();
        popup('/create/workorder?description='+encodeURI(id('new').value));
        id('new').value = '';

        
        // Do more work
    }
  });
        
  filters=['filter2','filter3','filter4','filter5'];
  setup_filters(filters, 'workorders');
      """
    }
  }
end

puts main.to_s
