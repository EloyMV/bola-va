const statusElement = document.getElementById('android-status');
const downloadLink = document.getElementById('apk-download');

function formatBytes(bytes) {
  if (!Number.isSafeInteger(bytes) || bytes < 0) return 'desconocido';
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(0)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

async function loadRelease() {
  try {
    const response = await fetch(new URL('release.json', document.baseURI), { cache: 'no-store' });
    if (!response.ok) throw new Error(`release.json respondió ${response.status}`);
    const release = await response.json();
    if (!release.apk?.path || !release.apk?.fileName || !release.apk?.sha256) {
      throw new Error('Faltan metadatos de descarga del APK.');
    }

    document.getElementById('release-version').textContent = release.version;
    document.getElementById('apk-size').textContent = formatBytes(release.apk.sizeBytes);
    document.getElementById('min-android').textContent = release.minAndroid;
    document.getElementById('apk-sha256').textContent = release.apk.sha256;
    downloadLink.href = new URL(release.apk.path, document.baseURI).href;
    downloadLink.download = release.apk.fileName;
    downloadLink.hidden = false;
    statusElement.textContent = 'Archivo de instalación listo.';
  } catch (error) {
    statusElement.textContent = 'La descarga Android aún no está disponible.';
    console.error('No se pudieron cargar los datos de release:', error);
  }
}

loadRelease();