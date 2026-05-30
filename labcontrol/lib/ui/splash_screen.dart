//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'widgets/logo_painter.dart';

// Pantalla de bienvenida con animación y validación de sesión
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Configurar animaciones
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
    _iniciarNavegacion();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Verificar sesión y navegar después del retraso
  Future<void> _iniciarNavegacion() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Esperar al menos 3 segundos de animación
    await Future.delayed(const Duration(seconds: 3));
    
    // Validar si la sesión sigue activa localmente
    final sesionActiva = await authProvider.verificarSesionActiva();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
            sesionActiva ? const DashboardScreen() : const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              
              // Animación del logotipo central
              ScaleTransition(
                scale: _scaleAnimation,
                child: CustomPaint(
                  size: Size(size.width * 0.45, size.width * 0.45),
                  painter: LogoPainter(),
                ),
              ),
              const SizedBox(height: 30),
              
              // Nombre de la App
              const Text(
                'LabControl',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      color: Color(0xFF00FF87),
                      blurRadius: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              
              // Eslogan técnico
              Text(
                'Gestión Inteligente de Laboratorio',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  letterSpacing: 1.0,
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Indicador de carga futurista
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00FF87)),
                strokeWidth: 3,
              ),
              
              const SizedBox(height: 40),
              
              // Información Académica y del Desarrollador
              Text(
                'Desarrollador:',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Rodolfo Javier Platas Molina',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'TC6 • 23328061310458',
                style: TextStyle(
                  color: const Color(0xFF00B4DB).withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
