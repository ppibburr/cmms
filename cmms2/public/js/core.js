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

navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {
  serviceWorkerRegistration.pushManager
  .subscribe({
    userVisibleOnly: true,
    applicationServerKey: window.vapidPublicKey
  });
});


  
  function http(method, route, data, after) {
	opts={method: method};
	if (data) {
	  opts = {method: method, body: JSON.stringify(data)};
	} else {
		
	}  
	  
    fetch(route, opts)
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
  
  function open_window(a,b) {
    window.location = b;
  }   
