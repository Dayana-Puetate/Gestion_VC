import 'dart:convert';
import 'package:http/http.dart' as http;

class APIManager {
  static Future<List<dynamic>> getVentas() async {
    String apiUrl = 'http://localhost:5000/api/Cliente/listarClientes'; // Reemplaza con la URL de tu API local
    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error al cargar las ventas');
    }
  }
}
