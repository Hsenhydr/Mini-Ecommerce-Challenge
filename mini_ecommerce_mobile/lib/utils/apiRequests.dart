import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiRequests {
  // Networking ✔️ as mentioned in task (used http package)
  static String baseUrl = 'http://10.0.2.2:8080';

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
