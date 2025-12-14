import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Automatically determine the correct base URL based on the platform
  String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api/auth';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android emulator uses 10.0.2.2 to access the host's localhost
      return 'http://10.0.2.2:8080/api/auth';
    } else {
      // iOS simulator and desktop can use localhost
      return 'http://localhost:8080/api/auth';
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String timezone,
  }) async {
    final url = Uri.parse('$_baseUrl/register');
    
    debugPrint('Attempting to register at: $url');

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'timezone': timezone,
        }),
      );

      debugPrint('Response status: ${res.statusCode}');
      debugPrint('Response body: ${res.body}');

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception('Register failed (${res.statusCode}): ${res.body}');
      }
    } catch (e) {
      debugPrint('Error caught in AuthService: $e');
      rethrow; // Pass the error back to the UI
    }
  }
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/login');
    
    debugPrint('Attempting to login at: $url');

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      debugPrint('Response status: ${res.statusCode}');
      debugPrint('Response body: ${res.body}');

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception('Login failed (${res.statusCode}): ${res.body}');
      }
    } catch (e) {
      debugPrint('Error caught in AuthService: $e');
      rethrow;
    }
  }
}
