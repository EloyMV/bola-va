{{flutter_js}}
{{flutter_build_config}}

const startup = document.getElementById('startup');
const startupStatus = document.getElementById('startup-status');
const startupError = document.getElementById('startup-error');
const retryButton = document.getElementById('startup-retry');

function showStartupError(error) {
  console.error('No se pudo iniciar Bola Va:', error);
  startupStatus.hidden = true;
  startupError.hidden = false;
  retryButton.hidden = false;
}

async function startBolaVa() {
  startupStatus.hidden = false;
  startupError.hidden = true;
  retryButton.hidden = true;
  try {
    await _flutter.loader.load({
      onEntrypointLoaded: async (engineInitializer) => {
        try {
          const appRunner = await engineInitializer.initializeEngine();
          await appRunner.runApp();
          startup.remove();
        } catch (error) {
          showStartupError(error);
        }
      },
    });
  } catch (error) {
    showStartupError(error);
  }
}

retryButton.addEventListener('click', startBolaVa);
startBolaVa();