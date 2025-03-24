import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/proveedor_navegacion.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool cargando = false;

  Future<void> iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => cargando = true);

    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: _correoCtrl.text.trim(),
        password: _contrasenaCtrl.text,
      );

      if (res.user != null) {
        // Usuario autenticado correctamente
        Provider.of<ProveedorNavegacion>(context, listen: false).cambiarPantalla(0);
      }
    } catch (e) {
  mostrarError('Error al iniciar sesión: ${e.toString()}');
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
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
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
                onPressed: cargando ? null : iniciarSesion,
                child: cargando
                    ? const CircularProgressIndicator()
                    : const Text('Entrar'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Provider.of<ProveedorNavegacion>(context, listen: false)
                      .cambiarPantalla(5); // Ir a registro
                },
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
