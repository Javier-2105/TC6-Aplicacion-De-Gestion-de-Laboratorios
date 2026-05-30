//TC6 Platas Molina Rodolfo Javier 23328061310458

class Usuario {
  final int? id;
  final String nombreCompleto;
  final String email;
  final String contrasena;

  Usuario({
    this.id,
    required this.nombreCompleto,
    required this.email,
    required this.contrasena,
  });

  // Convertir un objeto Usuario a un Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreCompleto': nombreCompleto,
      'email': email,
      'contrasena': contrasena,
    };
  }

  // Crear un objeto Usuario a partir de un Map de SQLite
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      nombreCompleto: map['nombreCompleto'] as String,
      email: map['email'] as String,
      contrasena: map['contrasena'] as String,
    );
  }
}
