import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:provider/provider.dart';

import '../providers/proveedor_recorrido.dart';

class Recorrido extends StatelessWidget {
  const Recorrido({super.key});

  @override
  Widget build(BuildContext context) {
    final recorridoProv = context.watch<ProveedorRecorrido>();

    final markers = <Marker>[];
    if (recorridoProv.latInicial != null && recorridoProv.lonInicial != null) {
      markers.add(
        Marker(
          point: latLng.LatLng(
            recorridoProv.latInicial!,
            recorridoProv.lonInicial!,
          ),
          child: const Icon(Icons.location_on, color: Colors.green, size: 40),
        ),
      );
    }
    if (recorridoProv.latFinal != null && recorridoProv.lonFinal != null) {
      markers.add(
        Marker(
          point: latLng.LatLng(
            recorridoProv.latFinal!,
            recorridoProv.lonFinal!,
          ),
          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      );
    }

    final centerLat = recorridoProv.latInicial ?? 0.0;
    final centerLon = recorridoProv.lonInicial ?? 0.0;
    final enRecorrido = recorridoProv.enRecorrido;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorrido con Mapa'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: latLng.LatLng(centerLat, centerLon),
                zoom: 14.0,
                 minZoom: 5.0, // Zoom mínimo
    maxZoom: 18.0, // Zoom máximo
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar'),
                  onPressed: enRecorrido
                      ? null
                      : () async {
                          try {
                            await recorridoProv.iniciarRecorrido();
                          } catch (e) {
                            _mostrarError(context, e.toString());
                          }
                        },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.stop),
                  label: const Text('Terminar'),
                  onPressed: enRecorrido
                      ? () async {
                          try {
                            final dist = await recorridoProv.terminarRecorrido();
                            _mostrarModalDistancia(context, dist);
                          } catch (e) {
                            _mostrarError(context, e.toString());
                          }
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _mostrarModalDistancia(BuildContext context, double distancia) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Distancia recorrida',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${distancia.toStringAsFixed(2)} km'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
}
