import 'package:connectivity_plus/connectivity_plus.dart';

/// Network info helper to check connectivity
class NetworkInfo {
  NetworkInfo(this._connectivity);

  final Connectivity _connectivity;

  /// Check if device has internet connection
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.any(
      (result) =>
          result != ConnectivityResult.none &&
          result != ConnectivityResult.bluetooth,
    );
  }

  /// Check if connected to WiFi
  Future<bool> get isWiFi async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
  }

  /// Check if connected to mobile data
  Future<bool> get isMobile async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile);
  }
}
