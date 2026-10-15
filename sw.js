const CACHE_NAME = 'lzd-pwa-sync-v4';
const SHELL = ['./', './index.html', './hero.jpg', './markenmotiv.jpg', './manifest.webmanifest', './icon-192.png', './icon-512.png', './icon-maskable-512.png', './apple-touch-icon.png'];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(SHELL)));
  self.skipWaiting();
});
self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k=>k!==CACHE_NAME).map(k=>caches.delete(k)))));
  self.clients.claim();
});
self.addEventListener('fetch', event => {
  const req=event.request;
  if(req.method!=='GET') return;
  const url=new URL(req.url);
  // Fremde Domains / Supabase niemals cachen, damit alle Geräte Live-Daten sehen.
  if(url.origin!==self.location.origin) return;
  // Konfiguration und Navigationsansichten: immer Netzwerk zuerst.
  if(url.pathname.endsWith('/config.js')) {
    event.respondWith(fetch(req, {cache:'no-store'}));
    return;
  }
  if(req.mode==='navigate') {
    event.respondWith(fetch(req, {cache:'no-store'}).catch(()=>caches.match('./index.html')));
    return;
  }
  // Assets: Cache mit Online-Aktualisierung.
  event.respondWith(caches.match(req).then(cached => {
    const update=fetch(req).then(res=>{
      if(res.ok) caches.open(CACHE_NAME).then(c=>c.put(req,res.clone()));
      return res;
    });
    return cached || update;
  }));
});
