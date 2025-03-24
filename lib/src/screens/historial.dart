import 'package:flutter/material.dart';

class Historial extends StatelessWidget {
  const Historial({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista simulada de registros
    final List<Map<String, dynamic>> registros = [
      {
        'fecha': '2025-03-23',
        'animo': '🙂',
        'distancia': 1.2,
        'agua': true,
        'sueno': true,
        'ejercicio': false,
        'notas': 'Me sentí tranquilo, pero un poco cansado.',
      },
      {
        'fecha': '2025-03-22',
        'animo': '😄',
        'distancia': 2.8,
        'agua': true,
        'sueno': true,
        'ejercicio': true,
        'notas': 'Día excelente, mucha energía.',
      },
      {
        'fecha': '2025-03-21',
        'animo': '😐',
        'distancia': 0.0,
        'agua': false,
        'sueno': false,
        'ejercicio': false,
        'notas': 'No tuve ganas de hacer nada.',
      },
    ];

    void mostrarDetalles(BuildContext context, Map<String, dynamic> registro) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        isScrollControlled: true,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Detalles del ${registro['fecha']}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Estado de ánimo: ${registro['animo']}'),
                Text('Distancia recorrida: ${registro['distancia']} km'),
                const SizedBox(height: 10),
                Text('Hábitos:'),
                Text('- Agua: ${registro['agua'] ? "✅" : "❌"}'),
                Text('- Sueño: ${registro['sueno'] ? "✅" : "❌"}'),
                Text('- Ejercicio: ${registro['ejercicio'] ? "✅" : "❌"}'),
                const SizedBox(height: 10),
                const Text('Notas:'),
                Text(registro['notas'] ?? 'Sin notas'),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: registros.length,
        itemBuilder: (context, index) {
          final registro = registros[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Text(
                registro['animo'],
                style: const TextStyle(fontSize: 30),
              ),
              title: Text(
                'Fecha: ${registro['fecha']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Distancia: ${registro['distancia']} km'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => mostrarDetalles(context, registro),
            ),
          );
        },
      ),
    );
  }
}
