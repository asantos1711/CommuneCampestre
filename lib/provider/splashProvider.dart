import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  setLoad(bool status) {
    _loading = status;
    notifyListeners();
  }
}

class CuentasAsociadoProvider with ChangeNotifier {
  bool isMinorAndEqual = false;
  bool get getIsMinorAndEqual => isMinorAndEqual;
  setLoad(bool status) {
    isMinorAndEqual = status;
    notifyListeners();
  }
}
