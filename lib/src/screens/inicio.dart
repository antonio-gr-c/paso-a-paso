import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/barra_navegacion_inferior.dart';
import '../providers/proveedor_navegacion.dart';

import 'registro_diario.dart';
import 'recorrido.dart';
import 'historial.dart';
import 'perfil.dart';
import 'login.dart';
import 'registro.dart';

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
      Future.microtask(() {
        Provider.of<ProveedorNavegacion>(context, listen: false).cambiarPantalla(4);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<ProveedorNavegacion>(context);
    final indiceActual = nav.indiceActual;

    final pantallas = [
      const RegistroDiario(),
      const Recorrido(),
      const Historial(),
      const Perfil(),
      const Login(),    // índice 4
      const Registro(), // índice 5
 
    ];

    final mostrarNav = indiceActual < 4;

    return Scaffold(
      body: GestureDetector(
        // 1. Gesture para swipe horizontal
        onHorizontalDragEnd: (details) {
  if (details.primaryVelocity != null) {
    if (details.primaryVelocity! < 0) {
      // Swipe left => siguiente índice si está entre [0..2]
      if (indiceActual < 3) nav.cambiarPantalla(indiceActual + 1);
    } else if (details.primaryVelocity! > 0) {
      // Swipe right => índice anterior si está entre [1..3]
      if (indiceActual > 0 && indiceActual < 4) {
        nav.cambiarPantalla(indiceActual - 1);
      }
    }
  }
},

// En lugar de onDoubleTap, usamos onLongPress
onLongPress: () {
  if (indiceActual < 4) {
    nav.cambiarPantalla(3); // Ir a perfil
  }
},


        // El contenido real: la pantalla en curso
        child: pantallas[indiceActual],
      ),

      bottomNavigationBar: mostrarNav ? const BarraNavegacionInferior() : null,
    );
  }
}
