import 'package:flutter/material.dart';
import 'package:gestionvc_ui/clientes_page.dart';
import 'package:gestionvc_ui/vendedores_page.dart';
import 'home_page.dart';
import 'ventas_page.dart';
import 'productos_page.dart';
import 'zonas_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Ventas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => HomePage(), // Ruta para la página de inicio
        '/ventas': (context) => VentasPage(), // Ruta para la página de ventas
        '/clientes': (context) => ClientesPage(),
        '/productos': (context) => ProductosPage(),
        '/zonas': (context) => ZonasPage(),
        '/vendedores': (context) => VendedoresPage(),
        //Falta Ruta de Detalle_Ventas y falta consumir las API para 
// las consultas 
      },
    );
  }
}
