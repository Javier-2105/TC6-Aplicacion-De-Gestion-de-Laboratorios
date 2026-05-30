//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/auth_provider.dart';
import '../providers/lab_provider.dart';
import '../services/pdf_service.dart';
import 'login_screen.dart';
import 'computadoras/computadoras_screen.dart';
import 'inventario/inventario_screen.dart';
import 'reservas/reservas_screen.dart';
import 'fallas/fallas_screen.dart';
import 'mantenimiento/mantenimiento_screen.dart';
import 'software/software_screen.dart';

// Pantalla principal del Dashboard administrativo de LabControl
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar datos locales desde SQLite al iniciar el panel
    Future.microtask(() =>
        Provider.of<LabProvider>(context, listen: false).cargarDatos());
  }

  // Cerrar sesión local
  void _cerrarSesion() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.cerrarSesion();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  // Descargar reportes PDF generales de forma local
  void _mostrarMenuReportes(BuildContext context, LabProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF162A35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Exportar Reporte Local (PDF)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _opcionReportePDF(
                titulo: 'Inventario Completo',
                icono: Icons.inventory_2_outlined,
                color: const Color(0xFF00FF87),
                onTap: () {
                  Navigator.pop(context);
                  PdfService.exportarInventario(provider.inventario);
                },
              ),
              _opcionReportePDF(
                titulo: 'Listado de Computadoras',
                icono: Icons.computer_outlined,
                color: const Color(0xFF00B4DB),
                onTap: () {
                  Navigator.pop(context);
                  PdfService.exportarComputadoras(provider.computadoras);
                },
              ),
              _opcionReportePDF(
                titulo: 'Reservas del Semestre',
                icono: Icons.calendar_month_outlined,
                color: Colors.purpleAccent,
                onTap: () {
                  Navigator.pop(context);
                  PdfService.exportarReservas(provider.reservas);
                },
              ),
              _opcionReportePDF(
                titulo: 'Historial de Fallas',
                icono: Icons.warning_amber_rounded,
                color: Colors.amberAccent,
                onTap: () {
                  Navigator.pop(context);
                  PdfService.exportarFallas(provider.reportesFallas);
                },
              ),
              _opcionReportePDF(
                titulo: 'Mantenimientos Aplicados',
                icono: Icons.build_circle_outlined,
                color: Colors.redAccent,
                onTap: () {
                  Navigator.pop(context);
                  PdfService.exportarMantenimientos(provider.mantenimientos);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _opcionReportePDF({
    required String titulo,
    required IconData icono,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icono, color: color),
      ),
      title: Text(
        titulo,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.download, color: Colors.white70),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final labProvider = Provider.of<LabProvider>(context);

    // Cálculos estadísticos
    final totalPCs = labProvider.computadoras.length;
    final disponibles = labProvider.computadoras.where((c) => c.estado == 'Disponible').length;
    final mantenimiento = labProvider.computadoras.where((c) => c.estado == 'Mantenimiento').length;
    final danadas = labProvider.computadoras.where((c) => c.estado == 'Dañada').length;
    final fueraServicio = labProvider.computadoras.where((c) => c.estado == 'Fuera de servicio').length;
    
    final totalReservas = labProvider.reservas.length;
    final reportesPendientes = labProvider.reportesFallas.where((r) => r.estado != 'Cerrado' && r.estado != 'Reparado').length;
    final mantenimientosActivos = labProvider.mantenimientos.where((m) => m.estado != 'Completado').length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text(
          'LabControl',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F2027),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFF00FF87)),
            tooltip: 'Exportar Reportes',
            onPressed: () => _mostrarMenuReportes(context, labProvider),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Cerrar Sesión',
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: labProvider.estaCargando
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00FF87)))
          : RefreshIndicator(
              onRefresh: () => labProvider.cargarDatos(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bienvenida del Usuario
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bienvenido,',
                                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
                              ),
                              Text(
                                authProvider.usuarioActual?.nombreCompleto ?? 'Administrador',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00B4DB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF00B4DB).withOpacity(0.3)),
                          ),
                          child: const Text(
                            'PREPARATORIA',
                            style: TextStyle(
                              color: Color(0xFF00B4DB),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Fila de Estadísticas Rápidas
                    const Text(
                      'Resumen del Estado actual',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double cardWidth = (constraints.maxWidth - 12) / 2;
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _tarjetaEstadistica(
                              ancho: cardWidth,
                              titulo: 'Total PCs',
                              valor: totalPCs.toString(),
                              icono: Icons.computer,
                              colorGradiente: [const Color(0xFF00B4DB), const Color(0xFF0083B0)],
                            ),
                            _tarjetaEstadistica(
                              ancho: cardWidth,
                              titulo: 'Disponibles',
                              valor: disponibles.toString(),
                              icono: Icons.check_circle_outline,
                              colorGradiente: [const Color(0xFF00FF87), const Color(0xFF60EFA0)],
                            ),
                            _tarjetaEstadistica(
                              ancho: cardWidth,
                              titulo: 'Reservas Activas',
                              valor: totalReservas.toString(),
                              icono: Icons.calendar_month,
                              colorGradiente: [Colors.purple, Colors.purpleAccent],
                            ),
                            _tarjetaEstadistica(
                              ancho: cardWidth,
                              titulo: 'Fallas Pendientes',
                              valor: reportesPendientes.toString(),
                              icono: Icons.warning_amber_rounded,
                              colorGradiente: [Colors.orange, Colors.orangeAccent],
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 25),

                    // Gráfico de uso de computadoras
                    if (totalPCs > 0) ...[
                      const Text(
                        'Distribución de Computadoras',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A3644),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 3,
                                  centerSpaceRadius: 40,
                                  sections: [
                                    PieChartSectionData(
                                      color: const Color(0xFF00FF87),
                                      value: disponibles.toDouble(),
                                      title: disponibles > 0 ? '$disponibles' : '',
                                      radius: 45,
                                      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    PieChartSectionData(
                                      color: Colors.amber,
                                      value: mantenimiento.toDouble(),
                                      title: mantenimiento > 0 ? '$mantenimiento' : '',
                                      radius: 45,
                                      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    PieChartSectionData(
                                      color: Colors.redAccent,
                                      value: danadas.toDouble(),
                                      title: danadas > 0 ? '$danadas' : '',
                                      radius: 45,
                                      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    PieChartSectionData(
                                      color: Colors.grey,
                                      value: fueraServicio.toDouble(),
                                      title: fueraServicio > 0 ? '$fueraServicio' : '',
                                      radius: 45,
                                      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _leyendaGrafico(const Color(0xFF00FF87), 'Disponibles'),
                                  const SizedBox(height: 8),
                                  _leyendaGrafico(Colors.amber, 'Mantenimiento'),
                                  const SizedBox(height: 8),
                                  _leyendaGrafico(Colors.redAccent, 'Dañadas'),
                                  const SizedBox(height: 8),
                                  _leyendaGrafico(Colors.grey, 'Fuera Servicio'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    // Menú de Secciones CRUD de Administración
                    const Text(
                      'Módulos del Sistema',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.15,
                      children: [
                        _moduloAdmin(
                          titulo: 'Computadoras',
                          descripcion: 'CRUD y Rejilla visual',
                          icono: Icons.computer,
                          color: const Color(0xFF00B4DB),
                          pantalla: const ComputadorasScreen(),
                        ),
                        _moduloAdmin(
                          titulo: 'Inventario',
                          descripcion: 'Equipos y periféricos',
                          icono: Icons.inventory_2_outlined,
                          color: const Color(0xFF00FF87),
                          pantalla: const InventarioScreen(),
                        ),
                        _moduloAdmin(
                          titulo: 'Reservas',
                          descripcion: 'Horarios y Agenda',
                          icono: Icons.calendar_month,
                          color: Colors.purpleAccent,
                          pantalla: const ReservasScreen(),
                        ),
                        _moduloAdmin(
                          titulo: 'Fallas',
                          descripcion: 'Reportes y Prioridades',
                          icono: Icons.warning_amber_rounded,
                          color: Colors.amberAccent,
                          pantalla: const FallasScreen(),
                        ),
                        _moduloAdmin(
                          titulo: 'Mantenimiento',
                          descripcion: 'Historial y Diagnósticos',
                          icono: Icons.build_circle_outlined,
                          color: Colors.redAccent,
                          pantalla: const MantenimientoScreen(),
                        ),
                        _moduloAdmin(
                          titulo: 'Catálogo Software',
                          descripcion: 'Programas instalados',
                          icono: Icons.apps,
                          color: Colors.cyanAccent,
                          pantalla: const SoftwareScreen(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                    // Pie de página académico obligatorio
                    Center(
                      child: Text(
                        'TC6 • Platas Molina Rodolfo Javier • 23328061310458',
                        style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }

  // Tarjeta de estadísticas con degradado de color
  Widget _tarjetaEstadistica({
    required double ancho,
    required String titulo,
    required String valor,
    required IconData icono,
    required List<Color> colorGradiente,
  }) {
    return Container(
      width: ancho,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colorGradiente,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorGradiente.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            valor,
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Leyendas del gráfico circular
  Widget _leyendaGrafico(Color color, String texto) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(texto, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }

  // Botón para ingresar a cada módulo CRUD
  Widget _moduloAdmin({
    required String titulo,
    required String descripcion,
    required IconData icono,
    required Color color,
    required Widget pantalla,
  }) {
    return Card(
      color: const Color(0xFF1E3C48),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => pantalla));
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                titulo,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                descripcion,
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
