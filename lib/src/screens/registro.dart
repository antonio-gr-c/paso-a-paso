import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/proveedor_navegacion.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool cargando = false;
  bool registroExitoso = false;

  Future<void> registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => cargando = true);

    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: _correoCtrl.text.trim(),
        password: _contrasenaCtrl.text,
      );

      if (res.user != null) {
        setState(() {
          registroExitoso = true;
        });

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
      mostrarError('Error al registrar: ${e.toString()}');
    }

    setState(() => cargando = false);
  }

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
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
                    'Se ha enviado un correo de verificación.\nPor favor revisa tu bandeja y confirma tu cuenta antes de iniciar sesión.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<ProveedorNavegacion>(context, listen: false)
                          .cambiarPantalla(4); // Ir a login
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Ir a iniciar sesión'),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _correoCtrl,
                      decoration: const InputDecoration(labelText: 'Correo electrónico'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (valor) =>
                          valor != null && valor.contains('@') ? null : 'Correo inválido',
                    ),
                    TextFormField(
                      controller: _contrasenaCtrl,
                      decoration: const InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
                      validator: (valor) =>
                          valor != null && valor.length >= 6 ? null : 'Mínimo 6 caracteres',
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
