import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GESTION DE VENTAS Y CLIENTES'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de ventas
                 Navigator.pushNamed(context, '/ventas');
              },
              child: Text('Ver Ventas'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de clientes
                 Navigator.pushNamed(context, '/clientes');
              },
              child: Text('Ver Clientes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de clientes
                 Navigator.pushNamed(context, '/productos');
              },
              child: Text('Ver Productos'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de clientes
                 Navigator.pushNamed(context, '/zonas');
              },
              child: Text('Ver Zonas'),
            ),
          ],
        ),
      ),
    );
  }
}
