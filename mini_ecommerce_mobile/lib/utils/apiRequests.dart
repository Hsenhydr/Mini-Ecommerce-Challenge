import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiRequests {
  // Networking ✔️ as mentioned in task (used http package)
  static String baseUrl = '${dotenv.env['API_BASE']}';

  static Future<http.Response> post(String path, dynamic body,
      {String? token}) {
    final uri = Uri.parse(baseUrl + path);
    final headers = {'Content-Type': 'application/json'};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return http.post(uri, headers: headers, body: jsonEncode(body));
  }

  static Future<http.Response> get(String path, {String? token}) {
    final uri = Uri.parse(baseUrl + path);
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return http.get(uri, headers: headers);
  }
}
