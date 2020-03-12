require './store/lib/store'
store = $store = Store.new('hanley-cmms')

File.open('./inv.csv', 'w') do |f|
  f.puts "Location, Sublocation, Vendor, Model, Description, Count, Min, Cost, Ext. Cost,"

  

  a = store.get(:inventory).map do |i|
    if (q=i['location']) =~ /OBS/
      i['location']='Stockroom'
      store.put :inventory, _id: i['_id'], data: i
    end
    
    if (q=i['quantity']) =~ /OBS/
      i['quantity']=0
      i['model_no']=q
      store.put :inventory, _id: i['_id'], data: i
    end    
  
    [i['location'], i['sublocation'], i['manufacturer'].gsub(',',''), i['model_no'].gsub(',',''), i['description'].gsub(',', ''), c=i['quantity'], i['min'], "$#{p=i['price']}", "$" + ("%.2f" % (p.to_f*c.to_f)), nil].join(",")
  end

  f.puts a.join("\n")
end

puts `cat ./inv.csv`
