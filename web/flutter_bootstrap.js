{{flutter_js}}
{{flutter_build_config}}

const serviceWorkerVersion = {{flutter_service_worker_version}};

_flutter.loader.load({
  config: {
    canvasKitBaseUrl: 'canvaskit/',
  },
  serviceWorkerSettings: serviceWorkerVersion == null
      ? undefined
      : {serviceWorkerVersion},
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();

    const loading = document.getElementById('app-loading');
    if (loading) {
      loading.setAttribute('aria-hidden', 'true');
      window.setTimeout(() => loading.remove(), 200);
    }
  },
});
