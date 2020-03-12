require './store/lib/store'

store = $store = Store.new('hanley-cmms')

buff=open('./inv-mfg.csv').read.gsub("\r",'').split("\n")
pa=buff.map do |l|
  a = l.split(",")
  q = a[0].gsub('"','')
  s=""; d=""
  ["additive ", "robot heads ", "crushing/grinding ", "cutter ", "extruder "].each do |t|
    if q =~ /#{t}/
      s = t
      q=q.gsub(s,'').strip
      d=q
      break
    end
  end

  o={
    location: :manufacturing,
    description: d,
    sublocation: s,
    quantity: a[1].to_i,
    min: a[2].to_i,
    price: a[3].to_f,
    manufacturer: a[5],
    model_no: a[6]
  }
end
store.post :inventory, pa
