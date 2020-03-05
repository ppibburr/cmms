         1

$root.head() {
  title {
    "CMMS | Work Orders"
  }
  style {
"""
      body {
        /*text-align: -webkit-center;*/
        background-color: #b7b7b7;
      }
      
body {
   color: #2d3033;
   font-weight: 500;
    line-height: 1.6;
    font-size: 0.7125rem;
    max-width: 100%;
    text-rendering: optimizeLegibility;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    color: var(--color-charcoal);
    font-family: \"Montserrat\", Helvetica, sans-serif; 
    display: flex;
}

   .main {
   background-color: #fafbfc; 
   box-shadow: 10px 10px 8px #282020;
   border-top: solid 1px #cecece;
   border-left: solid 1px #cecece;
   }
   
#new {
    margin-left: auto;
    margin-right: auto;
    margin-top: 6px;
    margin-bottom: 6px;
    border-radius: 0.3em;
}

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

.popup {
  flex:0;
  min-height: 100vh;
  max-height: 100vh;
  margin: unset;
  border: unset;
  border-radius: 0.1em;
  background-color: aliceblue;
  box-shadow: unset;
}
}

   
"""  
  }
}

div id: :wo
input(id: :new, type: :text, placeholder: "What needs done?").style! 'border-color': 'lightblue', display: :block, "font-size": "x-large", margin: :auto, "margin-top": 0.6.em, "min-width": 'calc(80%)'   , 'margin-bottom': 0.6.em 
      
v=view("workorders")[-1]

span() {"There are: #{v.data.length} open orders"}.style! flex:0
end

script {
  """
  function view(u) {
    http(u, function(h) {
      e = id('popup');
      e.innerHTML = h;
    }); 
  }
  """
}
