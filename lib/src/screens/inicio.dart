import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/barra_navegacion_inferior.dart';
import '../providers/proveedor_navegacion.dart';

import 'registro_diario.dart';
import 'recorrido.dart';
import 'historial.dart';
import 'perfil.dart';
import 'login.dart'; // 👈 nuevo import
import 'registro.dart'; // 👈 nuevo import

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  void initState() {
    super.initState();
    verificarSesion();
  }

  void verificarSesion() {
    final usuario = Supabase.instance.client.auth.currentUser;

    if (usuario == null) {
      // Si no hay usuario logueado, vamos a la pantalla de login (índice 4)
      Future.microtask(() {
        Provider.of<ProveedorNavegacion>(context, listen: false)
            .cambiarPantalla(4);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final indiceActual = Provider.of<ProveedorNavegacion>(context).indiceActual;

    final pantallas = [
      const RegistroDiario(),
      const Recorrido(),
      const Historial(),
      const Perfil(),
      const Login(),    // índice 4
      const Registro(), // índice 5
    ];

    // Nota: No mostramos la barra de navegación si estamos en login o registro
    final mostrarNav = indiceActual < 4;

    return Scaffold(
      body: pantallas[indiceActual],
      bottomNavigationBar: mostrarNav ? const BarraNavegacionInferior() : null,
    );
  }
}
