import 'package:flutter/material.dart';
import 'package:paso_a_paso/src/providers/proveedor_autenticacion.dart';
import 'package:paso_a_paso/src/providers/proveedor_recorrido.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:paso_a_paso/src/screens/inicio.dart';
import 'package:paso_a_paso/src/providers/proveedor_navegacion.dart';
import 'package:paso_a_paso/src/providers/proveedor_perfil.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProveedorNavegacion()),
        ChangeNotifierProvider(create: (_) => ProveedorPerfil()),
         ChangeNotifierProvider(create: (_) => ProveedorRecorrido()),
         ChangeNotifierProvider(create: (_) => ProveedorAutenticacion()),
      ],
      child: const AplicacionPasoAPaso(),
    ),
  );
}



class AplicacionPasoAPaso extends StatelessWidget {
  const AplicacionPasoAPaso({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paso a Paso',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0057B7),
        scaffoldBackgroundColor: const Color(0xFFFFFDE7),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003F87),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0xFF002F6C),
            fontFamily: 'Arial',
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC700),
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const Inicio(),
    );
  }
}
