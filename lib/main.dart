import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/repositories/firestore_portfolio_repository.dart';
import 'package:portfolio/firebase_options.dart';
import 'package:portfolio/presentation/pages/splash/portfolio_splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const _PortfolioBootstrap());
}

class _PortfolioBootstrap extends StatefulWidget {
  const _PortfolioBootstrap();

  @override
  State<_PortfolioBootstrap> createState() => _PortfolioBootstrapState();
}

class _PortfolioBootstrapState extends State<_PortfolioBootstrap> {
  late Future<FirestorePortfolioRepository> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initialize();
  }

  Future<FirestorePortfolioRepository> _initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return FirestorePortfolioRepository(FirebaseFirestore.instance);
  }

  void _retry() {
    setState(() => _initialization = _initialize());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirestorePortfolioRepository>(
      future: _initialization,
      builder: (context, snapshot) {
        final repository = snapshot.data;
        if (repository != null) return App(repository: repository);

        return MaterialApp(
          title: 'Muhammad Tayyab — Senior Flutter Developer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          home: PortfolioSplashPage(
            errorMessage: snapshot.hasError
                ? 'The portfolio service could not be started.'
                : null,
            onRetry: _retry,
          ),
        );
      },
    );
  }
}
