import 'package:flutter/material.dart';
import 'dart:async';

class Recorrido extends StatefulWidget {
  const Recorrido({super.key});

  @override
  State<Recorrido> createState() => _RecorridoState();
}

class _RecorridoState extends State<Recorrido> {
  bool recorridoActivo = false;
  Duration duracion = Duration.zero;
  Timer? temporizador;

  void iniciarRecorrido() {
    setState(() {
      recorridoActivo = true;
      duracion = Duration.zero;
    });

    temporizador = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        duracion += const Duration(seconds: 1);
      });
    });
  }

  void terminarRecorrido() {
    temporizador?.cancel();
    setState(() {
      recorridoActivo = false;
    });

    // Aquí luego se podrá guardar coordenadas y tiempo
  }

  String formatearDuracion(Duration d) {
    String dosCifras(int n) => n.toString().padLeft(2, '0');
    return "${dosCifras(d.inHours)}:${dosCifras(d.inMinutes.remainder(60))}:${dosCifras(d.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorrido'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Estado del recorrido
            Text(
              recorridoActivo ? 'Recorrido en curso' : 'Recorrido detenido',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            
            // Temporizador centrado
            Center(
              child: Text(
                formatearDuracion(duracion),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: recorridoActivo ? null : iniciarRecorrido,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: recorridoActivo ? terminarRecorrido : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('Terminar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
