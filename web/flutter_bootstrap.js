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
});
