//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lab_provider.dart';
import '../../data/models/inventario.dart';

// Pantalla para la gestión del inventario tecnológico del laboratorio
class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  String _busqueda = '';
  String _filtroCategoria = 'Todos';

  // Mostrar el formulario para registrar/editar un artículo
  void _mostrarFormularioInventario(BuildContext context, {Inventario? item}) {
    final isEdit = item != null;
    final formKey = GlobalKey<FormState>();
    
    final nombreController = TextEditingController(text: isEdit ? item.nombre : '');
    final cantidadController = TextEditingController(text: isEdit ? item.cantidad.toString() : '');
    final ubicacionController = TextEditingController(text: isEdit ? item.ubicacion : '');
    final fechaController = TextEditingController(text: isEdit ? item.fechaAdquisicion : DateTime.now().toString().substring(0, 10));
    
    String categoriaSeleccionada = isEdit ? item.categoria : 'Mouse';
    String estadoSeleccionado = isEdit ? item.estado : 'Bueno';

    final categorias = [
      'Mouse', 'Teclado', 'Monitor', 'Switch', 'Router', 'Impresora', 'Proyector', 'Cable', 'Otros'
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF162A35),
              title: Text(
                isEdit ? 'Editar Artículo' : 'Nuevo Artículo',
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
                          controller: nombreController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Nombre del Artículo',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: cantidadController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Cantidad disponible',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Requerido';
                            if (int.tryParse(value) == null) return 'Debe ser un número entero';
                            return null;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: categoriaSeleccionada,
                          dropdownColor: const Color(0xFF162A35),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Categoría',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          items: categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                categoriaSeleccionada = val;
                              });
                            }
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: estadoSeleccionado,
                          dropdownColor: const Color(0xFF162A35),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Estado físico',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          items: ['Bueno', 'Regular', 'Malo']
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
                        TextFormField(
                          controller: ubicacionController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Ubicación física',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: fechaController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Fecha de Adquisición (AAAA-MM-DD)',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? fecha = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2030),
                            );
                            if (fecha != null) {
                              fechaController.text = fecha.toString().substring(0, 10);
                            }
                          },
                          validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
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
                    final nuevoItem = Inventario(
                      id: item?.id,
                      nombre: nombreController.text.trim(),
                      cantidad: int.parse(cantidadController.text),
                      categoria: categoriaSeleccionada,
                      estado: estadoSeleccionado,
                      fechaAdquisicion: fechaController.text,
                      ubicacion: ubicacionController.text.trim(),
                    );

                    bool res;
                    if (isEdit) {
                      res = await labProvider.actualizarInventario(nuevoItem);
                    } else {
                      res = await labProvider.agregarInventario(nuevoItem);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res ? 'Guardado exitosamente' : 'Error al guardar'),
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

  // Confirmar eliminación del artículo del inventario
  void _confirmarEliminar(BuildContext context, Inventario item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF162A35),
          title: const Text('Confirmar Eliminación', style: TextStyle(color: Colors.white)),
          content: Text('¿Desea eliminar permanentemente el artículo "${item.nombre}"?', style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                final labProvider = Provider.of<LabProvider>(context, listen: false);
                await labProvider.eliminarInventario(item.id!);
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

    // Filtrar inventario por término de búsqueda y categoría
    final inventarioFiltrado = labProvider.inventario.where((item) {
      final cumpleBusqueda = item.nombre.toLowerCase().contains(_busqueda.toLowerCase()) ||
          item.categoria.toLowerCase().contains(_busqueda.toLowerCase()) ||
          item.ubicacion.toLowerCase().contains(_busqueda.toLowerCase());
      
      final cumpleCategoria = _filtroCategoria == 'Todos' || item.categoria == _filtroCategoria;
      return cumpleBusqueda && cumpleCategoria;
    }).toList();

    final categoriasDisponibles = [
      'Todos', 'Mouse', 'Teclado', 'Monitor', 'Switch', 'Router', 'Impresora', 'Proyector', 'Cable', 'Otros'
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text('Inventario Tecnológico', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F2027),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF00FF87)),
            onPressed: () => _mostrarFormularioInventario(context),
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
                      hintText: 'Buscar en el inventario...',
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
                  value: _filtroCategoria,
                  dropdownColor: const Color(0xFF162A35),
                  style: const TextStyle(color: Colors.white),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.filter_alt_outlined, color: Color(0xFF00FF87)),
                  items: categoriasDisponibles
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _filtroCategoria = val;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          
          // LISTA DE ARTÍCULOS
          Expanded(
            child: inventarioFiltrado.isEmpty
                ? const Center(child: Text('No hay elementos registrados.', style: TextStyle(color: Colors.white60)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: inventarioFiltrado.length,
                    itemBuilder: (context, index) {
                      final item = inventarioFiltrado[index];
                      Color estadoColor = Colors.green;
                      if (item.estado == 'Regular') {
                        estadoColor = Colors.orange;
                      } else if (item.estado == 'Malo') {
                        estadoColor = Colors.redAccent;
                      }

                      return Card(
                        color: const Color(0xFF1E3C48),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF00B4DB).withOpacity(0.1),
                            child: Icon(Icons.inventory_2_outlined, color: const Color(0xFF00B4DB)),
                          ),
                          title: Text(
                            item.nombre,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Cant: ${item.cantidad} • Cat: ${item.categoria} • Ubic: ${item.ubicacion}',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Text('Estado: ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  Text(
                                    item.estado,
                                    style: TextStyle(color: estadoColor, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF00B4DB), size: 20),
                                onPressed: () => _mostrarFormularioInventario(context, item: item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => _confirmarEliminar(context, item),
                              ),
                            ],
                          ),
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
