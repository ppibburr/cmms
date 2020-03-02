Html.new() {
  head() {
    meta() {
      meta name:"viewport", content:"width=device-width, initial-scale=1.0"
      meta name:"mobile-web-app-capable", content:"yes"
      link rel:"manifest", href:"/manifest.json"
    }
    
    script() {
"""
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


window.vapidPublicKey = new Uint8Array(#{ Base64.urlsafe_decode64(PUSH['public_key']).bytes });

navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {
  serviceWorkerRegistration.pushManager
  .subscribe({
    userVisibleOnly: true,
    applicationServerKey: window.vapidPublicKey
  });
});

window.site_root=window.location.protocol+'//'+window.location.host;

navigator.serviceWorker.ready
  .then((serviceWorkerRegistration) => {
    serviceWorkerRegistration.pushManager.getSubscription()
    .then((subscription) => {
      http('post', '/#{renders.site}/api/push/register', subscription, function() {console.log('registered sub');});
    });
  });
  
  function http(method, route, data, after) {
	opts={method: method};
	if (data) {
	  opts = {method: method, body: JSON.stringify(data)};
	} else {
		
	}  
	  
    fetch(site_root+'/'+route, opts)
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
"""
    }
  }

  renders.content! do end
}
