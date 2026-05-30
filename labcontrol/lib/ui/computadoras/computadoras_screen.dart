//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lab_provider.dart';
import '../../data/models/computadora.dart';
import '../../data/models/software.dart';

// Pantalla para la gestión integral de computadoras
class ComputadorasScreen extends StatefulWidget {
  const ComputadorasScreen({super.key});

  @override
  State<ComputadorasScreen> createState() => _ComputadorasScreenState();
}

class _ComputadorasScreenState extends State<ComputadorasScreen> {
  String _busqueda = '';
  String _filtroEstado = 'Todos';

  // Mostrar diálogo para agregar o editar computadoras
  void _mostrarFormularioPC(BuildContext context, {Computadora? pc}) {
    final isEdit = pc != null;
    final formKey = GlobalKey<FormState>();
    final numeroController = TextEditingController(text: isEdit ? pc.numeroPc.toString() : '');
    final marcaController = TextEditingController(text: isEdit ? pc.marca : '');
    final modeloController = TextEditingController(text: isEdit ? pc.modelo : '');
    final procesadorController = TextEditingController(text: isEdit ? pc.procesador : '');
    final ramController = TextEditingController(text: isEdit ? pc.memoriaRam : '');
    final almacenamientoController = TextEditingController(text: isEdit ? pc.almacenamiento : '');
    final osController = TextEditingController(text: isEdit ? pc.sistemaOperativo : '');
    final ipController = TextEditingController(text: isEdit ? pc.direccionIp : '');
    String estadoSeleccionado = isEdit ? pc.estado : 'Disponible';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF162A35),
              title: Text(
                isEdit ? 'Editar Computadora' : 'Agregar Computadora',
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
                          controller: numeroController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Número de PC',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Requerido';
                            if (int.tryParse(value) == null) return 'Debe ser un número';
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: marcaController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Marca',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: modeloController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Modelo',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: procesadorController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Procesador',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: ramController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Memoria RAM (Ej: 8 GB)',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: almacenamientoController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Almacenamiento (Ej: 256 GB SSD)',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: osController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Sistema Operativo',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: ipController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Dirección IP',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: estadoSeleccionado,
                          dropdownColor: const Color(0xFF162A35),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Estado de la PC',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          items: ['Disponible', 'Mantenimiento', 'Dañada', 'Fuera de servicio']
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
                    final nuevaPc = Computadora(
                      id: pc?.id,
                      numeroPc: int.parse(numeroController.text),
                      marca: marcaController.text.trim(),
                      modelo: modeloController.text.trim(),
                      procesador: procesadorController.text.trim(),
                      memoriaRam: ramController.text.trim(),
                      almacenamiento: almacenamientoController.text.trim(),
                      sistemaOperativo: osController.text.trim(),
                      direccionIp: ipController.text.trim(),
                      estado: estadoSeleccionado,
                    );

                    bool res;
                    if (isEdit) {
                      res = await labProvider.actualizarComputadora(nuevaPc);
                    } else {
                      res = await labProvider.agregarComputadora(nuevaPc);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res ? 'Guardado exitosamente' : 'Error al guardar (Verificar número único)'),
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

  // Diálogo para administrar el software de una PC
  void _mostrarGestionSoftware(BuildContext context, Computadora pc) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final labProvider = Provider.of<LabProvider>(context);
            final softwareInstalado = labProvider.obtenerSoftwareInstalado(pc.id!);
            
            // Software que aún NO está instalado
            final softwareDisponible = labProvider.software
                .where((sw) => !softwareInstalado.any((inst) => inst.id == sw.id))
                .toList();

            return AlertDialog(
              backgroundColor: const Color(0xFF162A35),
              title: Text(
                'Software - PC ${pc.numeroPc}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instalado actualmente:',
                      style: TextStyle(color: Color(0xFF00FF87), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    if (softwareInstalado.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Sin programas instalados.', style: TextStyle(color: Colors.white60)),
                      )
                    else
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: softwareInstalado.length,
                          itemBuilder: (context, index) {
                            final sw = softwareInstalado[index];
                            return Card(
                              color: const Color(0xFF1F3C48),
                              child: ListTile(
                                dense: true,
                                title: Text(sw.nombre, style: const TextStyle(color: Colors.white)),
                                subtitle: Text(sw.version, style: const TextStyle(color: Colors.white70)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                                  onPressed: () async {
                                    await labProvider.desinstalarSoftware(pc.id!, sw.id!);
                                    setDialogState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const Divider(color: Colors.white30),
                    const Text(
                      'Instalar nuevo software:',
                      style: TextStyle(color: Color(0xFF00B4DB), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    if (softwareDisponible.isEmpty)
                      const Text('Todos los programas del catálogo están instalados.', style: TextStyle(color: Colors.white60))
                    else
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: softwareDisponible.length,
                          itemBuilder: (context, index) {
                            final sw = softwareDisponible[index];
                            return ListTile(
                              dense: true,
                              title: Text(sw.nombre, style: const TextStyle(color: Colors.white)),
                              subtitle: Text('${sw.categoria} - V${sw.version}', style: const TextStyle(color: Colors.white70)),
                              trailing: IconButton(
                                icon: const Icon(Icons.add_circle, color: Color(0xFF00FF87)),
                                onPressed: () async {
                                  await labProvider.instalarSoftware(pc.id!, sw.id!);
                                  setDialogState(() {});
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar', style: TextStyle(color: Colors.white70)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Eliminar computadora con confirmación previa
  void _confirmarEliminar(BuildContext context, Computadora pc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF162A35),
          title: const Text('Confirmar Eliminación', style: TextStyle(color: Colors.white)),
          content: Text('¿Desea eliminar permanentemente la PC ${pc.numeroPc}?', style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                final labProvider = Provider.of<LabProvider>(context, listen: false);
                await labProvider.eliminarComputadora(pc.id!);
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

  Color _obtenerColorEstado(String estado) {
    switch (estado) {
      case 'Disponible':
        return const Color(0xFF00FF87);
      case 'Mantenimiento':
        return Colors.amber;
      case 'Dañada':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final labProvider = Provider.of<LabProvider>(context);

    // Filtrar y buscar computadoras
    final pcsFiltradas = labProvider.computadoras.where((pc) {
      final cumpleBusqueda = pc.marca.toLowerCase().contains(_busqueda.toLowerCase()) ||
          pc.modelo.toLowerCase().contains(_busqueda.toLowerCase()) ||
          pc.numeroPc.toString().contains(_busqueda) ||
          pc.procesador.toLowerCase().contains(_busqueda.toLowerCase()) ||
          pc.direccionIp.contains(_busqueda);
      
      final cumpleEstado = _filtroEstado == 'Todos' || pc.estado == _filtroEstado;
      return cumpleBusqueda && cumpleEstado;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text('Gestión de Computadoras', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F2027),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF00FF87)),
            onPressed: () => _mostrarFormularioPC(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // REPRESENTACIÓN VISUAL EN REJILLA DIRECTA
          const SizedBox(height: 10),
          const Text(
            'Vista en Tiempo Real del Laboratorio',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          
          // Rejilla visual simplificada con estados
          Container(
            height: 130,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemCount: labProvider.computadoras.length,
              itemBuilder: (context, index) {
                final pc = labProvider.computadoras[index];
                final color = _obtenerColorEstado(pc.estado);
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3C48),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withOpacity(0.5), width: 1.5),
                  ),
                  child: InkWell(
                    onTap: () => _mostrarGestionSoftware(context, pc),
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.computer, color: color, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          'PC ${pc.numeroPc}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          pc.estado,
                          style: TextStyle(color: color, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),

          // FILTROS Y BÚSQUEDA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar por modelo, marca, IP...',
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
                  icon: const Icon(Icons.filter_list, color: Color(0xFF00FF87)),
                  items: ['Todos', 'Disponible', 'Mantenimiento', 'Dañada', 'Fuera de servicio']
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
          const SizedBox(height: 15),

          // LISTA DE DETALLES DE LAS COMPUTADORAS
          Expanded(
            child: pcsFiltradas.isEmpty
                ? const Center(child: Text('No se encontraron computadoras', style: TextStyle(color: Colors.white60)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: pcsFiltradas.length,
                    itemBuilder: (context, index) {
                      final pc = pcsFiltradas[index];
                      final color = _obtenerColorEstado(pc.estado);
                      final softwareInstalado = labProvider.obtenerSoftwareInstalado(pc.id!);

                      return Card(
                        color: const Color(0xFF1E3C48),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ExpansionTile(
                          iconColor: const Color(0xFF00B4DB),
                          collapsedIconColor: Colors.white54,
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.2),
                            child: Icon(Icons.computer, color: color),
                          ),
                          title: Text(
                            'PC ${pc.numeroPc} - ${pc.marca} ${pc.modelo}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'IP: ${pc.direccionIp} • Estado: ${pc.estado}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoText('Procesador', pc.procesador),
                                  _infoText('RAM', pc.memoriaRam),
                                  _infoText('Almacenamiento', pc.almacenamiento),
                                  _infoText('S.O.', pc.sistemaOperativo),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Programas Instalados (${softwareInstalado.length}):',
                                    style: const TextStyle(color: Color(0xFF00FF87), fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: softwareInstalado.isEmpty
                                        ? [const Text('Ninguno', style: TextStyle(color: Colors.white60, fontSize: 12))]
                                        : softwareInstalado
                                            .map((sw) => Chip(
                                                  label: Text(sw.nombre, style: const TextStyle(fontSize: 11, color: Colors.white)),
                                                  backgroundColor: const Color(0xFF162A35),
                                                  visualDensity: VisualDensity.compact,
                                                ))
                                            .toList(),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.apps_outage_outlined, color: Colors.cyanAccent),
                                        tooltip: 'Administrar Software',
                                        onPressed: () => _mostrarGestionSoftware(context, pc),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color(0xFF00B4DB)),
                                        tooltip: 'Editar PC',
                                        onPressed: () => _mostrarFormularioPC(context, pc: pc),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                                        tooltip: 'Eliminar PC',
                                        onPressed: () => _confirmarEliminar(context, pc),
                                      ),
                                    ],
                                  ),
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

  Widget _infoText(String label, String value) {
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
