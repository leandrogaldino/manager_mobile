import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:manager_mobile/core/exceptions/connection_exception.dart';
import 'package:manager_mobile/interfaces/connection.dart';

class NetworkConnection implements Connection {
  @override
  Future<bool> hasConnection() async {
    try {
      final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi)) {
        return true;
      }
      return false;
    } catch (e, s) {
      String code = 'CON001';
      String message = 'Erro ao testar a conexão';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw ConnectionException(code, message);
    }
  }
}
