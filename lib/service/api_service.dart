import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:joven/config/url.dart';
import 'package:joven/utils/log.dart';

class ApiService {
  // Base URL of the API
  final String _baseUrl = Url.BASE_URL;

  // Singleton pattern: private constructor and static instance
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  // Method for GET requests
  Future<dynamic> getRequest(
    String endpoint, {
    String? token,
  }) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    if (token != null) headers["Authorization"] = "Bearer $token";
    final response = await http.get(
      Uri.parse("$_baseUrl$endpoint"),
      headers: headers,
    );
    return _processResponse(response);
  }

  // Method for POST requests
  Future<dynamic> postRequest(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    if (token != null) headers["Authorization"] = "Bearer $token";
    final response = await http.post(
      Uri.parse("$_baseUrl$endpoint"),
      headers: headers,
      body: jsonEncode(data),
    );
    return _processResponse(response);
  }

  // Method for PUT requests
  Future<dynamic> putRequest(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$_baseUrl$endpoint"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return _processResponse(response);
  }

  // Method for DELETE requests
  Future<dynamic> deleteRequest(String endpoint) async {
    final response = await http.delete(Uri.parse("$_baseUrl$endpoint"));
    return _processResponse(response);
  }

  // Private method to process the response
  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    Log.d("Response: ${response.body}");
    if (statusCode >= 200 && statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error: ${response.statusCode} ${response.reasonPhrase}");
    }
  }
}
