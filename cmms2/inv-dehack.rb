require './store/lib/store'

store = $store = Store.new('hanley-cmms')
$store.delete :inventory
buff=open('./inv.csv').read.encode('UTF-8', :invalid => :replace).gsub("\r",'').split("\n")
pa=buff.map do |l|
  a = l.split(",")
  o={
    location: a[0],
    sublocation: a[1],
    manufacturer: a[2],
    model_no: a[3],    
    description: a[4].gsub('"',''),
    quantity: a[5].to_i,
    min: a[6].to_i,
    price: a[7].to_f,
  }
end
store.post :inventory, pa
