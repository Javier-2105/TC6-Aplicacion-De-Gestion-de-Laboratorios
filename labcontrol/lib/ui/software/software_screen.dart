//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lab_provider.dart';
import '../../data/models/software.dart';

// Pantalla para la gestión del catálogo global de Software instalado o disponible
class SoftwareScreen extends StatefulWidget {
  const SoftwareScreen({super.key});

  @override
  State<SoftwareScreen> createState() => _SoftwareScreenState();
}

class _SoftwareScreenState extends State<SoftwareScreen> {
  String _busqueda = '';
  String _filtroCategoria = 'Todos';

  // Mostrar formulario de Software
  void _mostrarFormularioSoftware(BuildContext context, {Software? sw}) {
    final isEdit = sw != null;
    final formKey = GlobalKey<FormState>();

    final nombreController = TextEditingController(text: isEdit ? sw.nombre : '');
    final versionController = TextEditingController(text: isEdit ? sw.version : '');
    String categoriaSeleccionada = isEdit ? sw.categoria : 'Desarrollo';

    final categorias = ['Sistema', 'Desarrollo', 'Navegador', 'Ofimática', 'Utilidades', 'Otros'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF162A35),
              title: Text(
                isEdit ? 'Editar Software' : 'Registrar Software',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nombreController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nombre del Programa',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                      ),
                      TextFormField(
                        controller: versionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Versión (Ej: 1.0.2)',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        validator: (value) => value!.trim().isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 10),
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
                    ],
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
                    final nuevoSoftware = Software(
                      id: sw?.id,
                      nombre: nombreController.text.trim(),
                      version: versionController.text.trim(),
                      categoria: categoriaSeleccionada,
                    );

                    bool res;
                    if (isEdit) {
                      res = await labProvider.actualizarSoftware(nuevoSoftware);
                    } else {
                      res = await labProvider.agregarSoftware(nuevoSoftware);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res ? 'Software guardado exitosamente' : 'Error al guardar'),
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

  // Confirmar eliminación del software
  void _confirmarEliminar(BuildContext context, Software sw) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF162A35),
          title: const Text('Eliminar Software', style: TextStyle(color: Colors.white)),
          content: Text('¿Desea eliminar permanentemente "${sw.nombre}" del catálogo?', style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                final labProvider = Provider.of<LabProvider>(context, listen: false);
                await labProvider.eliminarSoftware(sw.id!);
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

    final softwareFiltrado = labProvider.software.where((sw) {
      final cumpleBusqueda = sw.nombre.toLowerCase().contains(_busqueda.toLowerCase()) ||
          sw.categoria.toLowerCase().contains(_busqueda.toLowerCase());
      
      final cumpleCategoria = _filtroCategoria == 'Todos' || sw.categoria == _filtroCategoria;
      return cumpleBusqueda && cumpleCategoria;
    }).toList();

    final categoriasMenu = ['Todos', 'Sistema', 'Desarrollo', 'Navegador', 'Ofimática', 'Utilidades', 'Otros'];

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text('Catálogo de Software', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F2027),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF00FF87)),
            onPressed: () => _mostrarFormularioSoftware(context),
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
                      hintText: 'Buscar programas o extensiones...',
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
                  icon: const Icon(Icons.category, color: Color(0xFF00FF87)),
                  items: categoriasMenu
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
          
          // LISTA DE SOFTWARE
          Expanded(
            child: softwareFiltrado.isEmpty
                ? const Center(child: Text('No hay software registrado.', style: TextStyle(color: Colors.white60)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: softwareFiltrado.length,
                    itemBuilder: (context, index) {
                      final sw = softwareFiltrado[index];

                      return Card(
                        color: const Color(0xFF1E3C48),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF00FF87).withOpacity(0.1),
                            child: const Icon(Icons.code_rounded, color: Color(0xFF00FF87)),
                          ),
                          title: Text(
                            sw.nombre,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Versión: ${sw.version} • Categoría: ${sw.categoria}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF00B4DB), size: 20),
                                onPressed: () => _mostrarFormularioSoftware(context, sw: sw),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => _confirmarEliminar(context, sw),
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
