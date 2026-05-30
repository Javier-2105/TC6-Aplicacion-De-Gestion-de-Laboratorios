//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../data/models/usuario.dart';

// Proveedor de estado para la autenticación de usuarios
class AuthProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  Usuario? _usuarioActual;
  bool _estaCargando = false;

  Usuario? get usuarioActual => _usuarioActual;
  bool get estaCargando => _estaCargando;
  bool get estaAutenticado => _usuarioActual != null;

  // Registrar un nuevo usuario
  Future<bool> registrar(String nombreCompleto, String email, String contrasena) async {
    _estaCargando = true;
    notifyListeners();
    try {
      final nuevoUsuario = Usuario(
        nombreCompleto: nombreCompleto,
        email: email,
        contrasena: contrasena,
      );
      await _dbHelper.registrarUsuario(nuevoUsuario.toMap());
      _estaCargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _estaCargando = false;
      notifyListeners();
      return false; // Retorna falso si el correo ya existe
    }
  }

  // Iniciar sesión de usuario
  Future<bool> login(String email, String contrasena) async {
    _estaCargando = true;
    notifyListeners();
    try {
      final userMap = await _dbHelper.login(email, contrasena);
      if (userMap != null) {
        _usuarioActual = Usuario.fromMap(userMap);
        await _dbHelper.guardarSesion(_usuarioActual!.id!);
        _estaCargando = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      // Manejar error silenciosamente
    }
    _estaCargando = false;
    notifyListeners();
    return false;
  }

  // Verificar si hay una sesión activa guardada localmente
  Future<bool> verificarSesionActiva() async {
    _estaCargando = true;
    notifyListeners();
    try {
      final usuarioId = await _dbHelper.obtenerSesionActiva();
      if (usuarioId != null) {
        // Cargar datos de usuario
        final db = await _dbHelper.database;
        final res = await db.query('usuarios', where: 'id = ?', whereArgs: [usuarioId]);
        if (res.isNotEmpty) {
          _usuarioActual = Usuario.fromMap(res.first);
          _estaCargando = false;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      // Error silencioso al verificar sesión
    }
    _estaCargando = false;
    notifyListeners();
    return false;
  }

  // Cerrar sesión localmente
  Future<void> cerrarSesion() async {
    _estaCargando = true;
    notifyListeners();
    await _dbHelper.cerrarSesion();
    _usuarioActual = null;
    _estaCargando = false;
    notifyListeners();
  }
}
