async function prepareBolaVaPwa() {
  if ('storage' in navigator && 'persist' in navigator.storage) {
    try {
      await navigator.storage.persist();
    } catch (error) {
      console.warn('El navegador no pudo habilitar almacenamiento persistente:', error);
    }
  }

  if (!('serviceWorker' in navigator) || !/^https?:$/.test(location.protocol)) {
    return;
  }

  let hasController = Boolean(navigator.serviceWorker.controller);
  let reloading = false;
  navigator.serviceWorker.addEventListener('controllerchange', () => {
    if (hasController && !reloading) {
      reloading = true;
      location.reload();
    }
    hasController = true;
  });

  try {
    const appScope = new URL('.', document.baseURI).pathname;
    await navigator.serviceWorker.register(new URL('service-worker.js', document.baseURI), {
      scope: appScope,
      updateViaCache: 'none',
    });
  } catch (error) {
    console.warn('No se pudo instalar el modo sin conexión:', error);
  }
}

prepareBolaVaPwa();