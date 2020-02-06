require "./build.rb"

class WorkOrders < FlexTable
  def initialize d,*o,&b
    super *o do
      div() {
        img(src: "/img/gg-logo.jpg").style! display: :"inline-block"
        h3 {"work orders"}.style! display: :"inline-block"
        input(id: :new, type: :text, placeholder: "What needs done?").style! display: :block, "font-size": "x-large"
        hr
      }.style! flex:0
      
      list(grow_rows: true, columns: [0,0,0,0,1], header: ["", :ID, :Urgency, :Type, :Task], data: d) {
        render do |_, r,c|
          ele(:div) {
            next _ unless r >= 0
            next _ if c < 4
            
            span() {
              _["dept"]
            }.style! color: :"#009688"
            span() {
              _["equip"]
            }.style! color: :"#009688"
            div(onclick: "view(#{_["order"]})") {
              em() {_["tasks"].join("<br>")}
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
    default_style
    
    head() { title {"Hanley CMMS"}}

    require "json"
    
    d = JSON.parse(gets).reverse

    fields = [nil,"order","dept","equip", "text"]
    
    d=d.map do |r| 
      ["",r["order"],"ASAP","PM",r]
    end
    
    self << WorkOrders.new(d)
    
    div(id: :popup).style! "z-index": 100
    
    script() {
      """
  function id(i) {
    return document.getElementById(i);
  }
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
  }      

  
  function popup() {
    fetch('/create/workorder?description='+encodeURI(id('new').value))
    .then((response) => {
      return response.text();
    })
    .then((html) => {
      c=document.getElementById('popup');
      c.outerHTML = html;
    });
  }

  id('new').addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
        event.preventDefault();
        id('new').blur();
        popup();
        id('new').value = '';

        
        // Do more work
    }
  });
 
    function view(id) {
		fetch('/view/workorder/'+id)
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
end

puts main.to_s
