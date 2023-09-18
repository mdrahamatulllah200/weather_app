import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class InternetConnection {
  static String? _connectionStatus;
  static final Connectivity _connectivity = Connectivity();

  factory InternetConnection() {
    return _singleton;
  }

  static final InternetConnection _singleton = InternetConnection._internal();

  InternetConnection._internal();

  static Future<void> initConnectivity() async {
    String connectionStatus;

    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      log('Cannot access initConnectivity: ', error: e.toString());
      connectionStatus = 'Internet connectivity failed';
    }

    _connectionStatus = connectionStatus;
  }

  static Future<bool> isConnectedToInternet() async {
    await initConnectivity();

    if (_connectionStatus == 'ConnectivityResult.mobile' ||
        _connectionStatus == 'ConnectivityResult.wifi') {
      return true;
    } else {
      return false;
    }
  }
}
