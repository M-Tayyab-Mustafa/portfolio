import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio/core/constants/firestore_names.dart';
import 'package:portfolio/core/constants/portfolio_local_content.dart';
import 'package:portfolio/core/utils/model_normalizer.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/domain/repositories/portfolio_repository.dart';

class FirestorePortfolioRepository implements PortfolioRepository {
  const FirestorePortfolioRepository([this._firestore]);

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _instance => _firestore ?? FirebaseFirestore.instance;

  @override
  Stream<PersonalProfile> watchProfile() {
    return _watchAboutDocument(
      AboutDocument.main,
      (map) => PersonalProfile.fromMap(
        map,
        logoAssetOverride: PortfolioLocalContent.logoAsset,
      ),
      (model) => model.toMap(),
    );
  }

  @override
  Stream<EmailJsConfiguration> watchEmailJsConfiguration() {
    return _watchAboutDocument(
      AboutDocument.emailJs,
      EmailJsConfiguration.fromMap,
      (model) => model.toMap(),
    );
  }

  @override
  Stream<PortfolioLinks> watchLinks() {
    return _watchAboutDocument(
      AboutDocument.links,
      PortfolioLinks.fromMap,
      (model) => model.toMap(),
    );
  }

  @override
  Stream<StatsDocument> watchStats() {
    return _watchAboutDocument(
      AboutDocument.stats,
      StatsDocument.fromMap,
      (model) => model.toMap(),
    );
  }

  @override
  Stream<ContactChannelsDocument> watchContactChannels() {
    return _watchAboutDocument(
      AboutDocument.contactChannels,
      ContactChannelsDocument.fromMap,
      (model) => model.toMap(),
    );
  }

  @override
  Stream<List<ExperienceItem>> watchExperiences() {
    return _watchCollection(
      PortfolioCollection.experiences,
      ExperienceItem.fromMap,
      (model) => model.toMap(),
    ).map(
      (models) => ModelNormalizer.enabledAndOrdered(
        models,
        enabled: (model) => model.enabled,
        order: (model) => model.order,
      ),
    );
  }

  @override
  Stream<List<PortfolioProject>> watchProjects() {
    return _watchCollection(
      PortfolioCollection.projects,
      PortfolioProject.fromMap,
      (model) => model.toMap(),
    ).map(
      (models) => ModelNormalizer.enabledAndOrdered(
        models,
        enabled: (model) => model.enabled,
        order: (model) => model.order,
      ),
    );
  }

  @override
  Stream<List<ServiceItem>> watchServices() {
    return _watchCollection(
      PortfolioCollection.services,
      ServiceItem.fromMap,
      (model) => model.toMap(),
    ).map(
      (models) => ModelNormalizer.enabledAndOrdered(
        models,
        enabled: (model) => model.enabled,
        order: (model) => model.order,
      ),
    );
  }

  @override
  Stream<List<SkillGroup>> watchSkillGroups() {
    return _watchCollection(
      PortfolioCollection.skillGroups,
      SkillGroup.fromMap,
      (model) => model.toMap(),
    ).map(
      (models) => ModelNormalizer.enabledAndOrdered(
        models,
        enabled: (model) => model.enabled,
        order: (model) => model.order,
      ),
    );
  }

  @override
  Stream<List<TestimonialItem>> watchTestimonials() {
    return _watchCollection(
      PortfolioCollection.testimonials,
      TestimonialItem.fromMap,
      (model) => model.toMap(),
    ).map(
      (models) => ModelNormalizer.enabledAndOrdered(
        models,
        enabled: (model) => model.enabled,
        order: (model) => model.order,
      ),
    );
  }

  Stream<T> _watchAboutDocument<T>(
    AboutDocument document,
    T Function(Map<String, Object?> map) fromMap,
    Map<String, Object?> Function(T model) toMap,
  ) {
    final reference = _instance
        .collection(PortfolioCollection.about.name)
        .doc(document.name)
        .withConverter<T>(
          fromFirestore: (snapshot, _) => fromMap(snapshot.data() ?? const {}),
          toFirestore: (model, _) => toMap(model),
        );

    return reference.snapshots().map((snapshot) {
      final model = snapshot.data();
      if (model == null) {
        throw const PortfolioDataNotFoundException();
      }
      return model;
    });
  }

  Stream<List<T>> _watchCollection<T>(
    PortfolioCollection collection,
    T Function(Map<String, Object?> map) fromMap,
    Map<String, Object?> Function(T model) toMap,
  ) {
    final reference = _instance
        .collection(collection.name)
        .withConverter<T>(
          fromFirestore: (snapshot, _) => fromMap(snapshot.data() ?? const {}),
          toFirestore: (model, _) => toMap(model),
        );

    return reference.snapshots().map(
      (snapshot) => snapshot.docs.map((document) => document.data()).toList(),
    );
  }
}
