import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static late String version;

  static Future<void> initialize() async {
    final info = await PackageInfo.fromPlatform();
    version = '${info.version}+${info.buildNumber}';
  }
}
