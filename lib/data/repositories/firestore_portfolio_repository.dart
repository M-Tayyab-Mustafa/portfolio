import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio/core/constants/portfolio_local_content.dart';
import 'package:portfolio/domain/repositories/portfolio_repository.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';

class FirestorePortfolioRepository implements PortfolioRepository {
  const FirestorePortfolioRepository([this._firestore]);

  final FirebaseFirestore? _firestore;

  @override
  Stream<PortfolioContent> watchContent() {
    final firestore = _firestore ?? FirebaseFirestore.instance;
    final subscriptions = <StreamSubscription<dynamic>>[];
    Map<String, Map<String, dynamic>>? about;
    List<Map<String, dynamic>>? experiences;
    List<Map<String, dynamic>>? projects;
    List<Map<String, dynamic>>? services;
    List<Map<String, dynamic>>? skillGroups;
    List<Map<String, dynamic>>? testimonials;
    late final StreamController<PortfolioContent> controller;

    void emitIfReady() {
      final aboutDocuments = about;
      final experienceItems = experiences;
      final projectItems = projects;
      final serviceItems = services;
      final skillGroupItems = skillGroups;
      final testimonialItems = testimonials;
      if (aboutDocuments == null ||
          experienceItems == null ||
          projectItems == null ||
          serviceItems == null ||
          skillGroupItems == null ||
          testimonialItems == null) {
        return;
      }

      try {
        controller.add(
          _assembleContent(
            about: aboutDocuments,
            experiences: experienceItems,
            projects: projectItems,
            services: serviceItems,
            skillGroups: skillGroupItems,
            testimonials: testimonialItems,
          ),
        );
      } catch (error, stackTrace) {
        controller.addError(error, stackTrace);
      }
    }

    void reportError(Object error, StackTrace stackTrace) {
      controller.addError(error, stackTrace);
    }

    controller = StreamController<PortfolioContent>(
      onListen: () {
        subscriptions.addAll([
          firestore.collection('about').snapshots().listen((snapshot) {
            about = {
              for (final document in snapshot.docs)
                document.id: document.data(),
            };
            emitIfReady();
          }, onError: reportError),
          firestore.collection('experiences').snapshots().listen((snapshot) {
            experiences = _documents(snapshot);
            emitIfReady();
          }, onError: reportError),
          firestore.collection('projects').snapshots().listen((snapshot) {
            projects = _documents(snapshot);
            emitIfReady();
          }, onError: reportError),
          firestore.collection('services').snapshots().listen((snapshot) {
            services = _documents(snapshot);
            emitIfReady();
          }, onError: reportError),
          firestore.collection('skillGroups').snapshots().listen((snapshot) {
            skillGroups = _documents(snapshot);
            emitIfReady();
          }, onError: reportError),
          firestore.collection('testimonials').snapshots().listen((snapshot) {
            testimonials = _documents(snapshot);
            emitIfReady();
          }, onError: reportError),
        ]);
      },
      onCancel: () async {
        for (final subscription in subscriptions) {
          await subscription.cancel();
        }
      },
    );

    return controller.stream;
  }

  static List<Map<String, dynamic>> _documents(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs.map((document) => document.data()).toList();
  }

  static PortfolioContent _assembleContent({
    required Map<String, Map<String, dynamic>> about,
    required List<Map<String, dynamic>> experiences,
    required List<Map<String, dynamic>> projects,
    required List<Map<String, dynamic>> services,
    required List<Map<String, dynamic>> skillGroups,
    required List<Map<String, dynamic>> testimonials,
  }) {
    final profile = about['main'];
    final emailJs = about['emailJs'];
    final links = about['links'];
    final stats = about['stats']?['items'];
    final contactChannels = about['contactChannels']?['items'];
    if (profile == null ||
        emailJs == null ||
        links == null ||
        stats is! List ||
        contactChannels is! List) {
      throw const PortfolioContentNotFoundException();
    }

    return PortfolioContent.fromMap({
      'schemaVersion': PortfolioLocalContent.schemaVersion,
      'profile': {...profile, 'logoAsset': PortfolioLocalContent.logoAsset},
      'emailJs': emailJs,
      'links': links,
      'navigationLabels': PortfolioLocalContent.navigationLabels,
      'sectionHeadings': PortfolioLocalContent.sectionHeadings,
      'stats': stats,
      'socials': PortfolioLocalContent.socials(
        links: links,
        email: profile['email']?.toString() ?? '',
      ),
      'skillGroups': skillGroups,
      'services': services,
      'projects': projects,
      'experiences': experiences,
      'testimonials': testimonials,
      'contactChannels': contactChannels,
    });
  }
}
