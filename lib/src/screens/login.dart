import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/proveedor_navegacion.dart';
import '../providers/proveedor_autenticacion.dart';


class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider para la navegación
    final nav = context.read<ProveedorNavegacion>();
    // Provider para la autenticación (login/registro)
    final auth = context.watch<ProveedorAutenticacion>();

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextFormField(
              initialValue: auth.correo,
              onChanged: auth.actualizarCorreo,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              initialValue: auth.contrasena,
              onChanged: auth.actualizarContrasena,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: auth.cargando
                  ? null
                  : () => auth.login(nav), // Pasamos nav para irAInicio()
              child: auth.cargando
                  ? const CircularProgressIndicator()
                  : const Text('Entrar'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: nav.irARegistro,
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
            if (auth.error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(auth.error, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
