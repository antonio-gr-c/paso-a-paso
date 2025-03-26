import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'proveedor_navegacion.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProveedorAutenticacion with ChangeNotifier {
  String correo = '';
  String contrasena = '';
  String nombre = '';
  String telefono = '';
  bool cargando = false;
  String error = '';
  bool registroExitoso = false;
  String idPerfil = '';


  // Métodos para actualizar correo y contraseña
  void actualizarCorreo(String valor) {
    correo = valor;
    notifyListeners();
  }

  void actualizarContrasena(String valor) {
    contrasena = valor;
    notifyListeners();
  }

  // Métodos nuevos para actualizar nombre y teléfono
  void actualizarNombre(String valor) {
    nombre = valor;
    notifyListeners();
  }

  void actualizarTelefono(String valor) {
    telefono = valor;
    notifyListeners();
  }

  Future<void> login(ProveedorNavegacion nav) async {
  cargando = true;
  error = '';
  notifyListeners();

  try {
    final res = await Supabase.instance.client.auth.signInWithPassword(
      email: correo.trim(),
      password: contrasena,
    );

    if (res.user != null) {
      // Obtener datos del perfil desde tu backend
      final url = Uri.parse('https://back-pap.onrender.com/perfil/${correo.trim()}');
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final json = jsonDecode(respuesta.body);

        nombre = json['perfil']['nombre'] ?? '';
        telefono = json['perfil']['telefono'].toString();
        idPerfil = json['perfil']['id_perfil'].toString();

        
      } else {
        error = 'No se pudo obtener perfil del usuario';
      }

      nav.irAInicio();
    }
  } catch (e) {
    error = 'Error al iniciar sesión: $e';
  }

  cargando = false;
  notifyListeners();
}
}