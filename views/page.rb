require './build'
require 'json'
require "./tool"

obj      = JSON.parse(gets)
view     = obj["view"]
d = data = obj["data"]
title    = obj["title"]
def meta(h={}, &b)
  Node.new(:meta, h, &b)
end
puts(Node.new(:html) {
  head() { 
    title {"Hanley CMMS | #{title}"}

    meta name:"viewport", content:"width=device-width, initial-scale=1.0"
    meta name:"mobile-web-app-capable", content:"yes"
    
        self << '<link rel="manifest" href="/manifest.json">'
    link(rel: "stylesheet", href: "/css/default.css")
    script(src: "/js/core.js")  
    script {"window.site_root = '#{"/hanley/cmms/"}';"}
    self << %q[
    <link rel="" href="/vendor/fonts/Montserrat-Medium-Latin-Ext.woff2" as="font" type="font/woff2" crossorigin=""><link rel="" href="/vendor/fonts/Montserrat-Medium-Latin.woff2" as="font" type="font/woff2" crossorigin=""><link rel="preload" href="/vendor/fonts/Montserrat-SemiBold-Latin.woff2" as="font" type="font/woff2" crossorigin=""><link rel="preload" href="/vendor/fonts/Montserrat-Regular-Latin.woff2" as="font" type="font/woff2" crossorigin=""></link>
    ]
  } 

  self << FlexTable.new(id: :page) {
    row(class: 'header') {
      img(src: "/img/gg-logo.jpg", onclick: 'open_window("cmms-main","/hanley/cmms/")') {}.style! margin: :auto
      #span(onclick: "window.close()") {"X"}.add_class("close-button")
    }.style! flex: 0,"background-color": :white#, 'border-style': :outset
  
    eval(open(f="./views/"+view).read, binding, f, 1)
    
  }.add_class(:main)
   
  div(id: "popup") {
  
  }
  
  self << """

<script>
window.vapidPublicKey = new Uint8Array(#{ Base64.urlsafe_decode64(PUSH['public_key']).bytes });

navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {
  serviceWorkerRegistration.pushManager
  .subscribe({
    userVisibleOnly: true,
    applicationServerKey: window.vapidPublicKey
  });
});

navigator.serviceWorker.ready
  .then((serviceWorkerRegistration) => {
    serviceWorkerRegistration.pushManager.getSubscription()
    .then((subscription) => {
      http('post', '/api/push/register', subscription, function() {console.log('registered sub');});
    });
  });


</script>
  """
}.to_s)

