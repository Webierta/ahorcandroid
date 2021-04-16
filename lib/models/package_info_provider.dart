import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

class PackageInfoProvider with ChangeNotifier {
  String _version = 'Unknown';

  Future<void> initPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version = info.version;
    } catch (e) {
      _version = 'No disponible';
    } finally {
      notifyListeners();
    }
  }

  String get version => _version;
}
