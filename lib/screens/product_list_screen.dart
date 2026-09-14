import 'dart:async';

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _productService = ProductService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Timer? _searchDebounce;

  List<Product> _products = [];

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  String? _errorMessage;

  int _skip = 0;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();

    _loadProducts();

    _scrollController.addListener(_onScroll);
  }

  void _onSearchChanged(String query) {
  _searchDebounce?.cancel();

  _searchDebounce = Timer(
    const Duration(milliseconds: 500),
    () {
      if (query.trim().isEmpty) {
        _loadProducts();
      } else {
        _searchProducts(query.trim());
      }
    },
  );
}

  Future<void> _searchProducts(String query) async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    final products = await _productService.searchProducts(query);

    setState(() {
      _products = products;
      _isLoading = false;
      _hasMore = false;
    });
  } catch (e) {
    setState(() {
      _errorMessage = 'Failed to search products';
      _isLoading = false;
    });
  }
}

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _skip = 0;
      _hasMore = true;
    });

    try {
      final products = await _productService.getProducts(
        skip: _skip,
        limit: _limit,
      );

      setState(() {
        _products = products;
        _isLoading = false;
        _skip += products.length;

        if (products.length < _limit) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final products = await _productService.getProducts(
        skip: _skip,
        limit: _limit,
      );

      setState(() {
        _products.addAll(products);
        _skip += products.length;
        _isLoadingMore = false;

        if (products.length < _limit) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

 @override
void dispose() {
  _scrollController.dispose();
  _searchController.dispose();
  _searchDebounce?.cancel();
  super.dispose();
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Product Catalog'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _loadProducts();
                },
              ),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
    ),
    body: _buildBody(),
  );
}

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(
        child: Text('No products found'),
      );
    }

    return RefreshIndicator(
  onRefresh: _loadProducts,
  child: ListView.builder(
    controller: _scrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: _products.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _products.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final product = _products[index];

        return ListTile(
  leading: Image.network(
  product.thumbnail,
  width: 70,
  height: 70,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }

    return const SizedBox(
      width: 70,
      height: 70,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return const SizedBox(
      width: 70,
      height: 70,
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey,
      ),
    );
  },
),
  title: Text(product.title),
  subtitle: Text(
    '\$${product.price.toStringAsFixed(2)}',
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
        ),
      ),
    );
  },
);
            },
    ),
  );
  }
}