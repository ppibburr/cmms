require './store/lib/store'
$store ||= Store.new('hanley-cmms')
Mongo::Logger.logger.level = Logger::FATAL

rule '.tag',
  border_radius: 0.2.em,
  background_color: 0xe0d9e0.hex,
  display: 'inline-block',
  padding: 2.px,
  margin: 2.px,
  min_width: 5.em,
  max_height: 1.5.em
  
rule '.priority-asap',
  background_color: 'red'


self << List2.new(columns: [1,4], headers: ["",""], data: $store.get(:workorders,closed: nil)) {}.header {|l,h| 
  l.headers
}.item {|l,o|
  [ 
  div() {
    div {
      b{o["time"].strftime("%m - %d - %Y")}
      div { span(class: "tag wo-priority priority-#{o['priority']}") {o["priority"]}}
      
      div { span(class: 'tag wo-type')  {o["type"]}}
    }.style! "text-align": :center
  }, div(id: o["_id"], onclick: "popup(\"/workorders/#{o['_id']}\",\"WorkOrder: #{o["order"]}\")") {
    div {
      (t=$store.get(:tasks,  _id: o["tasks"][0]))
      $store.get(:equipment, _id: t["equipment"])["department"].capitalize
    }.style! color: :darkblue
    span{o["description"]}
  }.style!("text-align": :center)]
}.style!(flex: 1,"background-color": "aliceblue")
