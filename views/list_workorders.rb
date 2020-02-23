d=data.map do |r| 
  ["",r["order"],r["priority"], r["type"], r]
end


      fields = [
        [],
        [],
        [:ASAP,:EMERG,:SCHD],
        [:REACT,:PM,:SAFETY, :PROJ],
        [:ELE,:PM,:MECH,:CONTRACT,:CTRL,:Packaging, :Manufacturing, :Thinbrick, :Warehouse, :Magroom, :Grinding, :Crushing, :Scrubber, :Kiln, :Haulage]
      ]

      List.new(id: 'orders', grow_rows: true, columns: [0,0,0,0,1], header: ["", :ID, :Urgency, :Type, :Task], data: d.reverse) {
        render do |_, r,c|
          ele(:div) {
            if r < 0
              self << DataList.new(filter: 'workorders',options:fields[c], value:"", label: _)
              next
            end
            
            next _ if c < 4
            div() {
            span() {
              _["dept"]
            }.style! color: :"#181872"
            
            span() {
              ((find(:equipment,order: _["equipment"]) || [])[0] || {"name": ""})["name"]
            }.style! color: :"#009688"
            }.style! margin: :auto, display: :flex, 'min-width': 'calc(100%)','justify-content': :center
            div(onclick: "popup(\"/view/workorder/#{_["order"]}\")") {
              em() {
                (!_["tasks"].empty? ? _["tasks"] : [{"craft"=> "?", "description"=> _["description"]}]).map do |t|
                 
                  t=[t["craft"],t["description"]]
                  div() {
                    span() {t[0]+": "}.style! flex: 1
                    span() {t[1]}.style! flex: 3
                  }.style! display: :flex, 'flex-direction': :row, margin: :auto
                end
              }
            }.style! overflow: :auto, position: :relative, margin: "0 2px" , height: 2.8.em,'background-color': '', border: '', 'border-radius': 0.3.em
          }.style! "min-width": "#{c < 4 && c > 1 ? 60 : 20}px", "padding-left": "2px", "flex-basis": :auto
        end
      }.style! flex: 1, overflow: "hidden","background-color": "aliceblue"

