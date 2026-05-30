//TC6 Platas Molina Rodolfo Javier 23328061310458

class Mantenimiento {
  final int? id;
  final String equipo; // Nombre o número de PC
  final String fecha;
  final String problemaDetectado;
  final String diagnostico;
  final String solucionAplicada;
  final double costo;
  final String estado; // Pendiente, En Proceso, Completado

  Mantenimiento({
    this.id,
    required this.equipo,
    required this.fecha,
    required this.problemaDetectado,
    required this.diagnostico,
    required this.solucionAplicada,
    required this.costo,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipo': equipo,
      'fecha': fecha,
      'problemaDetectado': problemaDetectado,
      'diagnostico': diagnostico,
      'solucionAplicada': solucionAplicada,
      'costo': costo,
      'estado': estado,
    };
  }

  factory Mantenimiento.fromMap(Map<String, dynamic> map) {
    return Mantenimiento(
      id: map['id'] as int?,
      equipo: map['equipo'] as String,
      fecha: map['fecha'] as String,
      problemaDetectado: map['problemaDetectado'] as String,
      diagnostico: map['diagnostico'] as String,
      solucionAplicada: map['solucionAplicada'] as String,
      costo: (map['costo'] as num).toDouble(),
      estado: map['estado'] as String,
    );
  }
}
