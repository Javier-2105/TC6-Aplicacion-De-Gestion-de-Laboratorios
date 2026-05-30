//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';

// Pintor personalizado para crear un logotipo tecnológico de LabControl
class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Crear un degradado futurista para el fondo del logotipo
    final rect = Offset.zero & size;
    paint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0F2027),
        Color(0xFF203A43),
        Color(0xFF2C5364),
      ],
    ).createShader(rect);

    // Dibujar el escudo de fondo
    final pathFondo = Path();
    pathFondo.moveTo(size.width * 0.1, size.height * 0.1);
    pathFondo.lineTo(size.width * 0.9, size.height * 0.1);
    pathFondo.lineTo(size.width * 0.9, size.height * 0.6);
    pathFondo.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.95,
      size.width * 0.1,
      size.height * 0.6,
    );
    pathFondo.close();
    canvas.drawPath(pathFondo, paint);

    // Dibujar la pantalla del monitor
    final paintMonitor = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF00B4DB),
          Color(0xFF0083B0),
        ],
      ).createShader(rect);

    final double monitorW = size.width * 0.55;
    final double monitorH = size.height * 0.35;
    final double monitorX = (size.width - monitorW) / 2;
    final double monitorY = size.height * 0.22;

    final RRect monitorRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(monitorX, monitorY, monitorW, monitorH),
      const Radius.circular(8.0),
    );
    canvas.drawRRect(monitorRect, paintMonitor);

    // Dibujar base del monitor
    final paintBase = Paint()
      ..color = const Color(0xFFECEFF1)
      ..style = PaintingStyle.fill;

    final pathBase = Path();
    pathBase.moveTo(size.width * 0.43, monitorY + monitorH);
    pathBase.lineTo(size.width * 0.57, monitorY + monitorH);
    pathBase.lineTo(size.width * 0.62, monitorY + monitorH + size.height * 0.12);
    pathBase.lineTo(size.width * 0.38, monitorY + monitorH + size.height * 0.12);
    pathBase.close();
    canvas.drawPath(pathBase, paintBase);

    // Dibujar el brillo de la pantalla
    final paintBrillo = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final pathBrillo = Path();
    pathBrillo.moveTo(monitorX, monitorY);
    pathBrillo.lineTo(monitorX + monitorW, monitorY);
    pathBrillo.lineTo(monitorX + monitorW, monitorY + 12);
    pathBrillo.lineTo(monitorX, monitorY + monitorH * 0.7);
    pathBrillo.close();
    canvas.drawPath(pathBrillo, paintBrillo);

    // Dibujar ondas de red/control que salen del monitor
    final paintOnda = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = const Color(0xFF00FF87);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.5, monitorY + monitorH * 0.5), radius: size.width * 0.33),
      -2.7,
      2.3,
      false,
      paintOnda,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.5, monitorY + monitorH * 0.5), radius: size.width * 0.38),
      -2.8,
      2.5,
      false,
      paintOnda..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
