import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Zona {
  int id;
  String nombre;
  String descripcion;

  Zona({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  set setId(int newId) {
    id = newId;
  }

  factory Zona.fromJson(Map<String, dynamic> json) {
    return Zona(
      id: json['idZona'],
      nombre: json['nombreZona'],
      descripcion: json['descripcion'],
    );
  }
}

class ZonasPage extends StatefulWidget {
  @override
  _ZonasPageState createState() => _ZonasPageState();
}

class _ZonasPageState extends State<ZonasPage> {
  List<Zona> zonas = [];
  bool isLoading = true;
  int itemsPerPage = 6;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchZonas();
  }

  Future<void> _fetchZonas() async {
    try {
      String apiUrl = 'http://localhost:5000/api/Zona/listarZonas';
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          zonas = data.map((zona) => Zona.fromJson(zona)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar las zonas');
      }
    } catch (e) {
      print('Error al cargar las zonas: $e');
    }
  }

  List<Zona> getZonasPaginadas() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;
    return zonas.sublist(startIndex,
        endIndex < zonas.length ? endIndex : zonas.length);
  }

  Future<void> _crearZona(Zona nuevaZona) async {
    try {
      String apiUrl = 'http://localhost:5000/api/Zona/crearZona';
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'idZona': nuevaZona.id,
          'nombreZona': nuevaZona.nombre,
          'descripcion': nuevaZona.descripcion,
        }),
      );

      if (response.statusCode == 201) {
        print('Zona creada exitosamente');
        await _fetchZonas();
      } else {
        throw Exception('Error al crear la zona: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al crear la zona: $e');
    }
  }

  Future<void> _modificarZona(Zona zonaModificada) async {
    try {
      String apiUrl =
          'http://localhost:5000/api/Zona/editarZona?id=${zonaModificada.id}';
      http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nombreZona': zonaModificada.nombre,
          'descripcion': zonaModificada.descripcion,
        }),
      );

      if (response.statusCode == 200) {
        print('Zona modificada exitosamente');
        await _fetchZonas();
      } else {
        throw Exception(
            'Error al modificar la zona: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al modificar la zona: $e');
    }
  }

  Future<void> _eliminarZona(int idZona) async {
    try {
      String apiUrl =
          'http://localhost:5000/api/Zona/eliminarZona?id=$idZona';
      http.Response response = await http.delete(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        print('Zona eliminada exitosamente');
        await _fetchZonas();
      } else {
        throw Exception('Error al eliminar la zona: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar la zona: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zonas'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : zonas.isEmpty
              ? Center(
                  child: Text('No se encontraron zonas'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: getZonasPaginadas().length,
                        itemBuilder: (BuildContext context, int index) {
                          Zona zona = getZonasPaginadas()[index];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(zona.nombre),
                              subtitle: Text(zona.descripcion),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () =>
                                        _mostrarFormularioEditar(context, zona),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => _eliminarZona(zona.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            if (currentPage > 0) {
                              setState(() {
                                currentPage--;
                              });
                            }
                          },
                        ),
                        Text(
                          'Página ${currentPage + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            if ((currentPage + 1) * itemsPerPage <
                                zonas.length) {
                              setState(() {
                                currentPage++;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioAgregar(context),
        tooltip: 'Agregar Zona',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _mostrarFormularioAgregar(BuildContext context) async {
    Zona nuevaZona = Zona(id: 0, nombre: '', descripcion: '');
    final Zona zonaCreada = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Zona'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ID'),
                    onChanged: (value) {
                      nuevaZona.setId = int.parse(value);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      nuevaZona.nombre = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descripción'),
                    onChanged: (value) {
                      nuevaZona.descripcion = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancelar
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(nuevaZona); // Guardar los cambios
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (zonaCreada != null) {
      await _crearZona(zonaCreada);
      await _fetchZonas();
    }
  }

  Future<void> _mostrarFormularioEditar(BuildContext context, Zona zona) async {
    final Zona zonaModificada = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Zona'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    initialValue: zona.nombre,
                    onChanged: (value) {
                      zona.nombre = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descripción'),
                    initialValue: zona.descripcion,
                    onChanged: (value) {
                      zona.descripcion = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancelar
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(zona); // Guardar los cambios
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (zonaModificada != null) {
      await _modificarZona(zonaModificada);
    }
  }
}
