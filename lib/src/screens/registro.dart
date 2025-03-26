import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

import '../providers/proveedor_navegacion.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();

  bool cargando = false;
  bool registroExitoso = false;

  Future<void> registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => cargando = true);

    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: _correoCtrl.text.trim(),
        password: _contrasenaCtrl.text,
        data: {
          'nombre': _nombreCtrl.text.trim(),
          'telefono': _telefonoCtrl.text.trim(),
        },
      );

      if (res.user != null) {
        // Registro exitoso en Auth, ahora insertamos en la tabla perfiles:
        await guardarEnPerfiles(
          idUsuario: res.user!.id,
          nombre: _nombreCtrl.text.trim(),
          correo: _correoCtrl.text.trim(),
          telefono: _telefonoCtrl.text.trim(),
        );

        setState(() => registroExitoso = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Se ha enviado un correo de verificación. Por favor confírmalo antes de iniciar sesión.',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 6),
          ),
        );
      }
    } catch (e) {
      mostrarError('Error al registrar: $e');
    }

    setState(() => cargando = false);
  }

  Future<void> guardarEnPerfiles({
    required String idUsuario,
    required String nombre,
    required String correo,
    required String telefono,
  }) async {
    final url = Uri.parse('https://back-pap.onrender.com/perfiles');
    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_usuario': idUsuario,
        'nombre': nombre,
        'correo': correo,
        'telefono': int.tryParse(telefono),
      }),
    );

    if (respuesta.statusCode != 201) {
      throw Exception('Error al guardar perfil: ${respuesta.body}');
    }
  }

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: registroExitoso
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '¡Registro exitoso!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Se ha enviado un correo de verificación.\n'
                    'Por favor revisa tu bandeja y confirma tu cuenta antes de iniciar sesión.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<ProveedorNavegacion>(context, listen: false)
                          .cambiarPantalla(4);
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Ir a iniciar sesión'),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nombreCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre completo'),
                      validator: (valor) => valor != null && valor.isNotEmpty
                          ? null
                          : 'Ingresa tu nombre',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telefonoCtrl,
                      decoration: const InputDecoration(labelText: 'Teléfono'),
                      keyboardType: TextInputType.phone,
                      validator: (valor) => valor != null && valor.length >= 7
                          ? null
                          : 'Ingresa un teléfono válido',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _correoCtrl,
                      decoration: const InputDecoration(labelText: 'Correo electrónico'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (valor) =>
                          valor != null && valor.contains('@') ? null : 'Correo inválido',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contrasenaCtrl,
                      decoration: const InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
                      validator: (valor) => valor != null && valor.length >= 6
                          ? null
                          : 'Mínimo 6 caracteres',
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: cargando ? null : registrar,
                      child: cargando
                          ? const CircularProgressIndicator()
                          : const Text('Registrarse'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Provider.of<ProveedorNavegacion>(context, listen: false)
                            .cambiarPantalla(4); // Ir a login
                      },
                      child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
