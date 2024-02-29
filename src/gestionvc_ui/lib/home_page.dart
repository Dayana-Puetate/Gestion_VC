import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'GESTIÓN DE VENTAS Y CLIENTES',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        padding: EdgeInsets.all(16.0),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: <Widget>[
          _buildAnimatedButton(
            context,
            'Ver Ventas',
            '/ventas',
          ),
          _buildAnimatedButton(
            context,
            'Ver Clientes',
            '/clientes',
          ),
          _buildAnimatedButton(
            context,
            'Ver Vendedores',
            '/vendedores',
          ),
          _buildAnimatedButton(
            context,
            'Ver Productos',
            '/productos',
          ),
          _buildAnimatedButton(
            context,
            'Ver Zonas',
            '/zonas',
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton(BuildContext context, String text, String route) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (_, double value, __) {
        return Transform.scale(
          scale: value,
          child: SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, route);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                elevation: MaterialStateProperty.all<double>(10.0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}

