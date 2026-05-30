//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../data/models/computadora.dart';
import '../data/models/inventario.dart';
import '../data/models/reserva.dart';
import '../data/models/reporte_falla.dart';
import '../data/models/mantenimiento.dart';
import '../data/models/software.dart';

// Proveedor de estado principal para la gestión del laboratorio
class LabProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();

  List<Computadora> _computadoras = [];
  List<Inventario> _inventario = [];
  List<Reserva> _reservas = [];
  List<ReporteFalla> _reportesFallas = [];
  List<Mantenimiento> _mantenimientos = [];
  List<Software> _software = [];

  // Mapeo para almacenar el software instalado por computadora
  final Map<int, List<Software>> _softwarePorComputadora = {};

  bool _estaCargando = false;

  // Getters para las listas
  List<Computadora> get computadoras => _computadoras;
  List<Inventario> get inventario => _inventario;
  List<Reserva> get reservas => _reservas;
  List<ReporteFalla> get reportesFallas => _reportesFallas;
  List<Mantenimiento> get mantenimientos => _mantenimientos;
  List<Software> get software => _software;
  bool get estaCargando => _estaCargando;

  // Obtener software de una computadora específica de forma síncrona desde caché
  List<Software> obtenerSoftwareInstalado(int computadoraId) {
    return _softwarePorComputadora[computadoraId] ?? [];
  }

  // Cargar todos los datos desde SQLite al iniciar o refrescar
  Future<void> cargarDatos() async {
    _estaCargando = true;
    notifyListeners();

    try {
      await _cargarComputadoras();
      await _cargarInventario();
      await _cargarReservas();
      await _cargarReportesFallas();
      await _cargarMantenimientos();
      await _cargarSoftware();
      await _cargarRelacionesSoftware();
    } catch (e) {
      // Manejar error silenciosamente
    }

    _estaCargando = false;
    notifyListeners();
  }

  // Métodos de carga internos
  Future<void> _cargarComputadoras() async {
    final list = await _dbHelper.obtenerComputadoras();
    _computadoras = list.map((item) => Computadora.fromMap(item)).toList();
  }

  Future<void> _cargarInventario() async {
    final list = await _dbHelper.obtenerInventario();
    _inventario = list.map((item) => Inventario.fromMap(item)).toList();
  }

  Future<void> _cargarReservas() async {
    final list = await _dbHelper.obtenerReservas();
    _reservas = list.map((item) => Reserva.fromMap(item)).toList();
  }

  Future<void> _cargarReportesFallas() async {
    final list = await _dbHelper.obtenerReportesFallas();
    _reportesFallas = list.map((item) => ReporteFalla.fromMap(item)).toList();
  }

  Future<void> _cargarMantenimientos() async {
    final list = await _dbHelper.obtenerMantenimientos();
    _mantenimientos = list.map((item) => Mantenimiento.fromMap(item)).toList();
  }

  Future<void> _cargarSoftware() async {
    final list = await _dbHelper.obtenerSoftware();
    _software = list.map((item) => Software.fromMap(item)).toList();
  }

  Future<void> _cargarRelacionesSoftware() async {
    _softwarePorComputadora.clear();
    for (var pc in _computadoras) {
      if (pc.id != null) {
        final list = await _dbHelper.obtenerSoftwarePorComputadora(pc.id!);
        _softwarePorComputadora[pc.id!] = list.map((item) => Software.fromMap(item)).toList();
      }
    }
  }

  // OPERACIONES CRUD: COMPUTADORAS
  Future<bool> agregarComputadora(Computadora pc) async {
    try {
      await _dbHelper.agregarComputadora(pc.toMap());
      await _cargarComputadoras();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarComputadora(Computadora pc) async {
    try {
      await _dbHelper.actualizarComputadora(pc.toMap());
      await _cargarComputadoras();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarComputadora(int id) async {
    try {
      await _dbHelper.eliminarComputadora(id);
      await _cargarComputadoras();
      await _cargarRelacionesSoftware();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // OPERACIONES CRUD: INVENTARIO
  Future<bool> agregarInventario(Inventario item) async {
    try {
      await _dbHelper.agregarInventario(item.toMap());
      await _cargarInventario();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarInventario(Inventario item) async {
    try {
      await _dbHelper.actualizarInventario(item.toMap());
      await _cargarInventario();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarInventario(int id) async {
    try {
      await _dbHelper.eliminarInventario(id);
      await _cargarInventario();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // OPERACIONES CRUD: RESERVAS Y CONFLICTOS
  Future<bool> agregarReserva(Reserva res) async {
    final conflicto = await _dbHelper.existeConflictoReserva(res.fecha, res.horario, res.laboratorio);
    if (conflicto) return false; // Conflicto de horario detectado

    try {
      await _dbHelper.agregarReserva(res.toMap());
      await _cargarReservas();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarReserva(Reserva res) async {
    final conflicto = await _dbHelper.existeConflictoReserva(res.fecha, res.horario, res.laboratorio, excluirId: res.id);
    if (conflicto) return false;

    try {
      await _dbHelper.actualizarReserva(res.toMap());
      await _cargarReservas();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarReserva(int id) async {
    try {
      await _dbHelper.eliminarReserva(id);
      await _cargarReservas();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // OPERACIONES CRUD: REPORTES DE FALLAS
  Future<bool> agregarReporteFalla(ReporteFalla reporte) async {
    try {
      await _dbHelper.agregarReporteFalla(reporte.toMap());
      await _cargarReportesFallas();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarReporteFalla(ReporteFalla reporte) async {
    try {
      await _dbHelper.actualizarReporteFalla(reporte.toMap());
      await _cargarReportesFallas();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarReporteFalla(int id) async {
    try {
      await _dbHelper.eliminarReporteFalla(id);
      await _cargarReportesFallas();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // OPERACIONES CRUD: MANTENIMIENTOS
  Future<bool> agregarMantenimiento(Mantenimiento m) async {
    try {
      await _dbHelper.agregarMantenimiento(m.toMap());
      await _cargarMantenimientos();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarMantenimiento(Mantenimiento m) async {
    try {
      await _dbHelper.actualizarMantenimiento(m.toMap());
      await _cargarMantenimientos();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarMantenimiento(int id) async {
    try {
      await _dbHelper.eliminarMantenimiento(id);
      await _cargarMantenimientos();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // OPERACIONES CRUD: SOFTWARE
  Future<bool> agregarSoftware(Software sw) async {
    try {
      await _dbHelper.agregarSoftware(sw.toMap());
      await _cargarSoftware();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarSoftware(Software sw) async {
    try {
      await _dbHelper.actualizarSoftware(sw.toMap());
      await _cargarSoftware();
      await _cargarRelacionesSoftware(); // Refrescar en las PCs instaladas
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarSoftware(int id) async {
    try {
      await _dbHelper.eliminarSoftware(id);
      await _cargarSoftware();
      await _cargarRelacionesSoftware();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // RELACIÓN COMPUTADORA - SOFTWARE
  Future<bool> instalarSoftware(int computadoraId, int softwareId) async {
    try {
      await _dbHelper.instalarSoftwareEnComputadora(computadoraId, softwareId);
      final list = await _dbHelper.obtenerSoftwarePorComputadora(computadoraId);
      _softwarePorComputadora[computadoraId] = list.map((item) => Software.fromMap(item)).toList();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> desinstalarSoftware(int computadoraId, int softwareId) async {
    try {
      await _dbHelper.desinstalarSoftwareDeComputadora(computadoraId, softwareId);
      final list = await _dbHelper.obtenerSoftwarePorComputadora(computadoraId);
      _softwarePorComputadora[computadoraId] = list.map((item) => Software.fromMap(item)).toList();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
