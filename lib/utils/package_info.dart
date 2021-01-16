import 'package:package_info/package_info.dart';

class PackInfo {
  static PackageInfo _packageInfo;

  static String _version = 'Not available';

  init() async {
    if (_packageInfo == null) {
      _packageInfo = await PackageInfo.fromPlatform();
      _version = _packageInfo.version;
    }
  }

  String get version => _version;
}
