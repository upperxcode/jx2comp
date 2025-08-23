import 'package:connectivity_plus/connectivity_plus.dart';

class Jx2ConnectivityHelper {
  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Stream<bool> watchInternetConnection() {
    return Connectivity().onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  static Future<List<ConnectivityResult>> getCurrentConnectivity() async {
    return await Connectivity().checkConnectivity();
  }

  static String getConnectivityTypeString(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Dados Móveis';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.none:
        return 'Sem Conexão';
      case ConnectivityResult.other:
        return 'Outro';
      case ConnectivityResult.vpn:
        return 'VPN';
    }
  }
}
