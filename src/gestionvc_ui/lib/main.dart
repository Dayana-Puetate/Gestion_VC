import 'package:flutter/material.dart';
import 'package:gestionvc_ui/clientes_page.dart';
import 'package:gestionvc_ui/vendedores_page.dart';
import 'home_page.dart';
import 'ventas_page.dart';
import 'productos_page.dart';
import 'zonas_page.dart'; // Importa la página de ventas que creaste

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nombre de tu Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Ruta inicial (puedes cambiarla según necesites)
      routes: {
        '/': (context) => HomePage(), // Ruta para la página de inicio
        '/ventas': (context) => VentasPage(), // Ruta para la página de ventas
        '/clientes': (context) => ClientesPage(),
        '/productos': (context) => ProductosPage(),
        '/zonas': (context) => ZonasPage(),
        '/vendedores': (context) => VendedoresPage(),
        // Puedes agregar más rutas según lo necesites
      },
    );
  }
}
