import { createHash } from 'node:crypto';
import { promises as fs } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const buildDirectory = path.join(root, 'build', 'web');
const publicRoot = path.join(root, 'publicacion', 'public');
const appDirectory = path.join(publicRoot, 'app');
const reportPath = path.join(root, 'publicacion', 'pwa-report.json');
const appScope = process.env.BOLA_PWA_SCOPE || '/app/';
const packagerVersion = 1;

function sha256(bytes) {
  return createHash('sha256').update(bytes).digest('hex');
}

function isWithin(parent, target) {
  const relative = path.relative(parent, target);
  return relative !== '' && relative !== '..' && !relative.startsWith(`..${path.sep}`) && !path.isAbsolute(relative);
}

async function pathExists(target) {
  try {
    return await fs.lstat(target);
  } catch (error) {
    if (error.code === 'ENOENT') return null;
    throw error;
  }
}

async function copyBuildFiles(sourceDirectory, destinationDirectory, relativeDirectory = '') {
  const entries = await fs.readdir(sourceDirectory, { withFileTypes: true });
  entries.sort((left, right) => left.name.localeCompare(right.name));
  const files = [];

  for (const entry of entries) {
    const sourcePath = path.join(sourceDirectory, entry.name);
    const relativePath = path.posix.join(relativeDirectory.split(path.sep).join('/'), entry.name);
    const details = await fs.lstat(sourcePath);

    if (details.isSymbolicLink()) {
      throw new Error(`No se empaquetan enlaces simbólicos: ${sourcePath}`);
    }
    if (entry.name.startsWith('.') || entry.name.endsWith('.map')) continue;
    if (details.isDirectory()) {
      files.push(...await copyBuildFiles(sourcePath, destinationDirectory, relativePath));
      continue;
    }
    if (!details.isFile() || relativePath === 'flutter_service_worker.js') continue;

    let bytes = await fs.readFile(sourcePath);
    if (relativePath === 'manifest.json') {
      const manifest = JSON.parse(bytes.toString('utf8'));
      manifest.id = appScope;
      manifest.start_url = appScope;
      manifest.scope = appScope;
      bytes = Buffer.from(`${JSON.stringify(manifest, null, 2)}\n`);
    }
    const destinationPath = path.join(destinationDirectory, ...relativePath.split('/'));
    await fs.mkdir(path.dirname(destinationPath), { recursive: true });
    await fs.writeFile(destinationPath, bytes);
    files.push({ path: relativePath, size: bytes.length, sha256: sha256(bytes) });
  }

  return files;
}

function createServiceWorker(cacheName, files) {
  const urls = files.map(({ path: filePath }) => new URL(filePath, `https://bolava.invalid${appScope}`).pathname);
  return `const CACHE_PREFIX = 'bola-va-static-';
const CACHE_NAME = ${JSON.stringify(cacheName)};
const APP_SCOPE = new URL('./', self.location).href;
const APP_INDEX = new URL('index.html', APP_SCOPE).href;
const PRECACHE_URLS = ${JSON.stringify(urls)}.map((url) => new URL(url, self.location.origin).href);
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
`;
}

async function main() {
  const parsedScope = new URL(appScope, 'https://bolava.invalid');
  if (!appScope.startsWith('/') || !appScope.endsWith('/') || parsedScope.pathname !== appScope || appScope.includes('..')) {
    throw new Error('BOLA_PWA_SCOPE debe ser una ruta absoluta del sitio que empiece y termine con /.');
  }
  if (!isWithin(publicRoot, appDirectory)) {
    throw new Error('El destino de la PWA debe permanecer dentro de publicacion/public.');
  }
  const buildDetails = await pathExists(buildDirectory);
  if (!buildDetails?.isDirectory() || buildDetails.isSymbolicLink()) {
    throw new Error(`No se encontró una compilación web segura en ${buildDirectory}.`);
  }

  const currentOutput = await pathExists(appDirectory);
  if (currentOutput?.isSymbolicLink()) {
    throw new Error(`No se elimina el destino porque es un enlace simbólico: ${appDirectory}`);
  }
  if (currentOutput) await fs.rm(appDirectory, { recursive: true, force: true });
  await fs.mkdir(appDirectory, { recursive: true });

  const files = await copyBuildFiles(buildDirectory, appDirectory);
  if (!files.some(({ path: filePath }) => filePath === 'index.html')) {
    throw new Error('La compilación web no contiene index.html.');
  }
  const indexHtml = await fs.readFile(path.join(appDirectory, 'index.html'), 'utf8');
  if (!indexHtml.includes(`<base href="${appScope}">`)) {
    throw new Error(`La compilación no usa el base-href esperado: ${appScope}`);
  }

  const fingerprintInput = JSON.stringify({ packagerVersion, appScope, files });
  const contentHash = sha256(fingerprintInput);
  const cacheName = `bola-va-static-${contentHash.slice(0, 20)}`;
  await fs.writeFile(path.join(appDirectory, 'service-worker.js'), createServiceWorker(cacheName, files));

  const report = {
    app: 'Bola Va',
    scope: appScope,
    packagerVersion,
    cacheName,
    contentHash,
    files,
  };
  await fs.mkdir(path.dirname(reportPath), { recursive: true });
  await fs.writeFile(reportPath, `${JSON.stringify(report, null, 2)}\n`);
  console.log(`PWA empaquetada: ${files.length} archivos; caché ${cacheName}.`);
  console.log(`Informe SHA-256: ${path.relative(root, reportPath)}`);
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});