require './build'
require 'json'
require "./tool"
d=JSON.parse(gets)

puts(Node.new(:div) {
  
  self << FlexTable.new() {
    row() {
      img(src: "/img/gg-logo.jpg") {}.style! margin: :auto
    }.style! flex: 0,"background-color": :white
    row() {
      "Equipment ID: #{d["order"].to_s}"
    }.style! flex: 0,"background-color": :darkblue, color: :azure
    row() {
      div() {d["name"]}.style! "text-align": :center
    }.style! "justify-content": "space-around", "background-color": :white, "border-bottom": "solid 1px"
    row() {
      div() {
        div() {
          span() {"Department: "}
          span() {d["department"].to_s}
        }.style! "text-align-last": :justify
        div() {
          span() {"Location: "}
          span() {d["location"].to_s}
        }.style! "text-align-last": :justify
      }.style!(flex: 1, "min-width": "max-content", "font-family": :monospace)
      div() {
        a(href: "") {"View Inventory Items"}
      }.style!(flex:1, "text-align": :center)
    }.style!(flex: 0, display: :flex)
    row() {
      div() {
        div() {
          span() {"Downtime YTD:"}
          span() {
            self << " #{d["downtime"]}hrs"
            button() {"Edit"}
          }
        }.style! "text-align-last": :justify
        div() {
          span() {"Prev. Yr: "}
          span() {"#{d["prev_downtime"]}hrs"}
        }.style! "text-align-last": :justify
      }.style! flex: 1, "min-width": "max-content", "font-family": :monospace
      div() {
        a(href:"#", onclick:"view_work_history(#{d["order"]})") {"View Work History"}
      }.style!(flex:1, "text-align": :center)
    }.style! flex: 0,display: :flex
    
    row() {
      span() {
        "Preventative Maintenance Tasks"
      }
    }.style! flex:0, "justify-content": "space-evenly", "background-color": "teal"
    
    row() {
      fields = [
        [],
        [:ELE, :MECH, :PM, :CTRL, :CONTRACT],
        [1,7,14,30, 40, 60, 70,140,280,365],
        ["clean","lubricate","check","adjust","tension", "tighten", "inspect"]
      ]
      self << List.new(id: :tasks, colors: ["gainsboro", "antiquewhite"], header: ["ID", "Craft", "Interval", "Description"], columns: [0, 0, 0, 1] ,data: (d["tasks"].map do |t|
        t = http(:get, :tasks, t["_id"])
        [t["order"], t["craft"], t["interval"], t["description"]] 
      end)) {
        this=self
        render do |_,r,c|
          ele(:div) {
            if r < 0
              self << DataList.new(id: "filter#{c+1}",options:fields[c], value:"", label: _)
              next
            end
            span {_}
          }.style!("min-width": 60.px).style! 'font-family': :monospace
        end
      }
    }.style! flex:1
    
    row() {
      span() {"#{d["tasks"].length} tasks"}
    }.style! flex: 0, padding:1.em
    
    head() { 
      title {"Hanley CMMS"}
      self << '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
      default_style 
      default_script() 
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
		
		function close_work_history() {
		  id('popup').style.display='none';
		}
		
	    filters=['filter1','filter2','filter3','filter4'];
        setup_filters(filters, 'tasks');
        """
      }
    }

  }.style!(flex:0, "background-color": "azure", color: "darkblue","min-height": "100vh", "max-height": "100vh", width: "55vw", "min-width": "358px",margin: :auto, border: "solid 1px")

  div(id: "popup") {
  
  }
}.to_s)
