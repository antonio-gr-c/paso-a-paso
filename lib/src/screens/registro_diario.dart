import 'package:flutter/material.dart';

class RegistroDiario extends StatelessWidget {
  const RegistroDiario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Diario'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              '¿Cómo te sientes hoy?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Emojis o botones para estado de ánimo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('😞', style: TextStyle(fontSize: 30)),
                Text('😐', style: TextStyle(fontSize: 30)),
                Text('🙂', style: TextStyle(fontSize: 30)),
                Text('😄', style: TextStyle(fontSize: 30)),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Hábitos de hoy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Checkboxes de hábitos
            CheckboxListTile(
              title: const Text('Tomé suficiente agua'),
              value: false,
              onChanged: null, // funcionalidad después
            ),
            CheckboxListTile(
              title: const Text('Dormí bien'),
              value: false,
              onChanged: null,
            ),
            CheckboxListTile(
              title: const Text('Hice ejercicio'),
              value: false,
              onChanged: null,
            ),
            const SizedBox(height: 20),
            const Text(
              'Notas adicionales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Escribe lo que desees...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              enabled: false, // solo front por ahora
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: null, // funcionalidad después
              child: const Text('Guardar registro'),
            ),
          ],
        ),
      ),
    );
  }
}
