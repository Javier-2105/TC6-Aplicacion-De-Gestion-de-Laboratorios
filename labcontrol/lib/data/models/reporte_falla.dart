//TC6 Platas Molina Rodolfo Javier 23328061310458

class ReporteFalla {
  final int? id;
  final int computadoraId; // Relación con el ID o número de la computadora afectada
  final String problema;
  final String descripcion;
  final String fecha;
  final String prioridad; // Baja, Media, Alta, Crítica
  final String estado; // Pendiente, Revisando, Reparado, Cerrado

  ReporteFalla({
    this.id,
    required this.computadoraId,
    required this.problema,
    required this.descripcion,
    required this.fecha,
    required this.prioridad,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'computadoraId': computadoraId,
      'problema': problema,
      'descripcion': descripcion,
      'fecha': fecha,
      'prioridad': prioridad,
      'estado': estado,
    };
  }

  factory ReporteFalla.fromMap(Map<String, dynamic> map) {
    return ReporteFalla(
      id: map['id'] as int?,
      computadoraId: map['computadoraId'] as int,
      problema: map['problema'] as String,
      descripcion: map['descripcion'] as String,
      fecha: map['fecha'] as String,
      prioridad: map['prioridad'] as String,
      estado: map['estado'] as String,
    );
  }
}
