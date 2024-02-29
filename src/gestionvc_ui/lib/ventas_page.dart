import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Venta {
  int idVenta;
  int idCliente;
  int idVendedor;
  int idZona;
  DateTime fecha;
  double montoTotal;

  Venta({
    required this.idVenta,
    required this.idCliente,
    required this.idVendedor,
    required this.idZona,
    required this.fecha,
    required this.montoTotal,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['idVenta'],
      idCliente: json['idCliente'],
      idVendedor: json['idVendedor'],
      idZona: json['idZona'],
      fecha: DateTime.parse(json['fecha']),
      montoTotal: json['montoTotal'].toDouble(),
    );
  }
}

class VentasPage extends StatefulWidget {
  @override
  _VentasPageState createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {
  List<Venta> ventas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVentas();
  }

  Future<void> _fetchVentas() async {
    try {
      String apiUrl = 'http://localhost:5000/api/Venta/listarVentas';
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          ventas = data.map((venta) => Venta.fromJson(venta)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar las ventas');
      }
    } catch (e) {
      print('Error al cargar las ventas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ventas.isEmpty
              ? Center(
                  child: Text('No se encontraron ventas'),
                )
              : ListView.builder(
                  itemCount: ventas.length,
                  itemBuilder: (BuildContext context, int index) {
                    Venta venta = ventas[index];
                    return ListTile(
                      title: Text('Venta #${venta.idVenta}'),
                      subtitle: Text('Cliente: ${venta.idCliente}, Vendedor: ${venta.idVendedor}, Zona: ${venta.idZona}, Fecha: ${venta.fecha}, Monto Total: ${venta.montoTotal}'),
                    );
                  },
                ),
    );
  }
}
