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
    } catch (e) {
      throw ConnectionException('Erro ao testar a conexão.');
    }
  }
}
