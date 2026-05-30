//TC6 Platas Molina Rodolfo Javier 23328061310458

class Reserva {
  final int? id;
  final String profesor;
  final String grupo;
  final String materia;
  final String fecha; // YYYY-MM-DD
  final String horario; // Ej. "07:00 - 08:40", "08:40 - 10:20", "10:20 - 12:00", "12:00 - 13:40"
  final String laboratorio; // Ej. "Laboratorio A", "Laboratorio B"

  Reserva({
    this.id,
    required this.profesor,
    required this.grupo,
    required this.materia,
    required this.fecha,
    required this.horario,
    required this.laboratorio,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profesor': profesor,
      'grupo': grupo,
      'materia': materia,
      'fecha': fecha,
      'horario': horario,
      'laboratorio': laboratorio,
    };
  }

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      id: map['id'] as int?,
      profesor: map['profesor'] as String,
      grupo: map['grupo'] as String,
      materia: map['materia'] as String,
      fecha: map['fecha'] as String,
      horario: map['horario'] as String,
      laboratorio: map['laboratorio'] as String,
    );
  }
}
