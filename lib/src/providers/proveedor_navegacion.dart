import 'package:flutter/material.dart';

class ProveedorNavegacion with ChangeNotifier {
  int _indiceActual = 4; // Pantalla inicial: login
  int get indiceActual => _indiceActual;

  void cambiarPantalla(int nuevoIndice) {
    _indiceActual = nuevoIndice;
    notifyListeners();
  }

  void irALogin() => cambiarPantalla(4);
  void irARegistro() => cambiarPantalla(5);
  void irAInicio() => cambiarPantalla(0);
  

}
