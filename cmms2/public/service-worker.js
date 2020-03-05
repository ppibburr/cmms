console.log('ok');
CACHE_NAME = 'cmms-cache-v1';

// Listen for the install event, which fires when the service worker is installing
self.addEventListener('install', event => {
  // Ensures the install event doesn't complete until after the cache promise resolves
  // This is so we don't move on to other events until the critical initial cache is done
event.waitUntil(
    caches.open(CACHE_NAME).then(function(cache) {
      return cache.addAll(
        [
          '/css/default.css',
          '/js/core.js',
          '/img/gg-logo.jpg',
          '/img/icon-512x512.png',
          '/img/icon-192x192.png',
          '/img/inv.png',
          '/img/wo.png',
          '/img/equip.svg',
          '/hanley/cmms/'
        ]
      );
    })
  );
});

// Listen for the activate event, which is fired after installation
// Activate is when the service worker actually takes over from the previous
// version, which is a good time to clean up old caches
self.addEventListener('activate', event => {
  console.log('Finally active. Ready to serve!');
});

// Listen for browser fetch events. These fire any time the browser tries to load
// any outside resources
self.addEventListener('fetch', function(event) {
  if (event.request.method =='GET') {            
  event.respondWith(
    caches.open(CACHE_NAME).then(function(cache) {
      return cache.match(event.request).then(function (response) {
        if(response) {
		  //console.log(event.request);
		  return response;
		} else {
		  return fetch(event.request);//.then(function(response) {
            //cache.put(event.request, response.clone());
            //return response;
          //});
        }
      });
    })
  );
}
});

// serviceworker.js
// The serviceworker context can respond to 'push' events and trigger
// notifications on the registration property
self.addEventListener("push", (event) => {
  console.log(msg=event.data.json());
  let title = msg.title;
  let body = msg.body;
  let tag = "push-simple-demo-notification-tag";
  let icon = msg.icon || '/img/wo.png';;

  event.waitUntil(
    self.registration.showNotification(title, { body, icon, tag, data: {url: msg.url} })
  )
});


self.addEventListener('notificationclick', function (event) {
  event.notification.close();
  if(event.notification.data) {
	  if (event.notification.data.url) {
        clients.openWindow(event.notification.data.url);
      }
  }
});

self.addEventListener("pushsubscriptionchange", event => {
  event.waitUntil(swRegistration.pushManager.subscribe(event.oldSubscription.options)
    .then(subscription => {
      return fetch("/api/push/subscription/changed", {
        method: "put",
        headers: {
          "Content-type": "application/json"
        },
        body: JSON.stringify({
          subscription: subscription,
          old:          event.oldSubscription
        })
      });
    })
  );
}, false)
