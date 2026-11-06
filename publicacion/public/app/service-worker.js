const CACHE_PREFIX = 'bola-va-static-';
const CACHE_NAME = "bola-va-static-9c00b51f24626fc65b4f";
const APP_SCOPE = new URL('./', self.location).href;
const APP_INDEX = new URL('index.html', APP_SCOPE).href;
const PRECACHE_URLS = ["/bola-va/app/assets/AssetManifest.bin","/bola-va/app/assets/AssetManifest.bin.json","/bola-va/app/assets/assets/fonts/Roboto-Bold.ttf","/bola-va/app/assets/assets/fonts/Roboto-LICENSE.txt","/bola-va/app/assets/assets/fonts/Roboto-Medium.ttf","/bola-va/app/assets/assets/fonts/Roboto-Regular.ttf","/bola-va/app/assets/assets/images/bola_va_icono.png","/bola-va/app/assets/FontManifest.json","/bola-va/app/assets/fonts/MaterialIcons-Regular.otf","/bola-va/app/assets/NOTICES","/bola-va/app/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf","/bola-va/app/assets/shaders/ink_sparkle.frag","/bola-va/app/assets/shaders/stretch_effect.frag","/bola-va/app/canvaskit/canvaskit.js","/bola-va/app/canvaskit/canvaskit.js.symbols","/bola-va/app/canvaskit/canvaskit.wasm","/bola-va/app/canvaskit/chromium/canvaskit.js","/bola-va/app/canvaskit/chromium/canvaskit.js.symbols","/bola-va/app/canvaskit/chromium/canvaskit.wasm","/bola-va/app/canvaskit/skwasm_heavy.js","/bola-va/app/canvaskit/skwasm_heavy.js.symbols","/bola-va/app/canvaskit/skwasm_heavy.wasm","/bola-va/app/canvaskit/skwasm.js","/bola-va/app/canvaskit/skwasm.js.symbols","/bola-va/app/canvaskit/skwasm.wasm","/bola-va/app/canvaskit/webparagraph/canvaskit.js","/bola-va/app/canvaskit/webparagraph/canvaskit.js.symbols","/bola-va/app/canvaskit/webparagraph/canvaskit.wasm","/bola-va/app/canvaskit/wimp.js","/bola-va/app/canvaskit/wimp.js.symbols","/bola-va/app/canvaskit/wimp.wasm","/bola-va/app/favicon.png","/bola-va/app/flutter_bootstrap.js","/bola-va/app/flutter.js","/bola-va/app/icons/apple-touch-icon.png","/bola-va/app/icons/Icon-192.png","/bola-va/app/icons/Icon-512.png","/bola-va/app/icons/Icon-maskable-192.png","/bola-va/app/icons/Icon-maskable-512.png","/bola-va/app/index.html","/bola-va/app/main.dart.js","/bola-va/app/manifest.json","/bola-va/app/pwa.js","/bola-va/app/version.json"].map((url) => new URL(url, self.location.origin).href);
const PRECACHE_SET = new Set(PRECACHE_URLS);

self.addEventListener('install', (event) => {
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE_NAME);
    try {
      for (const url of PRECACHE_URLS) {
        const response = await fetch(new Request(url, { cache: 'reload' }));
        if (!response.ok || response.type === 'opaque') {
          throw new Error('No se pudo precargar ' + url + ': ' + response.status);
        }
        await cache.put(url, response);
      }
      await self.skipWaiting();
    } catch (error) {
      await caches.delete(CACHE_NAME);
      throw error;
    }
  })());
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const names = await caches.keys();
    await Promise.all(names
      .filter((name) => name.startsWith(CACHE_PREFIX) && name !== CACHE_NAME)
      .map((name) => caches.delete(name)));
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  const url = new URL(request.url);
  if (request.method !== 'GET' || url.origin !== self.location.origin || !url.pathname.startsWith(new URL(APP_SCOPE).pathname)) return;
  if (url.pathname.includes('/api/') || url.pathname.includes('/apk/')) return;

  if (request.mode === 'navigate') {
    event.respondWith((async () => {
      try {
        return await fetch(request);
      } catch {
        const cache = await caches.open(CACHE_NAME);
        return await cache.match(APP_INDEX) || new Response('Bola Va no está disponible sin conexión.', {
          status: 503,
          headers: { 'Content-Type': 'text/plain; charset=utf-8' },
        });
      }
    })());
    return;
  }

  if (PRECACHE_SET.has(url.href)) {
    event.respondWith((async () => {
      const cache = await caches.open(CACHE_NAME);
      return await cache.match(request) || fetch(request);
    })());
  }
});
