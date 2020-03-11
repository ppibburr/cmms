$root.head() {
  title {
    "CMMS | Work Orders"
  }
  style {
"""

@media only screen and (max-width: 450px) {
  .invadd {
    min-width: 80vw;
    max-width: 80vw;
    min-height: 80vh;
    max-height: 80vh;        
    margin: auto;
  }
  
  .ext-cost {
    display: none;
  }
  
  .main {
    min-width: 100vw;
    box-shadow: unset;
    min-height: 100vh !important;
    max-height: 100vh;
    margin: unset;
    border: unset;
  }

#popup {      
  height: 100vh;
  width: 100vw;
  position: fixed;
  top: 0; /*left: 0;*/
  background-color: rgba(39, 55, 77, 0.59);
  display: none ;
  z-index: 100;            
}
.popup {
  flex:0;
  min-height: 100vh;
  max-height: 100vh;
  margin: unset;
  border: unset;
  border-radius: 0.1em;
  background-color: aliceblue;
  box-shadow: unset;
  width:100vw;
}
}

#popup-title {
min-width: 12vw;
    background-color: #0a2a46;
    display: inline-block;
    color: azure;
   
   }
"""  
  }
}

input(id: :new, type: :text, placeholder: "What needs done?").style! 'border-color': 'lightblue', display: :block, "font-size": "x-large", margin: :auto, "margin-top": 0.6.em, "min-width": 'calc(80%)'   , 'margin-bottom': 0.6.em 
      
v=view("workorders")[-1]

span() {"There are: #{v.data.length} open orders, #{v.data.map do |o| o['tasks'] end.flatten.length} tasks"}.style! flex:0

