//TC6 Platas Molina Rodolfo Javier 23328061310458

class Computadora {
  final int? id;
  final int numeroPc;
  final String marca;
  final String modelo;
  final String procesador;
  final String memoriaRam;
  final String almacenamiento;
  final String sistemaOperativo;
  final String direccionIp;
  final String estado; // Disponible, Mantenimiento, Dañada, Fuera de servicio

  Computadora({
    this.id,
    required this.numeroPc,
    required this.marca,
    required this.modelo,
    required this.procesador,
    required this.memoriaRam,
    required this.almacenamiento,
    required this.sistemaOperativo,
    required this.direccionIp,
    required this.estado,
  });

  // Convertir un objeto Computadora a un Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numeroPc': numeroPc,
      'marca': marca,
      'modelo': modelo,
      'procesador': procesador,
      'memoriaRam': memoriaRam,
      'almacenamiento': almacenamiento,
      'sistemaOperativo': sistemaOperativo,
      'direccionIp': direccionIp,
      'estado': estado,
    };
  }

  // Crear un objeto Computadora a partir de un Map de SQLite
  factory Computadora.fromMap(Map<String, dynamic> map) {
    return Computadora(
      id: map['id'] as int?,
      numeroPc: map['numeroPc'] as int,
      marca: map['marca'] as String,
      modelo: map['modelo'] as String,
      procesador: map['procesador'] as String,
      memoriaRam: map['memoriaRam'] as String,
      almacenamiento: map['almacenamiento'] as String,
      sistemaOperativo: map['sistemaOperativo'] as String,
      direccionIp: map['direccionIp'] as String,
      estado: map['estado'] as String,
    );
  }
}
