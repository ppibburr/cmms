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
    
      input(id: :new, type: :text, placeholder: "What needs done?").style! 'border-color': 'lightblue', display: :block, "font-size": "x-large", margin: :auto, "margin-top": 0.6.em, "min-width": 80.vw   , 'margin-bottom': 0.6.em 
      
      div(id: :orders) {div(class: 'loader')}.style! flex:1
      
      row() {
        "There are: #{d.length} open orders."
      }.style! flex:0, margin: 5.px
      
	  script() {
		  """
		  page('/view/workorders/list', function(html) {
		    id('orders').outerHTML=html;
		  });
		  
		id('new').addEventListener('keydown', function(event) {
			if (event.key === 'Enter') {
				event.preventDefault();
				id('new').blur();
				popup('/create/workorder?description='+encodeURI(id('new').value)+'&department=Manufacturing');
				id('new').value = '';

				
				// Do more work
			}
		});
		  """
		}      
    end.style! flex:1 
  end
end

self << WorkOrders.new(find(:workorders, closed: nil),id: 'workorders')
