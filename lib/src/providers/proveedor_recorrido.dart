import 'dart:math' show sin, cos, sqrt, atan2;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ProveedorRecorrido with ChangeNotifier {
  double? _latInicial;
  double? _lonInicial;
  double? _latFinal;
  double? _lonFinal;
  bool _enRecorrido = false;

  bool get enRecorrido => _enRecorrido;

  double? get latInicial => _latInicial;
  double? get lonInicial => _lonInicial;
  double? get latFinal => _latFinal;
  double? get lonFinal => _lonFinal;

  Future<void> iniciarRecorrido() async {
    _latInicial = null;
    _lonInicial = null;
    _latFinal = null;
    _lonFinal = null;
    _enRecorrido = true;
    notifyListeners();

    // Verifica permisos
    await _verificarPermisosGPS();

    // Obtiene coords iniciales
    final pos = await Geolocator.getCurrentPosition();
    _latInicial = pos.latitude;
    _lonInicial = pos.longitude;
    notifyListeners();
  }

  Future<double> terminarRecorrido() async {
    if (!_enRecorrido) return 0.0;
    _enRecorrido = false;

    // Obtener coords finales
    final pos = await Geolocator.getCurrentPosition();
    _latFinal = pos.latitude;
    _lonFinal = pos.longitude;
    notifyListeners();

    // Calcular distancia
    double distancia = 0.0;
    if (_latInicial != null && _lonInicial != null && _latFinal != null && _lonFinal != null) {
      distancia = _calcularDistancia(
        _latInicial!, _lonInicial!,
        _latFinal!, _lonFinal!,
      );
    }
    return distancia;
  }

  Future<void> _verificarPermisosGPS() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      throw Exception('El servicio de ubicación está deshabilitado.');
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado.');
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
        'Permiso de ubicación denegado permanentemente. Revisa ajustes.',
      );
    }
  }

  double _calcularDistancia(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const radioTierra = 6371.0; // km
    final dLat = _gradosARadianes(lat2 - lat1);
    final dLon = _gradosARadianes(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_gradosARadianes(lat1)) *
            cos(_gradosARadianes(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radioTierra * c;
  }

  double _gradosARadianes(double deg) => deg * (3.141592653589793 / 180.0);
}
