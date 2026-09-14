import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  final String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> getProducts({
    required int skip,
    int limit = 20,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List products = data['products'];

      return products.map((item) {
        return Product(
          id: item['id'],
          title: item['title'],
          description: item['description'],
          price: (item['price'] as num).toDouble(),
          rating: (item['rating'] as num).toDouble(),
          thumbnail: item['thumbnail'],
          images: List<String>.from(item['images']),
        );
      }).toList();
        } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/search?q=$query'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List products = data['products'];

      return products.map((item) {
        return Product(
          id: item['id'],
          title: item['title'],
          description: item['description'],
          price: (item['price'] as num).toDouble(),
          rating: (item['rating'] as num).toDouble(),
          thumbnail: item['thumbnail'],
          images: List<String>.from(item['images']),
        );
      }).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }
}