import 'utils/export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AppHelper.kWeb == Device.web && AppHelper.kDevice == Device.desktop) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(300, 600));
  }
  AppHelper.instance.broadcast();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateScreenSize();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _updateScreenSize();
  }

  void _updateScreenSize() {
    var padding = MediaQuery.paddingOf(context);
    var mediaQuery = MediaQuery.sizeOf(context);
    AppHelper.instance.streamController.add(Size(mediaQuery.width, mediaQuery.height - padding.top - padding.bottom));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Size>(
        stream: AppHelper.instance.stream,
        builder: (context, snapshot) {
          return DeviceType(
            device: AppHelper.kDevice,
            child: MaterialApp.router(
              routerConfig: RouterGenerator.instance.routerConfig,
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
            ),
          );
        });
  }
}
