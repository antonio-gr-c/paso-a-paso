import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/proveedor_navegacion.dart';

class BarraNavegacionInferior extends StatelessWidget {
  const BarraNavegacionInferior({super.key});

  @override
  Widget build(BuildContext context) {
    final proveedor = Provider.of<ProveedorNavegacion>(context);
    return BottomNavigationBar(
      currentIndex: proveedor.indiceActual,
      onTap: (indice) => proveedor.cambiarPantalla(indice),
      selectedItemColor: Colors.teal[800],
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.self_improvement),
          label: 'Registro',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_walk),
          label: 'Recorrido',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Historial',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
