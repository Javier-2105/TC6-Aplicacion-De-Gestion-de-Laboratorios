//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lab_provider.dart';
import '../../data/models/reserva.dart';

// Pantalla para el control de reservas del laboratorio escolar con calendario y prevención de conflictos
class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ScrollBehaviorOverride extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _ReservasScreenState extends State<ReservasScreen> {
  DateTime _diaSeleccionado = DateTime.now();
  String _laboratorioFiltro = 'Laboratorio A';

  final List<String> _horariosPredefinidos = [
    '13:00 - 14:20',
    '14:20 - 15:40',
    '15:40 - 17:00',
    '17:00 - 18:20',
    '18:20 - 20:00',
  ];

  // Mostrar el diálogo del formulario para agregar o editar reservas
  void _mostrarFormularioReserva(BuildContext context, {Reserva? reserva, String? horarioDefault}) {
    final isEdit = reserva != null;
    final formKey = GlobalKey<FormState>();

    final profesorController = TextEditingController(text: isEdit ? reserva.profesor : '');
    final grupoController = TextEditingController(text: isEdit ? reserva.grupo : '');
    final materiaController = TextEditingController(text: isEdit ? reserva.materia : '');
    final fechaController = TextEditingController(
      text: isEdit ? reserva.fecha : _diaSeleccionado.toString().substring(0, 10),
    );

    String laboratorioSeleccionado = isEdit ? reserva.laboratorio : _laboratorioFiltro;
    String horarioSeleccionado = isEdit ? reserva.horario : (horarioDefault ?? _horariosPredefinidos.first);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF162A35),
              title: Text(
                isEdit ? 'Modificar Reserva' : 'Reservar Laboratorio',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: profesorController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Profesor Solicitante',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: grupoController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Grupo (Ej: 502-A)',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: materiaController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Materia o Asignatura',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: fechaController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Fecha de Reserva',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.parse(fechaController.text),
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              fechaController.text = picked.toString().substring(0, 10);
                            }
                          },
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: laboratorioSeleccionado,
                          dropdownColor: const Color(0xFF162A35),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Laboratorio',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          items: ['Laboratorio A', 'Laboratorio B']
                              .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                laboratorioSeleccionado = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: horarioSeleccionado,
                          dropdownColor: const Color(0xFF162A35),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Horario',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          items: _horariosPredefinidos
                              .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                horarioSeleccionado = val;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF87)),
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    final labProvider = Provider.of<LabProvider>(context, listen: false);
                    final nuevaReserva = Reserva(
                      id: reserva?.id,
                      profesor: profesorController.text.trim(),
                      grupo: grupoController.text.trim(),
                      materia: materiaController.text.trim(),
                      fecha: fechaController.text,
                      horario: horarioSeleccionado,
                      laboratorio: laboratorioSeleccionado,
                    );

                    bool exito;
                    if (isEdit) {
                      exito = await labProvider.actualizarReserva(nuevaReserva);
                    } else {
                      exito = await labProvider.agregarReserva(nuevaReserva);
                    }

                    if (context.mounted) {
                      if (exito) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reserva guardada con éxito.'),
                            backgroundColor: Color(0xFF00FF87),
                          ),
                        );
                      } else {
                        // Diálogo que explica el conflicto de horario para cumplir con la regla de evitar colisiones
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF2C1E21),
                            title: const Text('Conflicto Detectado', style: TextStyle(color: Colors.redAccent)),
                            content: const Text(
                              'El horario y laboratorio seleccionado ya se encuentra ocupado por otra clase en la fecha elegida. Por favor, asigne otro bloque.',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Guardar', style: TextStyle(color: Color(0xFF0F2027), fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Eliminar reserva con confirmación
  void _confirmarEliminar(BuildContext context, Reserva res) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF162A35),
          title: const Text('Eliminar Reserva', style: TextStyle(color: Colors.white)),
          content: Text('¿Desea cancelar la reserva del grupo ${res.grupo}?', style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                final labProvider = Provider.of<LabProvider>(context, listen: false);
                await labProvider.eliminarReserva(res.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Cancelar Reserva', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Helper para generar una tira de los siguientes 14 días (Calendario visual de agenda)
  Widget _calendarioSemanalHorizontal() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ScrollConfiguration(
        behavior: _ScrollBehaviorOverride(),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 14,
          itemBuilder: (context, index) {
            final dia = DateTime.now().add(Duration(days: index - 2));
            final esHoy = dia.day == _diaSeleccionado.day &&
                dia.month == _diaSeleccionado.month &&
                dia.year == _diaSeleccionado.year;

            final nombreDia = _obtenerNombreDiaCorto(dia.weekday);

            return GestureDetector(
              onTap: () {
                setState(() {
                  _diaSeleccionado = dia;
                });
              },
              child: Container(
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: esHoy ? const Color(0xFF00FF87) : const Color(0xFF1A3644),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: esHoy ? const Color(0xFF00FF87) : Colors.white10,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nombreDia,
                      style: TextStyle(
                        color: esHoy ? const Color(0xFF0F2027) : Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dia.day.toString(),
                      style: TextStyle(
                        color: esHoy ? const Color(0xFF0F2027) : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _obtenerNombreDiaCorto(int weekday) {
    switch (weekday) {
      case 1: return 'Lun';
      case 2: return 'Mar';
      case 3: return 'Mié';
      case 4: return 'Jue';
      case 5: return 'Vie';
      case 6: return 'Sáb';
      default: return 'Dom';
    }
  }

  @override
  Widget build(BuildContext context) {
    final labProvider = Provider.of<LabProvider>(context);
    final String diaStr = _diaSeleccionado.toString().substring(0, 10);

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text('Agenda y Reservas', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F2027),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF00FF87)),
            onPressed: () => _mostrarFormularioReserva(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector de laboratorio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Seleccionar Aula:',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                DropdownButton<String>(
                  value: _laboratorioFiltro,
                  dropdownColor: const Color(0xFF162A35),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF00FF87)),
                  items: ['Laboratorio A', 'Laboratorio B']
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _laboratorioFiltro = val;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // Tira horizontal de calendario visual
          _calendarioSemanalHorizontal(),
          const SizedBox(height: 10),

          // Título de la agenda diaria
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Horarios del $diaStr',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _laboratorioFiltro,
                  style: const TextStyle(color: Color(0xFF00B4DB), fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Lista de agenda diaria interactiva
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _horariosPredefinidos.length,
              itemBuilder: (context, index) {
                final bloque = _horariosPredefinidos[index];
                
                // Buscar si existe una reserva en este bloque para el lab y fecha elegidos
                final reservaEnBloque = labProvider.reservas.firstWhere(
                  (res) => res.fecha == diaStr &&
                      res.horario == bloque &&
                      res.laboratorio == _laboratorioFiltro,
                  orElse: () => Reserva(profesor: '', grupo: '', materia: '', fecha: '', horario: '', laboratorio: ''),
                );

                final estaOcupado = reservaEnBloque.profesor.isNotEmpty;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  height: 95,
                  decoration: BoxDecoration(
                    color: estaOcupado ? const Color(0xFF1E3C48) : const Color(0xFF13252E),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: estaOcupado ? const Color(0xFF00B4DB).withOpacity(0.5) : Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Bloque lateral del horario
                      Container(
                        width: 90,
                        decoration: BoxDecoration(
                          color: estaOcupado ? const Color(0xFF00B4DB).withOpacity(0.1) : Colors.white.withOpacity(0.02),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time, color: Colors.white60, size: 16),
                            const SizedBox(height: 4),
                            Text(
                              bloque.split(' - ').first,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              bloque.split(' - ').last,
                              style: const TextStyle(color: Colors.white60, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      
                      // Información de la reserva / Opciones
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: estaOcupado
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            reservaEnBloque.materia,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Prof: ${reservaEnBloque.profesor}',
                                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Grupo: ${reservaEnBloque.grupo}',
                                            style: const TextStyle(color: Color(0xFF00FF87), fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Color(0xFF00B4DB), size: 18),
                                      onPressed: () => _mostrarFormularioReserva(context, reserva: reservaEnBloque),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                                      onPressed: () => _confirmarEliminar(context, reservaEnBloque),
                                    ),
                                  ]
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Bloque Disponible',
                                      style: TextStyle(color: Colors.white38, fontStyle: FontStyle.italic),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1E3C48),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () => _mostrarFormularioReserva(context, horarioDefault: bloque),
                                      child: const Text('Reservar', style: TextStyle(color: Color(0xFF00FF87), fontSize: 12)),
                                    ),
                                  ],
                                ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
