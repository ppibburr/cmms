load "./styles/common.rb"

Html.new() {
  $root = self
  head() {
    meta() {
      meta name:"viewport", content:"width=device-width, initial-scale=1.0"
      meta name:"mobile-web-app-capable", content:"yes"
      link rel:"manifest", href:"/manifest.json"
    }
    script {"""
  window.vapidPublicKey = new Uint8Array(#{ Base64.urlsafe_decode64(PUSH['public_key']).bytes });
  """}
    script src: '/js/core.js'
    script src: '/js/cmms.js'

    script {"""
  navigator.serviceWorker.ready
  .then((serviceWorkerRegistration) => {
    serviceWorkerRegistration.pushManager.getSubscription()
    .then((subscription) => {
      http('post', '#{''||renders.site}/api/push/register', subscription, function() {console.log('registered sub');});
    });
  });
  """}
  }

  body(class: 'viewport') {
    div(class: 'flex-column main') {
       img(src: "/img/gg-logo.jpg", onclick: 'open_window("cmms-main","/hanley-cmms")') {}.style! margin: :auto, flex: 0
       div(class: 'content flex-column') {
         renders.content! do end
       }.style! flex: 1
    }

    div(id: 'popup', class: 'flex-column') {;
      div(id: 'popup-inner', class: 'popup flex-column') {
        span(id: 'popup-title') {""}
        div(id: 'popup-content', class: 'flex-column') {}.style! flex:1
      }.style! flex:1
    }
  }
  
  head() {
    style {$CSS.to_s}
  }
  
  script {"""
  urlParams = new URLSearchParams(window.location.search);
  _view  = urlParams.get('view')
  _title = urlParams.get('title')
  if (_view) {
    popup(_view, _title);
  }  
  """}
}
