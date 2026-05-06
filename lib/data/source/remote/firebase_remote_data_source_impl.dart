import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio/data/models/about_model.dart';
import 'package:portfolio/data/models/experience_model.dart';
import 'package:portfolio/data/models/project_model.dart';
import 'package:portfolio/data/models/skill_model.dart';

abstract class PortfolioRemoteDataSource {
  Future<AboutModel> fetchAbout();
  Future<List<SkillAnalyticModel>> fetchSkillAnalytics();
  Future<List<TechnicalSkillModel>> fetchTechnicalSkills();
  Future<List<ExperienceModel>> fetchExperiences();
  Future<List<ProjectModel>> fetchFeaturedProjects();
  Future<List<ProjectModel>> fetchAllProjects();
}

class FirebaseRemoteDataSourceImpl implements PortfolioRemoteDataSource {
  FirebaseRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  @override
  Future<AboutModel> fetchAbout() async {
    final doc = await _db.collection('about').doc('main').get();
    if (doc.exists && doc.data() != null) {
      return AboutModel.fromMap(doc.data()!);
    }
    throw Exception('About document not found');
  }

  @override
  Future<List<SkillAnalyticModel>> fetchSkillAnalytics() async {
    final snap = await _db.collection('skill_analytics').orderBy('order').get();
    return snap.docs.map((d) => SkillAnalyticModel.fromMap(d.data())).toList();
  }

  @override
  Future<List<TechnicalSkillModel>> fetchTechnicalSkills() async {
    final snap = await _db
        .collection('technical_skills')
        .orderBy('order')
        .get();
    return snap.docs.map((d) => TechnicalSkillModel.fromMap(d.data())).toList();
  }

  @override
  Future<List<ExperienceModel>> fetchExperiences() async {
    final snap = await _db.collection('experiences').orderBy('order').get();
    return snap.docs.map((d) => ExperienceModel.fromMap(d.data())).toList();
  }

  @override
  Future<List<ProjectModel>> fetchFeaturedProjects() async {
    final snap = await _db
        .collection('projects')
        .where('isFeatured', isEqualTo: true)
        .orderBy('order')
        .get();
    return snap.docs.map((d) => ProjectModel.fromMap(d.data())).toList();
  }

  @override
  Future<List<ProjectModel>> fetchAllProjects() async {
    final snap = await _db.collection('projects').orderBy('order').get();
    return snap.docs.map((d) => ProjectModel.fromMap(d.data())).toList();
  }
}
