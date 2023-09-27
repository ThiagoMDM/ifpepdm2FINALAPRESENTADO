import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'conf_project/util.dart';

class AppState extends ChangeNotifier {
  static AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  static void reset() {
    _instance = AppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<DocumentReference> _carrinho = [];
  List<DocumentReference> get carrinho => _carrinho;
  set carrinho(List<DocumentReference> _value) {
    _carrinho = _value;
  }

  void addToCarrinho(DocumentReference _value) {
    _carrinho.add(_value);
  }

  void removeFromCarrinho(DocumentReference _value) {
    _carrinho.remove(_value);
  }

  void removeAtIndexFromCarrinho(int _index) {
    _carrinho.removeAt(_index);
  }

  void updateCarrinhoAtIndex(
    int _index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    _carrinho[_index] = updateFn(_carrinho[_index]);
  }

  void insertAtIndexInCarrinho(int _index, DocumentReference _value) {
    _carrinho.insert(_index, _value);
  }

  double _somaCarrinho = 0.0;
  double get somaCarrinho => _somaCarrinho;
  set somaCarrinho(double _value) {
    _somaCarrinho = _value;
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
