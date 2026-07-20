import 'package:portfolio/shared/models/portfolio_models.dart';

abstract interface class PortfolioRepository {
  Stream<PortfolioContent> watchContent();
}

class PortfolioContentNotFoundException implements Exception {
  const PortfolioContentNotFoundException();

  @override
  String toString() => 'PortfolioContentNotFoundException';
}

class PortfolioRepositoryInitializationException implements Exception {
  const PortfolioRepositoryInitializationException(this.message);

  final String message;

  @override
  String toString() => message;
}
