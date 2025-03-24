import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/proveedor_navegacion.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

 Future<void> cerrarSesion(BuildContext context) async {
  await Supabase.instance.client.auth.signOut();

  // Esperamos un breve momento para asegurarnos que se borre bien la sesión
  await Future.delayed(const Duration(milliseconds: 300));

  // Confirmamos que el usuario está realmente fuera
  final usuario = Supabase.instance.client.auth.currentUser;
  print('Usuario después de signOut: $usuario'); // debe ser null

  // Regresamos al login
  Provider.of<ProveedorNavegacion>(context, listen: false).cambiarPantalla(4);
}


  @override
  Widget build(BuildContext context) {
    // Datos simulados
    const String nombre = 'Tadeo';
    const String fotoPerfil =
        'https://identidadydesarrollo.com/wp-content/uploads/2017/10/Idyd_Roberto-Dupuis-600.png'; // Imagen temporal de ejemplo

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(fotoPerfil),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              nombre,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: null, // Aquí irá la funcionalidad de la cámara
              icon: const Icon(Icons.camera_alt),
              label: const Text('Cambiar foto de perfil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 40),

            // Botón funcional de cerrar sesión
            OutlinedButton.icon(
              onPressed: () => cerrarSesion(context),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
