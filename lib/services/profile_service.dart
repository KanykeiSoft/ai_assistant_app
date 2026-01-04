import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ProfileService {
  final AuthService _auth;

  ProfileService(this._auth);

  String get _hostBase {
    if (kIsWeb) return 'http://localhost:8080';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080';
  }

  Uri _uri(String path) => Uri.parse('$_hostBase$path');

  Future<Map<String, String>> _headers() async {
    final token = await _auth.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No token. Please login first.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Возвращает null если профиля нет (404)
  Future<Map<String, dynamic>?> getMe() async {
    final res = await http.get(_uri('/api/profile/me'), headers: await _headers());

    if (res.statusCode == 404) return null;

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Get profile failed (${res.statusCode}): ${res.body}');
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createOrUpdate({
    required int age,
    required String goal,
    required String assistantStyle,
    required int sleepHours,
  }) async {
    final res = await http.post(
      _uri('/api/profile'),
      headers: await _headers(),
      body: jsonEncode({
        'age': age,
        'goal': goal,
        'assistantStyle': assistantStyle,
        'sleepHours': sleepHours,
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Save profile failed (${res.statusCode}): ${res.body}');
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}

