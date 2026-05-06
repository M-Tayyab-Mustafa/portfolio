part of 'utils_exports.dart';

class Constants {
  const Constants._();

  static const String logoPath = 'assets/images/logo.png';

  static const String lightBackground = 'assets/images/light_background.png';
  static const String darkBackground = 'assets/images/dark_background.png';

  static const String appShippedIcon = 'assets/icons/app_shipped.svg';
  static const String experienceIcon = 'assets/icons/experience.svg';
  static const String platformIcon = 'assets/icons/platform.svg';
  static const String flutterIcon = 'assets/icons/flutter.svg';
  static const String stateManagementIcon = 'assets/icons/state_management.svg';
  static const String firebaseIcon = 'assets/icons/firebase.svg';
  static const String apiData = 'assets/icons/api_data.svg';

  static double getHeight(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return 0;

    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.height ?? 0;
  }
}
