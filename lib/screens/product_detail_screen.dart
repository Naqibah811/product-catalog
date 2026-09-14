import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
             child: Image.network(
  product.thumbnail,
  fit: BoxFit.contain,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return const Center(
      child: Icon(
        Icons.image_not_supported,
        size: 60,
        color: Colors.grey,
      ),
    );
  },
),
            ),

            const SizedBox(height: 20),

            Text(
              product.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                const SizedBox(width: 5),
                Text(
                  product.rating.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Product Images',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Image.network(
  product.images[index],
  width: 120,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }

    return const SizedBox(
      width: 120,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return const SizedBox(
      width: 120,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
        ),
      ),
    );
  },
),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}