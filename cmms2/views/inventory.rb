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


self << List2.new(columns: [1,4], headers: ["",""], data: $store.get(:inventory)) {}.header {|l,h| 
  l.headers
}.item {|l,o|
  [ 
  div() {
    div {
      b{o["location"]}
      div { span(class: "tag wo-priority priority-#{o['priority']}") {o["quantity"]}}
      
      div { span(class: 'tag wo-type')  {o["price"]}}
    }.style! "text-align": :center
  }, div(id: o["_id"], onclick: "popup(\"/inventory/#{o['_id']}\",\"Iventory Item: #{o["order"]}\")") {
    div {
      span() {o['manufacturer']}
      span() {o['model_no']}
    }.style! color: :darkblue
    div {
      span {o['description']}
    }
  }.style!("text-align": :center)]
}.style!(flex: 1,"background-color": "aliceblue")
