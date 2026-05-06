part of '_bloc.dart';

class AboutState {
  final AboutEntity? about;
  final bool isLoading;

  const AboutState({this.about, this.isLoading = false});

  AboutState copyWith({AboutEntity? about, bool? isLoading}) => AboutState(
    about: about ?? this.about,
    isLoading: isLoading ?? this.isLoading,
  );
}
