# Product Catalog App

A Flutter product catalog application using the DummyJSON API.

## Features

- Display product list with title, thumbnail and price
- Pagination when scrolling
- Product detail screen
- Product description, price, rating and images
- Loading, error, retry and empty states
- Product search with debounce
- Image loading and error handling

## Unfinished Work

- Pull-to-refresh was attempted but not fully verified in the Chrome environment.
- Unit tests were not completed due to the assessment time limit.

## Technology Stack

- Flutter
- Dart
- DummyJSON REST API
- HTTP package

## API Endpoints

Product list:

https://dummyjson.com/products?limit=20&skip=0

Product detail:

https://dummyjson.com/products/{id}

Product search:

https://dummyjson.com/products/search?q=phone

## Project Structure

```text
lib
├── models
│   └── product.dart
├── services
│   └── product_service.dart
├── screens
│   ├── product_list_screen.dart
│   └── product_detail_screen.dart
└── main.dart