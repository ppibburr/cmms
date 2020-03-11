require './store/lib/store'

store = $store = Store.new('hanley-cmms')

buff=open('./dehack-inv.csv').read.gsub("\r",'').split("\n")
pa=buff.map do |l|
  a = l.split(",")
  o={
    location: :packaging,
    description: a[0].gsub('"',''),
    quantity: a[1].to_i,
    min: a[2].to_i,
    price: a[3].to_f,
    manufacturer: a[5],
    model_no: a[6]
  }
end
store.post :inventory, pa
