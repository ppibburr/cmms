var site_root = "/";
 
  // Displays the popup id element, populates it with request 'u'
  function popup(u) {
    u=site_root+u

    fetch(u)
    .then((response) => {
      return response.text();
    })
    .then((html) => {
      c=id('popup');
      c.innerHTML = html;

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
	//id('popup').style.display='none';
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
	  fetch(site_root+'/api/workorders', {
		method: 'post',
		body: JSON.stringify(obj)
	  }).then(function(response) {
		return response.json();
	  }).then(function(data) {
		console.log(data);

		http('post', "/api/push/workorders/"+data["order"]+"/created", function(j) {
		  console.log(j);
	    });	
		window.location = site_root+"/view/workorders";	
	  });	  
	}
	
	function update_workorder(o) {
  	  obj = populate_workorder();
	  fetch(site_root+'/api/workorders/'+o, {
		method: 'put',
		body: JSON.stringify(obj)
	  }).then(function(response) {
		return response.json();
	  }).then(function(data) {
		console.log(data);
		window.location = site_root+"/view/workorders";
	  });
	}
	
	function close_workorder(o) {
  	  if (confirm("Close work order?")) {
	    obj = populate_workorder();
  	    obj.closed = true;
	    fetch(site_root+'/api/workorders/'+o, {
		  method: 'put',
		  body: JSON.stringify(obj)
	    }).then(function(response) {
		  return response.json();
	    }).then(function(data) {
		  console.log(data);
  		  window.location = site_root+"/view/workorders#"+o;
		  location.reload();
	    });
      }
	}	

	function delete_workorder(o) {
	  if (confirm("Are you sure you wish to delete item?")) {	
	    fetch(site_root+'/api/workorders/'+o, {
		  method: 'delete',
	    }).then(function(response) {
		  return response.json();
	    }).then(function(data) {
		  console.log(data);
		  window.location = site_root+"/view/workorders";
	    });
	  }
	}	


  function http(method, route, data, after) {
	opts={method: method};
	if (data) {
	  opts = {method: method, body: JSON.stringify(data)};
	} else {
		
	}  
	  
    fetch(site_root+"/"+route, opts)
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
    fetch(site_root+'/'+route)
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


  var windows={};
  function open_window(name, u) {
	  u = "https://"+location.hostname+":"+location.port+u
	  if (t=id('popup')) {
	    t.style.display = 'none';
      }
      window.location = "#page";
	  window.location = u;
	  return;
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

  
if ('serviceWorker' in navigator) {
  navigator.serviceWorker
    .register('/service-worker.js')
    .then(() => {
      console.log('Service worker registered');
    })
    .catch(err => {
      console.log('Service worker registration failed: ' + err);
    });
}    


const requestNotificationPermission = async () => {
    const permission = await window.Notification.requestPermission();
    // value of permission can be 'granted', 'default', 'denied'
    // granted: user has accepted the request
    // default: user has dismissed the notification permission popup by clicking on x
    // denied: user has denied the request.
    if(permission !== 'granted'){
        throw new Error('Permission not granted for Notification');
    }
}
const main = async () => {
    const permission =  await requestNotificationPermission();
}
main();


