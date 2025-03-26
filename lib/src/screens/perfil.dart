import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/proveedor_navegacion.dart';
import '../providers/proveedor_perfil.dart';
import '../providers/proveedor_autenticacion.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  Future<void> cerrarSesion(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    await Future.delayed(const Duration(milliseconds: 300));
    Provider.of<ProveedorNavegacion>(context, listen: false).cambiarPantalla(4);
  }

  @override
  Widget build(BuildContext context) {
    final perfilProv = context.watch<ProveedorPerfil>();
    final authProv = context.watch<ProveedorAutenticacion>();
    final bytes = perfilProv.bytesImagen;

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
              child: ClipOval(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: bytes != null
                      ? Image.memory(bytes, fit: BoxFit.cover)
                      : const Image(
                          image: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// MOSTRAR DATOS DEL PERFIL
            Text(
              authProv.nombre.isNotEmpty
                  ? authProv.nombre
                  : 'Tu perfil',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              authProv.telefono.isNotEmpty
                  ? 'Teléfono: ${authProv.telefono}'
                  : '',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => perfilProv.seleccionarImagen(context),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Cambiar foto de perfil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
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
