import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String get _hostBase {
    if (kIsWeb) return 'http://localhost:8080';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080'; // iOS simulator
  }

  Uri _uri(String path) => Uri.parse('$_hostBase$path');

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String timezone,
  }) async {
    final res = await http.post(
      _uri('/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'timezone': timezone,
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Register failed (${res.statusCode}): ${res.body}');
    }

    // если backend сразу возвращает токен после регистрации — сохраним
    final body = res.body.trim();
    if (body.isNotEmpty) {
      try {
        final map = jsonDecode(body) as Map<String, dynamic>;
        final token = (map['token'] ?? map['accessToken'])?.toString();
        if (token != null && token.isNotEmpty) {
          await _saveToken(token);
        }
      } catch (_) {
        // ignore если там не json
      }
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      _uri('/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Login failed (${res.statusCode}): ${res.body}');
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final token = (map['token'] ?? map['accessToken'])?.toString();

    if (token == null || token.isEmpty) {
      throw Exception('Login ok but token missing in response: ${res.body}');
    }

    await _saveToken(token);
  }
}

