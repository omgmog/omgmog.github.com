if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/serviceWorker.js', {
    scope: '/'
  });
}