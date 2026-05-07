import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/di/injection.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Injection.init();
  usePathUrlStrategy();
  runApp(
    ResponsiveBreakpoints.builder(
      breakpoints: const [
        Breakpoint(start: 0, end: 480, name: MOBILE),
        Breakpoint(start: 481, end: 1023, name: TABLET),
        Breakpoint(start: 1024, end: 1920, name: DESKTOP),
        Breakpoint(start: 1921, end: double.infinity, name: '4K'),
      ],
      child: const App(),
    ),
  );
}
