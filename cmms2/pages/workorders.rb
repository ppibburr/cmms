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

.popup {
  flex:0;
  min-height: 78vh;
  max-height: 78vh;
  margin: 12vh 11vw;
  width: 78vw;
  border: ridge;
  border-radius: 0.1em;
  background-color: aliceblue;
  box-shadow: 10px 10px 8px #282020;
}

#popup {      
    display: none;
    position: relative;
    left: -600px;
    background: blue;
    -webkit-animation: slide 0.2s forwards;
    -webkit-animation-delay: 1s;
    animation: slide 0.2s forwards;
    animation-delay: 0s;

  height: 100vh;
  width: 100vw;
  position: fixed;
  top: 0; /*left: 0;*/
  background-color: rgba(39, 55, 77, 0.59);
  z-index: 100;            
}
@-webkit-keyframes slide {
    100% { left: 0; }
}

@keyframes slide {
    100% { left: 0; }
}

#popup:target {
  display:block;
}

@keyframes fadein {
    from { opacity: 0; }
    to   { opacity: 1; }
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

span() {"There are: #{v.data.length} open orders"}.style! flex:0

script {
  """
  function view(u,after) {
    fetch(u)
    .then((response) => {
      return response.text();
    })
    .then((json) => {
      //console.log(json);
      if (after) {
        after(json);
      }
    });
  }
  
  function id(i) {
    return document.getElementById(i);
  } 
  
  function popup(u,title) {
    view(u, function(h) {
      id('popup-title').innerText=title;
      window.location = '#popup';
      id('popup-content').innerHTML = h; 
    });
  }
  """
}
