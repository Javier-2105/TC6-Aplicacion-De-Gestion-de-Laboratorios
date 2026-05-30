//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Helper para administrar la base de datos local SQLite
class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos local
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'labcontrol.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Crear tablas e insertar datos iniciales de prueba
  Future<void> _onCreate(Database db, int version) async {
    // Tabla de Usuarios para autenticación local
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombreCompleto TEXT,
        email TEXT UNIQUE,
        contrasena TEXT
      )
    ''');

    // Tabla de Computadoras
    await db.execute('''
      CREATE TABLE computadoras(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numeroPc INTEGER UNIQUE,
        marca TEXT,
        modelo TEXT,
        procesador TEXT,
        memoriaRam TEXT,
        almacenamiento TEXT,
        sistemaOperativo TEXT,
        direccionIp TEXT,
        estado TEXT
      )
    ''');

    // Tabla de Inventario Tecnológico
    await db.execute('''
      CREATE TABLE inventario(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        cantidad INTEGER,
        categoria TEXT,
        estado TEXT,
        fechaAdquisicion TEXT,
        ubicacion TEXT
      )
    ''');

    // Tabla de Reservas de Laboratorio
    await db.execute('''
      CREATE TABLE reservas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profesor TEXT,
        grupo TEXT,
        materia TEXT,
        fecha TEXT,
        horario TEXT,
        laboratorio TEXT
      )
    ''');

    // Tabla de Reportes de Fallas
    await db.execute('''
      CREATE TABLE reportes_fallas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        computadoraId INTEGER,
        problema TEXT,
        descripcion TEXT,
        fecha TEXT,
        prioridad TEXT,
        estado TEXT
      )
    ''');

    // Tabla de Mantenimiento
    await db.execute('''
      CREATE TABLE mantenimientos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        equipo TEXT,
        fecha TEXT,
        problemaDetectado TEXT,
        diagnostico TEXT,
        solucionAplicada TEXT,
        costo REAL,
        estado TEXT
      )
    ''');

    // Tabla de Software catalogado
    await db.execute('''
      CREATE TABLE software(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        version TEXT,
        categoria TEXT
      )
    ''');

    // Tabla de relación muchos a muchos: Computadora - Software
    await db.execute('''
      CREATE TABLE computadora_software(
        computadoraId INTEGER,
        softwareId INTEGER,
        PRIMARY KEY (computadoraId, softwareId),
        FOREIGN KEY (computadoraId) REFERENCES computadoras(id) ON DELETE CASCADE,
        FOREIGN KEY (softwareId) REFERENCES software(id) ON DELETE CASCADE
      )
    ''');

    // Tabla de sesión activa persistente localmente
    await db.execute('''
      CREATE TABLE sesion(
        id INTEGER PRIMARY KEY,
        usuarioId INTEGER,
        activo INTEGER
      )
    ''');

    // Insertar usuario inicial de pruebas
    await db.insert('usuarios', {
      'nombreCompleto': 'Rodolfo Javier Platas Molina',
      'email': 'rodolfo.platas@prepa.edu.mx',
      'contrasena': 'admin123'
    });

    // Insertar computadoras iniciales (PC1 a PC9 para visualización gráfica por defecto)
    List<Map<String, dynamic>> computadorasIniciales = [
      {'numeroPc': 1, 'marca': 'Dell', 'modelo': 'Optiplex 7080', 'procesador': 'Intel Core i5', 'memoriaRam': '8 GB', 'almacenamiento': '256 GB SSD', 'sistemaOperativo': 'Windows 10 Pro', 'direccionIp': '192.168.1.101', 'estado': 'Disponible'},
      {'numeroPc': 2, 'marca': 'Dell', 'modelo': 'Optiplex 7080', 'procesador': 'Intel Core i5', 'memoriaRam': '8 GB', 'almacenamiento': '256 GB SSD', 'sistemaOperativo': 'Windows 10 Pro', 'direccionIp': '192.168.1.102', 'estado': 'Disponible'},
      {'numeroPc': 3, 'marca': 'HP', 'modelo': 'ProDesk 400', 'procesador': 'Intel Core i5', 'memoriaRam': '8 GB', 'almacenamiento': '240 GB SSD', 'sistemaOperativo': 'Windows 10 Pro', 'direccionIp': '192.168.1.103', 'estado': 'Mantenimiento'},
      {'numeroPc': 4, 'marca': 'Dell', 'modelo': 'Optiplex 7080', 'procesador': 'Intel Core i5', 'memoriaRam': '8 GB', 'almacenamiento': '256 GB SSD', 'sistemaOperativo': 'Windows 10 Pro', 'direccionIp': '192.168.1.104', 'estado': 'Disponible'},
      {'numeroPc': 5, 'marca': 'Dell', 'modelo': 'Optiplex 7080', 'procesador': 'Intel Core i5', 'memoriaRam': '16 GB', 'almacenamiento': '512 GB SSD', 'sistemaOperativo': 'Windows 11 Pro', 'direccionIp': '192.168.1.105', 'estado': 'Disponible'},
      {'numeroPc': 6, 'marca': 'HP', 'modelo': 'ProDesk 400', 'procesador': 'Intel Core i5', 'memoriaRam': '8 GB', 'almacenamiento': '240 GB SSD', 'sistemaOperativo': 'Windows 10 Pro', 'direccionIp': '192.168.1.106', 'estado': 'Dañada'},
      {'numeroPc': 7, 'marca': 'Lenovo', 'modelo': 'ThinkCentre M70q', 'procesador': 'Intel Core i7', 'memoriaRam': '16 GB', 'almacenamiento': '512 GB SSD', 'sistemaOperativo': 'Windows 11 Pro', 'direccionIp': '192.168.1.107', 'estado': 'Disponible'},
      {'numeroPc': 8, 'marca': 'Lenovo', 'modelo': 'ThinkCentre M70q', 'procesador': 'Intel Core i7', 'memoriaRam': '16 GB', 'almacenamiento': '512 GB SSD', 'sistemaOperativo': 'Windows 11 Pro', 'direccionIp': '192.168.1.108', 'estado': 'Disponible'},
      {'numeroPc': 9, 'marca': 'HP', 'modelo': 'ProDesk 400', 'procesador': 'Intel Core i5', 'memoriaRam': '8 GB', 'almacenamiento': '240 GB SSD', 'sistemaOperativo': 'Windows 10 Pro', 'direccionIp': '192.168.1.109', 'estado': 'Fuera de servicio'},
    ];
    for (var pc in computadorasIniciales) {
      await db.insert('computadoras', pc);
    }

    // Insertar software inicial por defecto
    List<Map<String, dynamic>> softwareInicial = [
      {'nombre': 'Visual Studio Code', 'version': '1.85.0', 'categoria': 'Desarrollo'},
      {'nombre': 'Google Chrome', 'version': '120.0', 'categoria': 'Navegador'},
      {'nombre': 'Node.js', 'version': '20.10.0', 'categoria': 'Desarrollo'},
      {'nombre': 'Python', 'version': '3.11.5', 'categoria': 'Desarrollo'},
      {'nombre': 'MongoDB Compass', 'version': '1.40.4', 'categoria': 'Desarrollo'},
      {'nombre': 'Microsoft Office 365', 'version': '16.0', 'categoria': 'Ofimática'},
      {'nombre': 'Antivirus Avast', 'version': '23.12', 'categoria': 'Utilidades'},
    ];
    for (var sw in softwareInicial) {
      await db.insert('software', sw);
    }

    // Relacionar software inicial con las primeras computadoras (PC 1, PC 2, etc.)
    // Relacionar VS Code, Chrome y Python con PC1 y PC2
    for (int pcId = 1; pcId <= 2; pcId++) {
      for (int swId = 1; swId <= 4; swId++) {
        await db.insert('computadora_software', {
          'computadoraId': pcId,
          'softwareId': swId
        });
      }
    }

    // Insertar inventario inicial
    List<Map<String, dynamic>> inventarioInicial = [
      {'nombre': 'Mouse Óptico Logitech', 'cantidad': 25, 'categoria': 'Mouse', 'estado': 'Bueno', 'fechaAdquisicion': '2025-01-15', 'ubicacion': 'Gaveta A1'},
      {'nombre': 'Teclado de Membrana HP', 'cantidad': 20, 'categoria': 'Teclado', 'estado': 'Bueno', 'fechaAdquisicion': '2025-01-15', 'ubicacion': 'Gaveta A2'},
      {'nombre': 'Switch Cisco 24 Puertos', 'cantidad': 2, 'categoria': 'Switch', 'estado': 'Bueno', 'fechaAdquisicion': '2024-06-10', 'ubicacion': 'Rack Principal'},
      {'nombre': 'Impresora Láser HP', 'cantidad': 1, 'categoria': 'Impresora', 'estado': 'Bueno', 'fechaAdquisicion': '2024-08-22', 'ubicacion': 'Mesa del Profesor'},
    ];
    for (var inv in inventarioInicial) {
      await db.insert('inventario', inv);
    }

    // Insertar algunas reservas de ejemplo
    List<Map<String, dynamic>> reservasIniciales = [
      {'profesor': 'Ing. Carlos Gómez', 'grupo': '501-A', 'materia': 'Programación Orientada a Objetos', 'fecha': '2026-06-01', 'horario': '13:00 - 14:20', 'laboratorio': 'Laboratorio A'},
      {'profesor': 'Mtra. Elena Ruiz', 'grupo': '302-B', 'materia': 'Ofimática Aplicada', 'fecha': '2026-06-01', 'horario': '14:20 - 15:40', 'laboratorio': 'Laboratorio A'},
    ];
    for (var res in reservasIniciales) {
      await db.insert('reservas', res);
    }
  }

  // OPERACIONES CRUD: USUARIOS Y AUTENTICACIÓN
  Future<int> registrarUsuario(Map<String, dynamic> usuario) async {
    Database db = await database;
    return await db.insert('usuarios', usuario);
  }

  Future<Map<String, dynamic>?> login(String email, String contrasena) async {
    Database db = await database;
    List<Map<String, dynamic>> res = await db.query(
      'usuarios',
      where: 'email = ? AND contrasena = ?',
      whereArgs: [email, contrasena],
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  // Guardar sesión activa en la base de datos
  Future<void> guardarSesion(int usuarioId) async {
    Database db = await database;
    await db.delete('sesion');
    await db.insert('sesion', {'id': 1, 'usuarioId': usuarioId, 'activo': 1});
  }

  // Obtener ID del usuario con sesión activa si existe
  Future<int?> obtenerSesionActiva() async {
    Database db = await database;
    List<Map<String, dynamic>> res = await db.query('sesion', where: 'activo = 1');
    if (res.isNotEmpty) {
      return res.first['usuarioId'] as int;
    }
    return null;
  }

  // Cerrar sesión local
  Future<void> cerrarSesion() async {
    Database db = await database;
    await db.delete('sesion');
  }

  // OPERACIONES CRUD: COMPUTADORAS
  Future<int> agregarComputadora(Map<String, dynamic> computadora) async {
    Database db = await database;
    return await db.insert('computadoras', computadora);
  }

  Future<List<Map<String, dynamic>>> obtenerComputadoras() async {
    Database db = await database;
    return await db.query('computadoras', orderBy: 'numeroPc ASC');
  }

  Future<int> actualizarComputadora(Map<String, dynamic> computadora) async {
    Database db = await database;
    return await db.update(
      'computadoras',
      computadora,
      where: 'id = ?',
      whereArgs: [computadora['id']],
    );
  }

  Future<int> eliminarComputadora(int id) async {
    Database db = await database;
    // Eliminar relaciones de software
    await db.delete('computadora_software', where: 'computadoraId = ?', whereArgs: [id]);
    return await db.delete('computadoras', where: 'id = ?', whereArgs: [id]);
  }

  // OPERACIONES CRUD: INVENTARIO
  Future<int> agregarInventario(Map<String, dynamic> item) async {
    Database db = await database;
    return await db.insert('inventario', item);
  }

  Future<List<Map<String, dynamic>>> obtenerInventario() async {
    Database db = await database;
    return await db.query('inventario', orderBy: 'nombre ASC');
  }

  Future<int> actualizarInventario(Map<String, dynamic> item) async {
    Database db = await database;
    return await db.update(
      'inventario',
      item,
      where: 'id = ?',
      whereArgs: [item['id']],
    );
  }

  Future<int> eliminarInventario(int id) async {
    Database db = await database;
    return await db.delete('inventario', where: 'id = ?', whereArgs: [id]);
  }

  // OPERACIONES CRUD: RESERVAS
  Future<int> agregarReserva(Map<String, dynamic> reserva) async {
    Database db = await database;
    return await db.insert('reservas', reserva);
  }

  Future<List<Map<String, dynamic>>> obtenerReservas() async {
    Database db = await database;
    return await db.query('reservas', orderBy: 'fecha ASC, horario ASC');
  }

  // Validar si existe conflicto de horario para el mismo laboratorio, fecha y horario
  Future<bool> existeConflictoReserva(String fecha, String horario, String laboratorio, {int? excluirId}) async {
    Database db = await database;
    String query = 'fecha = ? AND horario = ? AND laboratorio = ?';
    List<dynamic> args = [fecha, horario, laboratorio];
    if (excluirId != null) {
      query += ' AND id != ?';
      args.add(excluirId);
    }
    List<Map<String, dynamic>> res = await db.query('reservas', where: query, whereArgs: args);
    return res.isNotEmpty;
  }

  Future<int> actualizarReserva(Map<String, dynamic> reserva) async {
    Database db = await database;
    return await db.update(
      'reservas',
      reserva,
      where: 'id = ?',
      whereArgs: [reserva['id']],
    );
  }

  Future<int> eliminarReserva(int id) async {
    Database db = await database;
    return await db.delete('reservas', where: 'id = ?', whereArgs: [id]);
  }

  // OPERACIONES CRUD: REPORTES DE FALLAS
  Future<int> agregarReporteFalla(Map<String, dynamic> reporte) async {
    Database db = await database;
    return await db.insert('reportes_fallas', reporte);
  }

  Future<List<Map<String, dynamic>>> obtenerReportesFallas() async {
    Database db = await database;
    return await db.query('reportes_fallas', orderBy: 'fecha DESC');
  }

  Future<int> actualizarReporteFalla(Map<String, dynamic> reporte) async {
    Database db = await database;
    return await db.update(
      'reportes_fallas',
      reporte,
      where: 'id = ?',
      whereArgs: [reporte['id']],
    );
  }

  Future<int> eliminarReporteFalla(int id) async {
    Database db = await database;
    return await db.delete('reportes_fallas', where: 'id = ?', whereArgs: [id]);
  }

  // OPERACIONES CRUD: MANTENIMIENTOS
  Future<int> agregarMantenimiento(Map<String, dynamic> mantenimiento) async {
    Database db = await database;
    return await db.insert('mantenimientos', mantenimiento);
  }

  Future<List<Map<String, dynamic>>> obtenerMantenimientos() async {
    Database db = await database;
    return await db.query('mantenimientos', orderBy: 'fecha DESC');
  }

  Future<int> actualizarMantenimiento(Map<String, dynamic> mantenimiento) async {
    Database db = await database;
    return await db.update(
      'mantenimientos',
      mantenimiento,
      where: 'id = ?',
      whereArgs: [mantenimiento['id']],
    );
  }

  Future<int> eliminarMantenimiento(int id) async {
    Database db = await database;
    return await db.delete('mantenimientos', where: 'id = ?', whereArgs: [id]);
  }

  // OPERACIONES CRUD: SOFTWARE
  Future<int> agregarSoftware(Map<String, dynamic> sw) async {
    Database db = await database;
    return await db.insert('software', sw);
  }

  Future<List<Map<String, dynamic>>> obtenerSoftware() async {
    Database db = await database;
    return await db.query('software', orderBy: 'nombre ASC');
  }

  Future<int> actualizarSoftware(Map<String, dynamic> sw) async {
    Database db = await database;
    return await db.update(
      'software',
      sw,
      where: 'id = ?',
      whereArgs: [sw['id']],
    );
  }

  Future<int> eliminarSoftware(int id) async {
    Database db = await database;
    // Eliminar relaciones de computadoras
    await db.delete('computadora_software', where: 'softwareId = ?', whereArgs: [id]);
    return await db.delete('software', where: 'id = ?', whereArgs: [id]);
  }

  // RELACIÓN COMPUTADORA - SOFTWARE
  Future<void> instalarSoftwareEnComputadora(int computadoraId, int softwareId) async {
    Database db = await database;
    await db.insert('computadora_software', {
      'computadoraId': computadoraId,
      'softwareId': softwareId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> desinstalarSoftwareDeComputadora(int computadoraId, int softwareId) async {
    Database db = await database;
    await db.delete(
      'computadora_software',
      where: 'computadoraId = ? AND softwareId = ?',
      whereArgs: [computadoraId, softwareId],
    );
  }

  // Obtener software instalado en una computadora específica
  Future<List<Map<String, dynamic>>> obtenerSoftwarePorComputadora(int computadoraId) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT s.* FROM software s
      INNER JOIN computadora_software cs ON s.id = cs.softwareId
      WHERE cs.computadoraId = ?
      ORDER BY s.nombre ASC
    ''', [computadoraId]);
  }
}
