def $CSS.to_s
  map do |r, s|
    "#{r} {"+
    s.to_s+
    "}\n"
  end.join("\n")
end

rule "body",
  margin: 0,
  padding: 0,
  min_width: 100.vw,
  max_width: 100.vw,
  max_height: 100.vh

rule '.main', 
  margin: :auto,
  min_width: 80.vw,
  max_width: 80.vw,
  max_height: 80.vh,
  min_height: 80.vh,
  margin_top: 10.vh
rule 'content'  

Html.new() {
  $root = self
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

  body(class: 'viewport') {
    div(class: 'flex-column main') {
       img(src: "/img/gg-logo.jpg", onclick: 'open_window("cmms-main","/hanley-cmms")') {}.style! margin: :auto, flex: 0
       div(class: 'content flex-column') {
         renders.content! do end
       }.style! flex: 1
    }
  }
  
  head() {
    style {$CSS.to_s}
  }
}
