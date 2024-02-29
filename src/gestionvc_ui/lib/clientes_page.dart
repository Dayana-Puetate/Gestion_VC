import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cliente {
  int id;
  String nombre;
  String email;
  String telefono;
  String direccion;

  Cliente({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.direccion,
  });

  set setId(int newId) {
    id = newId;
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['idCliente'],
      nombre: json['nombre'],
      email: json['email'],
      telefono: json['telefono'],
      direccion: json['direccion'],
    );
  }
}

class ClientesPage extends StatefulWidget {
  @override
  _ClientesPageState createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<Cliente> clientes = [];
  bool isLoading = true;
  int itemsPerPage = 6;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchClientes();
  }

  Future<void> _fetchClientes() async {
    try {
      String apiUrl =
          'http://localhost:5000/api/Cliente/listarClientes'; // Reemplaza con la URL de tu API local
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          clientes = data.map((cliente) => Cliente.fromJson(cliente)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar los clientes');
      }
    } catch (e) {
      print('Error al cargar los clientes: $e');
    }
  }

  List<Cliente> getClientesPaginados() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;
    return clientes.sublist(startIndex,
        endIndex < clientes.length ? endIndex : clientes.length);
  }

  Future<void> _crearCliente(Cliente nuevoCliente) async {
    try {
      String apiUrl =
          'http://localhost:5000/api/Cliente/crearCliente'; // Reemplaza con la URL de tu API local
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'idCliente': nuevoCliente.id,
          'nombre': nuevoCliente.nombre,
          'email': nuevoCliente.email,
          'telefono': nuevoCliente.telefono,
          'direccion': nuevoCliente.direccion,
        }),
      );

      if (response.statusCode == 201) {
        // Cliente creado exitosamente
        print('Cliente creado exitosamente');
        // Actualizar la lista de clientes después de crear uno
        await _fetchClientes();
      } else {
        // Error al crear el cliente
        throw Exception('Error al crear el cliente: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al crear el cliente: $e');
    }
  }

  Future<void> _modificarCliente(Cliente clienteModificado) async {
    try {
      String apiUrl =
          'http://localhost:5000/api/Cliente/editarCli?id=${clienteModificado.id}'; // Reemplaza con la URL de tu API local
      http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nombre': clienteModificado.nombre,
          'email': clienteModificado.email,
          'telefono': clienteModificado.telefono,
          'direccion': clienteModificado.direccion,
        }),
      );

      if (response.statusCode == 200) {
        // Cliente modificado exitosamente
        print('Cliente modificado exitosamente');
        // Actualizar la lista de clientes después de modificar uno
        await _fetchClientes();
      } else {
        // Error al modificar el cliente
        throw Exception(
            'Error al modificar el cliente: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al modificar el cliente: $e');
    }
  }

  Future<void> _eliminarCliente(int idCliente) async {
    try {
      String apiUrl =
          'http://localhost:5000/api/Cliente/eliminarCli?id=$idCliente'; // Reemplaza con la URL de tu API local
      http.Response response = await http.delete(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        // Cliente eliminado exitosamente
        print('Cliente eliminado exitosamente');
        // Actualizar la lista de clientes después de eliminar uno
        await _fetchClientes();
      } else {
        // Error al eliminar el cliente
        throw Exception('Error al eliminar el cliente: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar el cliente: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : clientes.isEmpty
              ? Center(
                  child: Text('No se encontraron clientes'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: getClientesPaginados().length,
                        itemBuilder: (BuildContext context, int index) {
                          Cliente cliente = getClientesPaginados()[index];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(cliente.nombre),
                              subtitle: Text(cliente.email),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () =>
                                        _mostrarFormularioEditar(
                                            context, cliente),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        _eliminarCliente(cliente.id),
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
                            if ((currentPage + 1) *
                                    itemsPerPage <
                                clientes.length) {
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
        tooltip: 'Agregar Cliente',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _mostrarFormularioAgregar(BuildContext context) async {
    Cliente nuevoCliente =
        Cliente(id: 0, nombre: '', email: '', telefono: '', direccion: '');
    final Cliente clienteCreado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Cliente'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ID'),
                    onChanged: (value) {
                      nuevoCliente.setId = int.parse(value);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      nuevoCliente.nombre = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    onChanged: (value) {
                      nuevoCliente.email = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Teléfono'),
                    onChanged: (value) {
                      nuevoCliente.telefono = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Dirección'),
                    onChanged: (value) {
                      nuevoCliente.direccion = value;
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
                Navigator.of(context).pop(nuevoCliente); // Guardar los cambios
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (clienteCreado != null) {
      // Crear el cliente en el servidor
      await _crearCliente(clienteCreado);
      await _fetchClientes();
    }
  }

  Future<void> _mostrarFormularioEditar(
      BuildContext context, Cliente cliente) async {
    final Cliente clienteModificado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Cliente'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    initialValue: cliente.nombre,
                    onChanged: (value) {
                      cliente.nombre = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    initialValue: cliente.email,
                    onChanged: (value) {
                      cliente.email = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Teléfono'),
                    initialValue: cliente.telefono,
                    onChanged: (value) {
                      cliente.telefono = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Dirección'),
                    initialValue: cliente.direccion,
                    onChanged: (value) {
                      cliente.direccion = value;
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
                Navigator.of(context).pop(cliente); // Guardar los cambios
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (clienteModificado != null) {
      // Modificar el cliente en el servidor
      await _modificarCliente(clienteModificado);
    }
  }
}
