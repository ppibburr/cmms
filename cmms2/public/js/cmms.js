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
      window.location = '?view='+u+'&title='+title+'#popup';
      id('popup-content').innerHTML = h; 
    });
  }

