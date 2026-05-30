//TC6 Platas Molina Rodolfo Javier 23328061310458

class Software {
  final int? id;
  final String nombre;
  final String version;
  final String categoria; // Sistema, Desarrollo, Navegador, Ofimática, Utilidades, Otros

  Software({
    this.id,
    required this.nombre,
    required this.version,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'version': version,
      'categoria': categoria,
    };
  }

  factory Software.fromMap(Map<String, dynamic> map) {
    return Software(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      version: map['version'] as String,
      categoria: map['categoria'] as String,
    );
  }
}
