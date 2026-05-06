import 'package:portfolio/domain/domain_exports.dart';

class GetAboutUseCase {
  const GetAboutUseCase(this._repository);
  final PortfolioRepository _repository;
  Future<AboutEntity> call() => _repository.getAbout();
}
