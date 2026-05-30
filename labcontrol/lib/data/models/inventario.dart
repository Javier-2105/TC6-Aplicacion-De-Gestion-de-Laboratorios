//TC6 Platas Molina Rodolfo Javier 23328061310458

class Inventario {
  final int? id;
  final String nombre;
  final int cantidad;
  final String categoria; // Mouse, Teclado, Monitor, Switch, Router, Impresora, Proyector, Cable, Otros
  final String estado; // Bueno, Regular, Malo
  final String fechaAdquisicion;
  final String ubicacion;

  Inventario({
    this.id,
    required this.nombre,
    required this.cantidad,
    required this.categoria,
    required this.estado,
    required this.fechaAdquisicion,
    required this.ubicacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'cantidad': cantidad,
      'categoria': categoria,
      'estado': estado,
      'fechaAdquisicion': fechaAdquisicion,
      'ubicacion': ubicacion,
    };
  }

  factory Inventario.fromMap(Map<String, dynamic> map) {
    return Inventario(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      cantidad: map['cantidad'] as int,
      categoria: map['categoria'] as String,
      estado: map['estado'] as String,
      fechaAdquisicion: map['fechaAdquisicion'] as String,
      ubicacion: map['ubicacion'] as String,
    );
  }
}
