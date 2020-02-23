  // Displays the popup id element, populates it with request 'u'
  function popup(u) {
	id('popup').style.display='none';
    u='/hanley/cmms'+u

    fetch(u)
    .then((response) => {
      return response.text();
    })
    .then((html) => {
      c=id('popup');
      c.innerHTML = html;
    c.style.display='block';
    window.location = "#popup";

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
    window.location = "#page";
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

    
    var workorder_tasks = [];
    
    function populate_workorder() {
		obj = {
			"department": id("input-department").value,
		    "equipment":  parseInt(id("input-equipment").value.split(" ")[0]),
		    "priority":   id("input-priority").value,
		    "type":       id("input-type").value,
		    "description":id("description").value,
		    "tasks":      workorder_tasks
		}
		
		return obj
	}
	
	function create_workorder() {
	  obj = populate_workorder();
	  console.log(obj);	
	  fetch('/hanley/cmms/api/workorders', {
		method: 'post',
		body: JSON.stringify(obj)
	  }).then(function(response) {
		return response.json();
	  }).then(function(data) {
		console.log(data);
		window.location = "/hanley/cmms/view/workorders";		
	  });	  
	}
	
	function update_workorder(o) {
  	  obj = populate_workorder();
	  fetch('/hanley/cmms/api/workorders/'+o, {
		method: 'put',
		body: JSON.stringify(obj)
	  }).then(function(response) {
		return response.json();
	  }).then(function(data) {
		console.log(data);
		window.location = "/hanley/cmms/view/workorders";
	  });
	}
	
	function close_workorder(o) {
  	  if (confirm("Close work order?")) {
	    obj = populate_workorder();
  	    obj.closed = true;
	    fetch('/hanley/cmms/api/workorders/'+o, {
		  method: 'put',
		  body: JSON.stringify(obj)
	    }).then(function(response) {
		  return response.json();
	    }).then(function(data) {
		  console.log(data);
  		  window.location = "/hanley/cmms/view/workorders#"+o;
		  location.reload();
	    });
      }
	}	

	function delete_workorder(o) {
	  if (confirm("Are you sure you wish to delete item?")) {	
	    fetch('/hanley/cmms/api/workorders/'+o, {
		  method: 'delete',
	    }).then(function(response) {
		  return response.json();
	    }).then(function(data) {
		  console.log(data);
		  window.location = "/hanley/cmms/view/workorders";
	    });
	  }
	}	


  function http(method, route, data, after) {
	opts={method: method};
	if (data) {
	  opts = {method: method, body: JSON.stringify(data)};
	} else {
		
	}  
	  
    fetch('/hanley/cmms'+route, opts)
    .then((response) => {
      return response.json();
    })
    .then((json) => {
      console.log(json);
      if (after) {
        after(json);
      }
    });
  }

  function page(route, after) {
    fetch('/hanley/cmms/'+route)
    .then((response) => {
      return response.text();
    })
    .then((json) => {
      console.log(json);
      if (after) {
        after(json);
      }
    });
  }


  var windows={};
  function open_window(name, u) {
	  u = "https://"+location.hostname+":"+location.port+u
	  console.log('open window: '+u);
	  if (windows[name]) {
		windows[name].close();  
	   windows[name] = window.open(u,name);
	   windows[name].focus();
      } else {
	   windows[name] = window.open(u,name);
	  }
	  windows[name].location=u;
	  windows[name].focus();
	  console.log(windows);
  }

  
