         1

$root.head() {
  title {
    "CMMS | Work Orders"
  }
}

div() {
  h2() {"Inventory"}
}.style! 'align-self': :center   
   
v=view("inventory")[-1]

span() {"There are: #{v.data.length} inventory items"}.style! flex:0
