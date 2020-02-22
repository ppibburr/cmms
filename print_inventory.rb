require 'json'
require "./tool.rb"

space = [
  5,
  10,
  4,
  8,
  8,
  22,
  22,
  25
]

i=-1
puts("Hanley Inventory List\n"+[
  "ID",
  "Location",
  "Qty",
  "Cost",
  "Ext. Cost",
  "Vendor",
  "Model",
  "Description"
].map do |f|
  i+=1
  f.ljust(space[i])
end.join(" ")+"\n"+
get(:inventory).map do |i|
  a = []
  ["order","location","quantity","price","ext","manufacturer","model_no", "description"].each_with_index do |k,ii|
    if k != "ext"
      a << i[k].to_s[0..space[ii]].ljust(space[ii])
    else
      a << (i["price"]*i["quantity"]).to_s[0..space[ii]].ljust(space[ii])
    end
  end
  a.join(" ")
end.join("\n"))
