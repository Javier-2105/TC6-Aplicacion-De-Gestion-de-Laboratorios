//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lab_provider.dart';
import '../../data/models/mantenimiento.dart';

// Pantalla para la gestión de mantenimientos de equipos del laboratorio
class MantenimientoScreen extends StatefulWidget {
  const MantenimientoScreen({super.key});

  @override
  State<MantenimientoScreen> createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {
  String _busqueda = '';
  String _filtroEstado = 'Todos';

  // Mostrar formulario de mantenimiento
  void _mostrarFormularioMantenimiento(BuildContext context, {Mantenimiento? mant}) {
    final isEdit = mant != null;
    final formKey = GlobalKey<FormState>();

    final equipoController = TextEditingController(text: isEdit ? mant.equipo : '');
    final fechaController = TextEditingController(text: isEdit ? mant.fecha : DateTime.now().toString().substring(0, 10));
    final problemaController = TextEditingController(text: isEdit ? mant.problemaDetectado : '');
    final diagnosticoController = TextEditingController(text: isEdit ? mant.diagnostico : '');
    final solucionController = TextEditingController(text: isEdit ? mant.solucionAplicada : '');
    final costoController = TextEditingController(text: isEdit ? mant.costo.toString() : '0.00');
    
    String estadoSeleccionado = isEdit ? mant.estado : 'Pendiente';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF162A35),
              title: Text(
                isEdit ? 'Editar Mantenimiento' : 'Registrar Mantenimiento',
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
                          controller: equipoController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Equipo / PC',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: fechaController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Fecha del Mantenimiento',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              fechaController.text = picked.toString().substring(0, 10);
                            }
                          },
                        ),
                        TextFormField(
                          controller: problemaController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Problema Detectado',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: diagnosticoController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Diagnóstico Técnico',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: solucionController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Solución Aplicada',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: costoController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Costo del Mantenimiento (\$)',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Requerido';
                            if (double.tryParse(value) == null) return 'Ingrese un costo válido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: estadoSeleccionado,
                          dropdownColor: const Color(0xFF162A35),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Estado del Mantenimiento',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          items: ['Pendiente', 'En Proceso', 'Completado']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                estadoSeleccionado = val;
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
                    final nuevoMant = Mantenimiento(
                      id: mant?.id,
                      equipo: equipoController.text.trim(),
                      fecha: fechaController.text,
                      problemaDetectado: problemaController.text.trim(),
                      diagnostico: diagnosticoController.text.trim(),
                      solucionAplicada: solucionController.text.trim(),
                      costo: double.parse(costoController.text),
                      estado: estadoSeleccionado,
                    );

                    bool res;
                    if (isEdit) {
                      res = await labProvider.actualizarMantenimiento(nuevoMant);
                    } else {
                      res = await labProvider.agregarMantenimiento(nuevoMant);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res ? 'Mantenimiento registrado con éxito' : 'Error al guardar'),
                          backgroundColor: res ? const Color(0xFF00FF87) : Colors.redAccent,
                        ),
                      );
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

  // Eliminar mantenimiento de historial
  void _confirmarEliminar(BuildContext context, Mantenimiento mant) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF162A35),
          title: const Text('Eliminar Registro', style: TextStyle(color: Colors.white)),
          content: Text('¿Desea eliminar este registro del historial?', style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                final labProvider = Provider.of<LabProvider>(context, listen: false);
                await labProvider.eliminarMantenimiento(mant.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final labProvider = Provider.of<LabProvider>(context);

    final mantenimientosFiltrados = labProvider.mantenimientos.where((mant) {
      final cumpleBusqueda = mant.equipo.toLowerCase().contains(_busqueda.toLowerCase()) ||
          mant.problemaDetectado.toLowerCase().contains(_busqueda.toLowerCase()) ||
          mant.solucionAplicada.toLowerCase().contains(_busqueda.toLowerCase());
      
      final cumpleEstado = _filtroEstado == 'Todos' || mant.estado == _filtroEstado;
      return cumpleBusqueda && cumpleEstado;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text('Mantenimientos', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F2027),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF00FF87)),
            onPressed: () => _mostrarFormularioMantenimiento(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // FILTROS Y BÚSQUEDA
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar historial de mantenimiento...',
                      hintStyle: const TextStyle(color: Colors.white60),
                      prefixIcon: const Icon(Icons.search, color: Colors.white60),
                      filled: true,
                      fillColor: const Color(0xFF1A3644),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _busqueda = val;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _filtroEstado,
                  dropdownColor: const Color(0xFF162A35),
                  style: const TextStyle(color: Colors.white),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.build_rounded, color: Color(0xFF00FF87)),
                  items: ['Todos', 'Pendiente', 'En Proceso', 'Completado']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _filtroEstado = val;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          
          // HISTORIAL EN LISTA
          Expanded(
            child: mantenimientosFiltrados.isEmpty
                ? const Center(child: Text('No hay registros de mantenimiento.', style: TextStyle(color: Colors.white60)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: mantenimientosFiltrados.length,
                    itemBuilder: (context, index) {
                      final mant = mantenimientosFiltrados[index];
                      Color estadoColor = Colors.green;
                      if (mant.estado == 'Pendiente') {
                        estadoColor = Colors.redAccent;
                      } else if (mant.estado == 'En Proceso') {
                        estadoColor = Colors.amber;
                      }

                      return Card(
                        color: const Color(0xFF1E3C48),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ExpansionTile(
                          iconColor: const Color(0xFF00B4DB),
                          collapsedIconColor: Colors.white54,
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF00FF87).withOpacity(0.1),
                            child: Icon(Icons.build_outlined, color: estadoColor),
                          ),
                          title: Text(
                            '${mant.equipo} - ${mant.problemaDetectado}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Estado: ${mant.estado} • Costo: \$${mant.costo.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoLabelText('Diagnóstico', mant.diagnostico),
                                  _infoLabelText('Solución', mant.solucionAplicada),
                                  _infoLabelText('Fecha', mant.fecha),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color(0xFF00B4DB)),
                                        onPressed: () => _mostrarFormularioMantenimiento(context, mant: mant),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                                        onPressed: () => _confirmarEliminar(context, mant),
                                      ),
                                    ],
                                  )
                                ],
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

  Widget _infoLabelText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(color: Color(0xFF00B4DB), fontWeight: FontWeight.bold, fontSize: 13),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
