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
    span(class: 'link', onclick: "popup(\"/view/workhistory/#{d["order"]}\")") {"View Work History"}
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

