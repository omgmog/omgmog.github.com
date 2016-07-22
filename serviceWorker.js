/*global self: true, caches: true */
'use strict';

const cache = {
    version: '0.0.2'
};

self.addEventListener('fetch', event => {
    const url = new URL(event.request.url);

    if (url.pathname.startsWith('/post/')) {
        caches.open(cache.version)
            .then(cache => cache.add(url));
    }

    event.respondWith(
        caches.match(event.request)
            .then(response => response || fetch(event.request))
            .catch(() => {
                if (event.request.mode === 'navigate') {
                    return caches.match('/offline.html');
                }
            })
    );
});

self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(cache.version)
            .then(cache => cache.addAll([
                '/',
                '/assets/pygments.css',
                '/assets/style.css',
                '/offline.html'
            ]))
    );
});

self.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cacheName => {
                    if (cache.version !== cacheName) {
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
});