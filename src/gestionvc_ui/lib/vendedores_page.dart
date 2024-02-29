import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Vendedor {
  int id;
  String nombre;
  String apellido;
  String email;
  String direccion;

  Vendedor({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.direccion,
  });

  set setId(int newId) {
    id = newId;
  }

  factory Vendedor.fromJson(Map<String, dynamic> json) {
    return Vendedor(
      id: json['idVendedor'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      direccion: json['direccion'],
    );
  }
}

class VendedoresPage extends StatefulWidget {
  @override
  _VendedoresPageState createState() => _VendedoresPageState();
}

class _VendedoresPageState extends State<VendedoresPage> {
  List<Vendedor> vendedores = [];
  bool isLoading = true;
  int itemsPerPage = 6;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchVendedores();
  }

  Future<void> _fetchVendedores() async {
    try {
      String apiUrl = 'http://localhost:5000/api/Vendedor/listarVendedores';
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          vendedores =
              data.map((vendedor) => Vendedor.fromJson(vendedor)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar los vendedores');
      }
    } catch (e) {
      print('Error al cargar los vendedores: $e');
    }
  }

  List<Vendedor> getVendedoresPaginados() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;
    return vendedores.sublist(startIndex,
        endIndex < vendedores.length ? endIndex : vendedores.length);
  }

  Future<void> _crearVendedor(Vendedor nuevoVendedor) async {
    try {
      String apiUrl = 'http://localhost:5000/api/Vendedor/crearVendedor';
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'idVendedor': nuevoVendedor.id,
          'nombre': nuevoVendedor.nombre,
          'apellido': nuevoVendedor.apellido,
          'email': nuevoVendedor.email,
          'direccion': nuevoVendedor.direccion,
        }),
      );

      if (response.statusCode == 201) {
        print('Vendedor creado exitosamente');
        await _fetchVendedores();
      } else {
        throw Exception('Error al crear el vendedor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al crear el vendedor: $e');
    }
  }

  Future<void> _modificarVendedor(Vendedor vendedorModificado) async {
    try {
      String apiUrl =
          'http://localhost:5000/api/Vendedor/editarVendedor?id=${vendedorModificado.id}';
      http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nombre': vendedorModificado.nombre,
          'apellido': vendedorModificado.apellido,
          'email': vendedorModificado.email,
          'direccion': vendedorModificado.direccion,
        }),
      );

      if (response.statusCode == 200) {
        print('Vendedor modificado exitosamente');
        await _fetchVendedores();
      } else {
        throw Exception(
            'Error al modificar el vendedor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al modificar el vendedor: $e');
    }
  }

  Future<void> _eliminarVendedor(int idVendedor) async {
    try {
      String apiUrl =
          'http://localhost:5000/api/Vendedor/eliminarVendedor?id=$idVendedor';
      http.Response response = await http.delete(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        print('Vendedor eliminado exitosamente');
        await _fetchVendedores();
      } else {
        throw Exception('Error al eliminar el vendedor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar el vendedor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendedores'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : vendedores.isEmpty
              ? Center(
                  child: Text('No se encontraron vendedores'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: getVendedoresPaginados().length,
                        itemBuilder: (BuildContext context, int index) {
                          Vendedor vendedor = getVendedoresPaginados()[index];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text('${vendedor.nombre} ${vendedor.apellido}'),
                              subtitle: Text(vendedor.email),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () =>
                                        _mostrarFormularioEditar(context, vendedor),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => _eliminarVendedor(vendedor.id),
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
                                vendedores.length) {
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
        tooltip: 'Agregar Vendedor',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _mostrarFormularioAgregar(BuildContext context) async {
    Vendedor nuevoVendedor = Vendedor(id: 0, nombre: '', apellido: '', email: '', direccion: '');
    final Vendedor vendedorCreado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Vendedor'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ID'),
                    onChanged: (value) {
                      nuevoVendedor.setId = int.parse(value);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      nuevoVendedor.nombre = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Apellido'),
                    onChanged: (value) {
                      nuevoVendedor.apellido = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    onChanged: (value) {
                      nuevoVendedor.email = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Dirección'),
                    onChanged: (value) {
                      nuevoVendedor.direccion = value;
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
                Navigator.of(context).pop(nuevoVendedor); // Guardar los cambios
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (vendedorCreado != null) {
      await _crearVendedor(vendedorCreado);
      await _fetchVendedores();
    }
  }

  Future<void> _mostrarFormularioEditar(BuildContext context, Vendedor vendedor) async {
    final Vendedor vendedorModificado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Vendedor'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    initialValue: vendedor.nombre,
                    onChanged: (value) {
                      vendedor.nombre = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Apellido'),
                    initialValue: vendedor.apellido,
                    onChanged: (value) {
                      vendedor.apellido = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    initialValue: vendedor.email,
                    onChanged: (value) {
                      vendedor.email = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Dirección'),
                    initialValue: vendedor.direccion,
                    onChanged: (value) {
                      vendedor.direccion = value;
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
                Navigator.of(context).pop(vendedor); // Guardar los cambios
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (vendedorModificado != null) {
      await _modificarVendedor(vendedorModificado);
    }
  }
}
