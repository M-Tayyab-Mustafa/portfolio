import '../export.dart';

class DeviceType extends InheritedWidget {
  final Device device;

  const DeviceType({
    super.key,
    required super.child,
    required this.device,
  });

  // Method to retrieve the widget from context
  static DeviceType of(BuildContext context) {
    final DeviceType? result = context.dependOnInheritedWidgetOfExactType<DeviceType>();
    assert(result != null, 'No MyCustomWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DeviceType oldWidget) {
    return oldWidget.device != device;
  }
}
