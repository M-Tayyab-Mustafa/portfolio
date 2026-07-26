import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/data/repositories/firestore_portfolio_repository.dart';
import 'package:portfolio/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    App(repository: FirestorePortfolioRepository(FirebaseFirestore.instance)),
  );
}
