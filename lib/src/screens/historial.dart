import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/proveedor_autenticacion.dart';

class Historial extends StatefulWidget {
  const Historial({super.key});

  @override
  State<Historial> createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  List<Map<String, dynamic>> registros = [];
  bool cargando = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    obtenerRegistros();
  }

  Future<void> obtenerRegistros() async {
    final idPerfil = Provider.of<ProveedorAutenticacion>(context, listen: false).idPerfil;

    try {
      final url = Uri.parse('https://back-pap.onrender.com/registros/$idPerfil');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          registros = List<Map<String, dynamic>>.from(data['registros']);
          cargando = false;
        });
      } else {
        throw Exception('Error al obtener registros');
      }
    } catch (e) {
      setState(() {
        error = 'Error al obtener registros: $e';
        cargando = false;
      });
    }
  }

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
                  'Detalles del registro',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Text('Estado de ánimo: ${registro['animo']}'),
              const SizedBox(height: 10),
              Text('Hábitos:'),
              Text('- Agua: ${registro['agua'] ? "✅" : "❌"}'),
              Text('- Sueño: ${registro['dormir'] ? "✅" : "❌"}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        centerTitle: true,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : ListView.builder(
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
                          registro['animo'] ?? '🙂',
                          style: const TextStyle(fontSize: 30),
                        ),
                        title: Text(
                          'Registro #${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(registro['notas'] ?? 'Sin notas'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => mostrarDetalles(context, registro),
                      ),
                    );
                  },
                ),
    );
  }
}
