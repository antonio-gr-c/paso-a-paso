import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ProveedorPerfil with ChangeNotifier {
  Uint8List? _bytesImagen; // Aquí guardamos los bytes de la imagen en memoria
  File? _archivoImagen;    // Archivo físico en almacenamiento

  Uint8List? get bytesImagen => _bytesImagen;
  File? get archivoImagen => _archivoImagen;

  ProveedorPerfil() {
    _cargarImagenLocal();
  }

  Future<void> _cargarImagenLocal() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/foto_perfil.png');
    if (await file.exists()) {
      // Leemos bytes del archivo
      final bytes = await file.readAsBytes();
      _bytesImagen = bytes;
      _archivoImagen = file;
      notifyListeners();
    }
  }

  Future<void> seleccionarImagen(BuildContext context) async {
    // Pedir permisos
    final permisoCamara = await Permission.camera.request();
    final permisoGaleria = await Permission.photos.request();

    if (!permisoCamara.isGranted && !permisoGaleria.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permisos denegados para cámara o galería')),
      );
      return;
    }

    // Fuente: cámara o galería
    final fuente = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Tomar foto'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Elegir de galería'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (fuente == null) return;

    // Tomar o elegir la foto
    final picker = ImagePicker();
    final imagen = await picker.pickImage(source: fuente, imageQuality: 80);

    if (imagen != null) {
      // Guardar archivo físico
      final dir = await getApplicationDocumentsDirectory();
      final destino = File('${dir.path}/foto_perfil.png');
      await File(imagen.path).copy(destino.path);

      // Leer bytes inmediatamente
      final bytes = await destino.readAsBytes();

      // Actualizar estado en memoria
      _bytesImagen = bytes;
      _archivoImagen = destino;

      notifyListeners();
    }
  }
}
