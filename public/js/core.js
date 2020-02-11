  function popup(u) {
    fetch(u)
    .then((response) => {
      return response.text();
    })
    .then((html) => {
      c=id('popup');
      c.outerHTML = html;
    });
  }    
    
  function id(i) {
    return document.getElementById(i);
  }

  function select(s) {
    return document.querySelectorAll(s);
  }    
  
  function do_close() {
    id('popup').style.display='none';
  }
  
     function filter(e,_id) {
      e.blur();
      list = select('#'+_id+' .row');  
      for(i=0;i<list.length;i++){
        var f;
        console.log(document.querySelector(f='#'+e.id+' input').value);
        console.log([f,_id]);
        if (!list[i].innerText.includes(document.querySelector(f).value)) {
          list[i].style.display = 'none';
          
        } else {
          list[i].style.display ='';
        }
      }
    }


    
    function setup_filters(filters, _id) {
		filters.forEach(function(i) {
		  e=id(i);
		  e.addEventListener('keydown', function(event) {
			if (event.key === 'Enter') {
			  //event.preventDefault();
			  filter(this, _id);
			}    
			// Do more work
		  });
		});    
    } 
