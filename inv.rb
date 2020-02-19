raw = open("out.txt").read
.gsub(/.*\.rpt*\n/,'').gsub(/[0-9]+\/[0-9]+\/[0-9]+.*\n/,'').gsub(/Price Lis.*\n/,'')
File.open("out.txt","w") do |f| f.puts raw end
pa = []
i = 0; 
a=[]

raw.split("\n").each do |l|
  a = [] if i == 0
  if i <= 8
    a << l
  end
  if i == 8
    i=0
    pa << a
    next
  end
  i+=1
end

puts pa[1]
$pa=pa
pta = []

pa.each do |pt|
  pta << {
    part_no: pt[0],
    description: pt[1],
    location: pt[2],
    manufacturer: pt[6],
    model_no:     pt[7],
    price:        pt[8]
  }
end

pta.each do |pt|
  http :post, "inventory", data: pt
end
