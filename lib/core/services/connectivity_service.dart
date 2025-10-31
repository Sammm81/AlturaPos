import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity service to monitor network status
class ConnectivityService {
  ConnectivityService(this._connectivity);

  final Connectivity _connectivity;
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _controller.stream;
  bool _isOnline = false;

  bool get isOnline => _isOnline;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity
    await _checkConnectivity();

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(results);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    _updateConnectivityStatus(results);
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;

    // Check if any result indicates connectivity
    _isOnline = results.any(
      (result) =>
          result != ConnectivityResult.none &&
          result != ConnectivityResult.bluetooth,
    );

    // Notify listeners if status changed
    if (wasOnline != _isOnline) {
      _controller.add(_isOnline);
    }
  }

  /// Check if connected to WiFi
  Future<bool> isConnectedToWiFi() async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
  }

  /// Check if connected to mobile data
  Future<bool> isConnectedToMobile() async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile);
  }

  /// Get current connectivity type
  Future<String> getConnectivityType() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return 'None';
    }
    if (results.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    }
    return 'Other';
  }

  void dispose() {
    _controller.close();
  }
}

/// Provider for connectivity service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService(Connectivity());
  service.initialize();
  ref.onDispose(service.dispose);
  return service;
});

/// Provider for connection status stream
final connectionStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectionStream;
});

/// Provider for current connection status
final isOnlineProvider = Provider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.isOnline;
});
