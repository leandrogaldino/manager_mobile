import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class InternetConnectionStream {
  InternetConnectionStream._();

  static final _controller = StreamController<bool>.broadcast();
  static Stream<bool> get stream => _controller.stream;

  static bool _lastStatus = false;
  static StreamSubscription? _subscription;

  static const Duration _timeout = Duration(seconds: 3);

  static final List<Uri> _endpoints = [
    Uri.parse('https://clients3.google.com/generate_204'),
    Uri.parse('https://www.google.com'),
    Uri.parse('https://www.cloudflare.com'),
    Uri.parse('https://www.apple.com'),
  ];

  static void start() {
    _subscription ??= Connectivity().onConnectivityChanged.listen((_) async {
      final hasInternet = await _checkInternet();
      _emitIfChanged(hasInternet);
    });
    _checkInternet().then(_emitIfChanged);
  }

  static void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  static void _emitIfChanged(bool value) {
    if (_lastStatus != value) {
      _lastStatus = value;
      _controller.add(value);
    }
  }

  static Future<bool> _checkInternet() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.isEmpty || connectivity.contains(ConnectivityResult.none)) {
      return false;
    }
    for (final endpoint in _endpoints) {
      try {
        final response = await http.get(endpoint).timeout(_timeout);
        if (response.statusCode == 200 || response.statusCode == 204) {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  static Future<bool> hasInternetNow() async {
    final hasInternet = await _checkInternet();
    _emitIfChanged(hasInternet);
    return hasInternet;
  }
}
