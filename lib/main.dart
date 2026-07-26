import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/repositories/firestore_portfolio_repository.dart';
import 'package:portfolio/firebase_options.dart';
import 'package:portfolio/presentation/pages/splash/portfolio_splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await _startPortfolio();
}

Future<void> _startPortfolio() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    runApp(
      App(repository: FirestorePortfolioRepository(FirebaseFirestore.instance)),
    );
  } catch (_) {
    runApp(const _PortfolioStartupFailure());
  }
}

class _PortfolioStartupFailure extends StatelessWidget {
  const _PortfolioStartupFailure();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muhammad Tayyab — Senior Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: PortfolioSplashPage(
        errorMessage: 'The portfolio service could not be started.',
        onRetry: _startPortfolio,
      ),
    );
  }
}
