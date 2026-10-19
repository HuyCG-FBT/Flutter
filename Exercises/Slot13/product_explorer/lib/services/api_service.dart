import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = "https://fakestoreapi.com/products";

  static Future<List<Product>> fetchProducts({http.Client? client}) async {
    final httpClient = client ?? http.Client();
    try {
      final response = await httpClient.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body) as List;
        return data
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Failed to load products (status: ${response.statusCode})");
      }
    } finally {
      if (client == null) httpClient.close();
    }
  }

  static Future<Product> fetchProductById(int id, {http.Client? client}) async {
    final httpClient = client ?? http.Client();
    try {
      final response = await httpClient.get(Uri.parse("$baseUrl/$id"));
      if (response.statusCode == 200) {
        return Product.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception("Failed to load product detail (status: ${response.statusCode})");
      }
    } finally {
      if (client == null) httpClient.close();
    }
  }
}
