import 'package:portfolio/utils/exports.dart';

class AppThemeScope extends InheritedNotifier<ValueNotifier<ThemeMode>> {
  const AppThemeScope({
    super.key,
    required ValueNotifier<ThemeMode> themeMode,
    required super.child,
  }) : super(notifier: themeMode);

  static ThemeMode modeOf(BuildContext context) {
    return _notifierOf(context, listen: true).value;
  }

  static void toggle(BuildContext context) {
    final scope = _notifierOf(context);
    final brightness = Theme.of(context).brightness;
    scope.value = brightness == Brightness.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static ValueNotifier<ThemeMode> _notifierOf(
    BuildContext context, {
    bool listen = false,
  }) {
    final AppThemeScope? scope;
    if (listen) {
      scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    } else {
      final element = context
          .getElementForInheritedWidgetOfExactType<AppThemeScope>();
      scope = element?.widget as AppThemeScope?;
    }
    return scope!.notifier!;
  }
}
