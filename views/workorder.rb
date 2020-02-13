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
    
      input(id: :new, type: :text, placeholder: "What needs done?").style! display: :block, "font-size": "x-large", "margin-top": 0.2.em    
      
      list(id: 'workorders', grow_rows: true, columns: [0,0,0,0,1], header: ["", :ID, :Urgency, :Type, :Task], data: d) {
        render do |_, r,c|
          ele(:div) {
            if r < 0
              self << DataList.new(filter: 'workorders',options:fields[c], value:"", label: _)
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
                 
                  t=[t["craft"],t["description"]]
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
      
	  script() {
		  """
		id('new').addEventListener('keydown', function(event) {
			if (event.key === 'Enter') {
				event.preventDefault();
				id('new').blur();
				popup('/create/workorder?description='+encodeURI(id('new').value));
				id('new').value = '';

				
				// Do more work
			}
		});
		  """
		}      
    end.style! flex:1 
  end
end


d=data.map do |r| 
  ["",r["order"],r["priority"], r["type"], r]
end

self << WorkOrders.new(d,id: 'workorders')
