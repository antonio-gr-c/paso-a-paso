import 'package:flutter/material.dart';

class ProveedorNavegacion with ChangeNotifier {
  int _indiceActual = 0;

  int get indiceActual => _indiceActual;

  void cambiarPantalla(int nuevoIndice) {
    _indiceActual = nuevoIndice;
    notifyListeners();
  }
}
