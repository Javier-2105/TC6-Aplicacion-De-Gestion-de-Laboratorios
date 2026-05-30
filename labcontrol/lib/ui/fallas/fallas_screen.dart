//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lab_provider.dart';
import '../../data/models/reporte_falla.dart';

// Pantalla para la gestión de reportes de fallas en las computadoras del laboratorio
class FallasScreen extends StatefulWidget {
  const FallasScreen({super.key});

  @override
  State<FallasScreen> createState() => _FallasScreenState();
}

class _FallasScreenState extends State<FallasScreen> {
  String _busqueda = '';
  String _filtroPrioridad = 'Todos';

  // Mostrar el formulario para crear/editar reportes de fallas
  void _mostrarFormularioFallas(BuildContext context, {ReporteFalla? reporte}) {
    final isEdit = reporte != null;
    final formKey = GlobalKey<FormState>();
    final labProvider = Provider.of<LabProvider>(context, listen: false);

    final problemaController = TextEditingController(text: isEdit ? reporte.problema : '');
    final descripcionController = TextEditingController(text: isEdit ? reporte.descripcion : '');
    final fechaController = TextEditingController(text: isEdit ? reporte.fecha : DateTime.now().toString().substring(0, 10));

    // Si hay computadoras registradas, tomar la primera o la del reporte
    int pcSeleccionada = 1;
    if (labProvider.computadoras.isNotEmpty) {
      pcSeleccionada = isEdit ? reporte.computadoraId : labProvider.computadoras.first.numeroPc;
    }

    String prioridadSeleccionada = isEdit ? reporte.prioridad : 'Media';
    String estadoSeleccionado = isEdit ? reporte.estado : 'Pendiente';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF162A35),
              title: Text(
                isEdit ? 'Editar Reporte' : 'Nuevo Reporte de Falla',
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
                        // Selector de PC
                        if (labProvider.computadoras.isNotEmpty)
                          DropdownButtonFormField<int>(
                            value: pcSeleccionada,
                            dropdownColor: const Color(0xFF162A35),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'PC Afectada',
                              labelStyle: TextStyle(color: Colors.white70),
                            ),
                            items: labProvider.computadoras
                                .map((pc) => DropdownMenuItem(
                                      value: pc.numeroPc,
                                      child: Text('PC ${pc.numeroPc}'),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() {
                                  pcSeleccionada = val;
                                });
                              }
                            },
                          )
                        else
                          TextFormField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'PC Afectada (Número)',
                              labelStyle: TextStyle(color: Colors.white70),
                            ),
                            validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                            onChanged: (value) {
                              pcSeleccionada = int.tryParse(value) ?? 1;
                            },
                          ),
                        TextFormField(
                          controller: problemaController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Problema (Resumen)',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: descripcionController,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Descripción detallada',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: fechaController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Fecha del reporte (AAAA-MM-DD)',
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
                        DropdownButtonFormField<String>(
                          value: prioridadSeleccionada,
                          dropdownColor: const Color(0xFF162A35),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Prioridad',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          items: ['Baja', 'Media', 'Alta', 'Crítica']
                              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                prioridadSeleccionada = val;
                              });
                            }
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: estadoSeleccionado,
                          dropdownColor: const Color(0xFF162A35),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Estado',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          items: ['Pendiente', 'Revisando', 'Reparado', 'Cerrado']
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

                    final nuevoReporte = ReporteFalla(
                      id: reporte?.id,
                      computadoraId: pcSeleccionada,
                      problema: problemaController.text.trim(),
                      descripcion: descripcionController.text.trim(),
                      fecha: fechaController.text,
                      prioridad: prioridadSeleccionada,
                      estado: estadoSeleccionado,
                    );

                    bool res;
                    if (isEdit) {
                      res = await labProvider.actualizarReporteFalla(nuevoReporte);
                    } else {
                      res = await labProvider.agregarReporteFalla(nuevoReporte);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res ? 'Reporte guardado' : 'Error al guardar'),
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

  // Confirmar eliminación del reporte
  void _confirmarEliminar(BuildContext context, ReporteFalla reporte) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF162A35),
          title: const Text('Eliminar Reporte', style: TextStyle(color: Colors.white)),
          content: Text('¿Desea eliminar permanentemente el reporte #${reporte.id}?', style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                final labProvider = Provider.of<LabProvider>(context, listen: false);
                await labProvider.eliminarReporteFalla(reporte.id!);
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

  Color _obtenerColorPrioridad(String prioridad) {
    switch (prioridad) {
      case 'Baja': return Colors.green;
      case 'Media': return Colors.blue;
      case 'Alta': return Colors.orange;
      case 'Crítica': return Colors.redAccent;
      default: return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final labProvider = Provider.of<LabProvider>(context);

    final fallasFiltradas = labProvider.reportesFallas.where((falla) {
      final cumpleBusqueda = falla.problema.toLowerCase().contains(_busqueda.toLowerCase()) ||
          falla.descripcion.toLowerCase().contains(_busqueda.toLowerCase()) ||
          falla.computadoraId.toString().contains(_busqueda);
      
      final cumplePrioridad = _filtroPrioridad == 'Todos' || falla.prioridad == _filtroPrioridad;
      return cumpleBusqueda && cumplePrioridad;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text('Reporte de Fallas', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F2027),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_outlined, color: Colors.orangeAccent),
            onPressed: () => _mostrarFormularioFallas(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // FILTROS DE BÚSQUEDA Y PRIORIDAD
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar fallas...',
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
                  value: _filtroPrioridad,
                  dropdownColor: const Color(0xFF162A35),
                  style: const TextStyle(color: Colors.white),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.priority_high, color: Color(0xFF00FF87)),
                  items: ['Todos', 'Baja', 'Media', 'Alta', 'Crítica']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _filtroPrioridad = val;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          
          // LISTA DE DETALLES DE FALLAS
          Expanded(
            child: fallasFiltradas.isEmpty
                ? const Center(child: Text('No hay fallas pendientes.', style: TextStyle(color: Colors.white60)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: fallasFiltradas.length,
                    itemBuilder: (context, index) {
                      final falla = fallasFiltradas[index];
                      final colorPrioridad = _obtenerColorPrioridad(falla.prioridad);

                      return Card(
                        color: const Color(0xFF1E3C48),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ExpansionTile(
                          iconColor: const Color(0xFF00B4DB),
                          collapsedIconColor: Colors.white54,
                          leading: CircleAvatar(
                            backgroundColor: colorPrioridad.withOpacity(0.15),
                            child: Icon(Icons.warning_amber_rounded, color: colorPrioridad),
                          ),
                          title: Text(
                            'PC ${falla.computadoraId} - ${falla.problema}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Prioridad: ${falla.prioridad} • Estado: ${falla.estado}',
                            style: TextStyle(color: colorPrioridad.withOpacity(0.9), fontSize: 12),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Descripción:',
                                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    falla.descripcion,
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Reportado el: ${falla.fecha}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color(0xFF00B4DB)),
                                        onPressed: () => _mostrarFormularioFallas(context, reporte: falla),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                                        onPressed: () => _confirmarEliminar(context, falla),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
