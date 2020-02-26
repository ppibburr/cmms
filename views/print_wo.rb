id = data["id"]

o = find_one(:workorders, order: id.to_i)
e = find_one(:equipment, order: o["equip"])
e ||= {
  "name": "null",
  "location": "null"
}
style() {
  """
  .field {
    margin-left:2em;
    margin-right:2em;
  }
  
  .header {
    margin: auto;
    border-style: none !important;
  }

  img {
    border-style: none;
  }
  
  .main {
    min-width:50vw !important;
    /*max-width:50vw;*/
    max-height: unset;
    min-height: 90vh;
    color: black;
    background-color:white !important;
    margin:auto;
    padding:9px;
    box-shadow:none;
    border: solid 1px black;
    border-radius: 2em;
  }
  
  body {
    color: black;
    background-color:white !important;
    margin:0;
    padding:0;
    box-shadow:none;  
  }
  """
}


h2 {"Maintenance Work Order: #{id}"} 

row() {
  span(class: :label) {"Date: "}
  span(class: 'field', id: :wo_date) {u {o["date"]}}
}
row() {
  span(class: :label) {"Deptartment"}
  span(class: :field, id: :wo_dept) {u() {o["dept"]}}
  span(class: :label) {"Location:"} 
  span(class: :field, id: :wo_location) {u() {e["location"]}} 
}.style! padding: '5 0 5 0'

row() {
  span(class: :label) {"Equipment:"}
  span(class: 'field', id: :wo_name) {u() {e["name"]}}
}.style! padding: '5 0 1em 0'

row() {
  span(class: :label) {"Description_"}
}.style! flex:0, 'border-bottom': 'solid 1px black'

row() {
  em() {o["description"]}
}.style! flex: 1

row() {
  span(class: :label) {"Tasks_"}
}.style! flex: 0, 'border-bottom': 'solid 1px black'

self << FlexTable.new() {
  (o["tasks"] || []).each do |t| 
    t=http(:get, :tasks, t) 
    row() {
      code() {span() {t["craft"].ljust(8).gsub(" ", "&nbsp;")}
      span() {t["description"]}
    }}.style!(flex: 0)
  end
}.style!(flex:2)

row() {
 span() {"Completed: "}
 span() {u() {"#{"&nbsp;"*20}"}}
 span() {"&nbsp;&nbsp;&nbsp;Lead: "}
 span() {u() {"#{"&nbsp;"*50}"}} 
}
