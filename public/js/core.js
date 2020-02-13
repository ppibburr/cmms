  // Displays the popup id element, populates it with request 'u'
  function popup(u) {
    id('popup').style.display='block';
    
    fetch(u)
    .then((response) => {
      return response.text();
    })
    .then((html) => {
      c=id('popup');
      c.innerHTML = html;
    });
  }    
    
  // returns an element with the id 'id'  
  function id(i) {
    return document.getElementById(i);
  }

  // list of elements matching selector 's'
  function select(s) {
    return document.querySelectorAll(s);
  }    
  
  function do_close() {
    id('popup').style.display='none';
  }
    
     // filter list of id 'id' against contents of e
     function filter(e,_id) {
      //e.blur();
      list = select('#'+_id+' .row');  
      for(i=0;i<list.length;i++){
        console.log([e.id,_id, list]);
        if (!list[i].innerText.includes(e.value)) {
          list[i].style.display = 'none';
          
        } else {
          list[i].style.display ='';
        }
      }
    }

    // conenct the enter key to input datalists used as a column header
    function handle_filter(list) {
		  console.log('filter: '+list);
          if (event.key === 'Enter') {
			  event.preventDefault();
			  filter(event.target, list);
		  }        
    } 
