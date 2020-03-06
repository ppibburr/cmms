require './store/lib/store'
$store = Store.new('hanley-cmms')
$store.clear :departments

a = [
 {
   name:      "packaging",
   locations: [
     "dehacker",
     "monorail"
   ]
 },
 
 {
   name:      "manufacturing",
   locations: [
     "platform",
     "mfg",
   ]
 }, 
 
  {
   name:      "crushing",
   locations: [
     "crusher",
     "hill"
   ]
 },
 
  {
   name:      "grinding",
   locations: [
     "floor",
     "top",
     "middle"
   ]
 },
 
 {
   name:      "office",
   locations: [
     "front",
     "upstairs"
   ]
 }, 
 
 {
   name:      "warehouse",
   locations: [
     "main",
     "ace"
   ]
 }, 
 
 {
   name:      "parkinglot",
   locations: [
     "main",
     "upper"
   ]
 }, 
 
 {
   name:      "magroom",
   locations: [
     "main",
     "floor",
     "top"
   ]
 }, 
 
 {
   name:      "maintenance",
   locations: [
     "office",
     "shop",
     "stockroom"
   ]
 }, 
 
 {
   name:      "kiln",
   locations: [
     "dryer",
     "kiln",
     "scrubber"
   ]
 }, 
 
 {
   name:      "haulage",
   locations: [
     "main",
   ]
 }, 
]

$store.post :departments, a
