import 'export.dart';

class AppHelper {
  static AppHelper? _instance;

  AppHelper._privateConstructor();

  static AppHelper get instance => _instance ??= AppHelper._privateConstructor();

  StreamController<Size> streamController = StreamController<Size>();
  late Stream<Size> _broadcastStream;

  Stream<Size> get stream => _broadcastStream;

  static Size get screenSize => _screenSize!;

  broadcast() {
    _broadcastStream = streamController.stream.asBroadcastStream();
    stream.listen((size) {
      _updateSize(size);
    });
  }

  static double get _maxMobileSize => 540;

  static double get _maxTabSize => 1280;
  static Size? _screenSize;
  static Device _deviceType = Device.mobile;

  static Device get kDevice => _deviceType;

  static Device get kWeb => kIsWeb ? Device.web : kDevice;

  bool isMobile(context) => DeviceType.of(context).device == Device.mobile;

  bool isTab(context) => DeviceType.of(context).device == Device.tab;

  bool isWeb(context) => DeviceType.of(context).device == Device.web;

  bool isDeskTop(context) => DeviceType.of(context).device == Device.desktop;

  static void _updateSize(Size size) {
    _screenSize = size;
    if ((_screenSize?.width ?? 0) <= _maxMobileSize) {
      _deviceType = Device.mobile;
    } else if (((_screenSize?.width ?? 0) > _maxMobileSize && (_screenSize?.width ?? 0) <= _maxTabSize)) {
      _deviceType = Device.tab;
    } else if (((_screenSize?.width ?? 0) > _maxTabSize)) {
      _deviceType = Device.desktop;
    } else {
      _deviceType = Device.web;
    }
  }

  //* Padding
  static const double padding_2 = 2.0;
  static const double padding_5 = 5.0;
  static const double padding_10 = 10.0;
  static const double padding_15 = 15.0;
  static const double padding_20 = 20.0;

  //* Border Radius
  static const double borderRadiusInfinity = 9999;
}
