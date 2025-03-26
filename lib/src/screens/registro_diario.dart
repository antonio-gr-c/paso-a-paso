import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/proveedor_autenticacion.dart';

class RegistroDiario extends StatefulWidget {
  const RegistroDiario({super.key});

  @override
  State<RegistroDiario> createState() => _RegistroDiarioState();
}

class _RegistroDiarioState extends State<RegistroDiario> {
  String animo = '';
  bool agua = false;
  bool dormir = false;
  bool ejercicio = false;
  final TextEditingController notasCtrl = TextEditingController();
  bool guardando = false;

  Future<void> guardarRegistro(BuildContext context) async {
    final prov = Provider.of<ProveedorAutenticacion>(context, listen: false);
    final idPerfil = prov.idPerfil;

    if (animo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona tu estado de ánimo')),
      );
      return;
    }

    setState(() => guardando = true);

    try {
      final url = Uri.parse('https://back-pap.onrender.com/registros');
      final respuesta = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'animo': animo,
          'agua': agua,
          'dormir': dormir,
          'ejercicio': ejercicio,
          'notas': notasCtrl.text,
          'id_perfil': idPerfil,
        }),
      );

      if (respuesta.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro guardado con éxito')),
        );
        setState(() {
          animo = '';
          agua = false;
          dormir = false;
          ejercicio = false;
          notasCtrl.clear();
        });
      } else {
        throw Exception('Error al guardar: ${respuesta.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => guardando = false);
  }

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
            const Text('¿Cómo te sientes hoy?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _emojiButton('😞'),
                _emojiButton('😐'),
                _emojiButton('🙂'),
                _emojiButton('😄'),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Hábitos de hoy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('Tomé suficiente agua'),
              value: agua,
              onChanged: (val) => setState(() => agua = val ?? false),
            ),
            CheckboxListTile(
              title: const Text('Dormí bien'),
              value: dormir,
              onChanged: (val) => setState(() => dormir = val ?? false),
            ),
            CheckboxListTile(
              title: const Text('Hice ejercicio'),
              value: ejercicio,
              onChanged: (val) => setState(() => ejercicio = val ?? false),
            ),
            const SizedBox(height: 20),
            const Text('Notas adicionales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: notasCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Escribe lo que desees...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: guardando ? null : () => guardarRegistro(context),
              child: guardando ? const CircularProgressIndicator() : const Text('Guardar registro'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emojiButton(String emoji) {
    final activo = animo == emoji;
    return GestureDetector(
      onTap: () => setState(() => animo = emoji),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: activo ? Colors.teal : Colors.grey, width: 2),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}
