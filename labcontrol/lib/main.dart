//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/lab_provider.dart';
import 'ui/splash_screen.dart';

// Función principal de la aplicación
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LabControlApp());
}

// Clase principal que inicializa temas y proveedores de estado
class LabControlApp extends StatelessWidget {
  const LabControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LabProvider()),
      ],
      child: MaterialApp(
        title: 'LabControl',
        debugShowCheckedModeBanner: false,
        
        // Configuración de un tema tecnológico y premium consistente en toda la aplicación
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF00FF87),
          scaffoldBackgroundColor: const Color(0xFF0F2027),
          
          // Estilo de Tipografía usando Google Fonts
          textTheme: GoogleFonts.outfitTextTheme(
            ThemeData.dark().textTheme,
          ),
          
          // Configuración personalizada de los campos de texto
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            labelStyle: const TextStyle(color: Colors.white70),
            floatingLabelStyle: const TextStyle(color: Color(0xFF00FF87)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Color(0xFF00FF87), width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
            ),
          ),
          
          // Estilo general para diálogos de alerta
          dialogTheme: const DialogThemeData(
            backgroundColor: Color(0xFF162A35),
            surfaceTintColor: Colors.transparent,
          ),
        ),
        
        // Página de inicio definida en la pantalla de carga Splash
        home: const SplashScreen(),
      ),
    );
  }
}
