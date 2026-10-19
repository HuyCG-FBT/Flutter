import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return "ApiException($statusCode): $message";
  }
}

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = baseUrl ?? "https://jsonplaceholder.typicode.com/users/1",
        _client = client ?? http.Client();

  Future<Profile> fetchProfile() async {
    final uri = Uri.parse(baseUrl);
    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));

      // ignore: avoid_print
      print("GET $uri -> ${response.statusCode}");
      // ignore: avoid_print
      print("Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        return Profile.fromJson(jsonMap);
      } else {
        throw ApiException("Failed to load profile", statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException("Network error: $e");
    }
  }

  Future<void> updateProfile(Profile profile) async {
    final uri = Uri.parse(baseUrl);
    try {
      final response = await _client.put(
        uri,
        body: jsonEncode(profile.toJson()),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      // ignore: avoid_print
      print("PUT $uri -> ${response.statusCode}");
      // ignore: avoid_print
      print("Body: ${response.body}");

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException("Failed to update profile", statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException("Network error: $e");
    }
  }
}
