import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Producto {
  int id;
  String nombre;
  String descripcion;
  double precio;
  int stock;
  String categoria;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.categoria,
  });

  set setId(int newId) {
    id = newId;
  }

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['idProducto'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'].toDouble(),
      stock: json['stock'],
      categoria: json['categoria'],
    );
  }
}

class ProductosPage extends StatefulWidget {
  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  List<Producto> productos = [];
  bool isLoading = true;
  int itemsPerPage = 6;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchProductos();
  }

  Future<void> _fetchProductos() async {
    try {
      String apiUrl = 'http://localhost:5000/api/Producto/listarProductos';
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          productos =
              data.map((producto) => Producto.fromJson(producto)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (e) {
      print('Error al cargar los productos: $e');
    }
  }

  List<Producto> getProductosPaginados() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;
    return productos.sublist(startIndex,
        endIndex < productos.length ? endIndex : productos.length);
  }

  Future<void> _crearProducto(Producto nuevoProducto) async {
    try {
      String apiUrl = 'http://localhost:5000/api/Producto/crearProducto';
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'idProducto': nuevoProducto.id,
          'nombre': nuevoProducto.nombre,
          'descripcion': nuevoProducto.descripcion,
          'precio': nuevoProducto.precio,
          'stock': nuevoProducto.stock,
          'categoria': nuevoProducto.categoria,
        }),
      );

      if (response.statusCode == 201) {
        print('Producto creado exitosamente');
        await _fetchProductos();
      } else {
        throw Exception('Error al crear el producto: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al crear el producto: $e');
    }
  }

  Future<void> _modificarProducto(Producto productoModificado) async {
    try {
      String apiUrl =
          'http://localhost:5000/api/Producto/editarPro?id=${productoModificado.id}';
      http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nombre': productoModificado.nombre,
          'descripcion': productoModificado.descripcion,
          'precio': productoModificado.precio,
          'stock': productoModificado.stock,
          'categoria': productoModificado.categoria,
        }),
      );

      if (response.statusCode == 200) {
        print('Producto modificado exitosamente');
        await _fetchProductos();
      } else {
        throw Exception(
            'Error al modificar el producto: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al modificar el producto: $e');
    }
  }

  Future<void> _eliminarProducto(int idProducto) async {
    try {
      String apiUrl =
          'http://localhost:5000/api/Producto/eliminarPro?id=$idProducto';
      http.Response response = await http.delete(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        print('Producto eliminado exitosamente');
        await _fetchProductos();
      } else {
        throw Exception('Error al eliminar el producto: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar el producto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productos.isEmpty
              ? Center(
                  child: Text('No se encontraron productos'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: getProductosPaginados().length,
                        itemBuilder: (BuildContext context, int index) {
                          Producto producto = getProductosPaginados()[index];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(producto.nombre),
                              subtitle: Text(producto.descripcion),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () =>
                                        _mostrarFormularioEditar(
                                            context, producto),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        _eliminarProducto(producto.id),
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
                                productos.length) {
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
        tooltip: 'Agregar Producto',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _mostrarFormularioAgregar(BuildContext context) async {
    Producto nuevoProducto = Producto(
        id: 0, nombre: '', descripcion: '', precio: 0, stock: 0, categoria: '');
    final Producto productoCreado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Producto'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ID'),
                    onChanged: (value) {
                      nuevoProducto.setId = int.parse(value);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      nuevoProducto.nombre = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descripción'),
                    onChanged: (value) {
                      nuevoProducto.descripcion = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Precio'),
                    onChanged: (value) {
                      nuevoProducto.precio = double.parse(value);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Stock'),
                    onChanged: (value) {
                      nuevoProducto.stock = int.parse(value);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Categoría'),
                    onChanged: (value) {
                      nuevoProducto.categoria = value;
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
                Navigator.of(context).pop(nuevoProducto); // Guardar los cambios
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (productoCreado != null) {
      await _crearProducto(productoCreado);
      await _fetchProductos();
    }
  }

  Future<void> _mostrarFormularioEditar(
      BuildContext context, Producto producto) async {
    final Producto productoModificado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Producto'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    initialValue: producto.nombre,
                    onChanged: (value) {
                      producto.nombre = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descripción'),
                    initialValue: producto.descripcion,
                    onChanged: (value) {
                      producto.descripcion = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Precio'),
                    initialValue: producto.precio.toString(),
                    onChanged: (value) {
                      producto.precio = double.parse(value);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Stock'),
                    initialValue: producto.stock.toString(),
                    onChanged: (value) {
                      producto.stock = int.parse(value);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Categoría'),
                    initialValue: producto.categoria,
                    onChanged: (value) {
                      producto.categoria = value;
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
                Navigator.of(context).pop(producto); // Guardar los cambios
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (productoModificado != null) {
      await _modificarProducto(productoModificado);
    }
  }
}
