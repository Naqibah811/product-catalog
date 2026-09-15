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
- A more comprehensive unit test for API/data logic was not completed due to the assessment time limit.

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

## Architecture

The application is separated into three main parts:

- **Models** – Defines the Product data structure.
- **Services** – Handles API requests and converts API responses into Product objects.
- **Screens** – Contains the product list and product detail UI.

The `ProductService` keeps API logic separate from the UI, making the application easier to understand and maintain.

## Key Decisions

### Pagination

The product list uses the DummyJSON `limit` and `skip` parameters. More products are loaded when the user scrolls near the bottom of the list.

### Search

The DummyJSON search endpoint is used instead of filtering the complete product list locally. A 500ms debounce is applied so the API is not called for every character typed by the user.

## How to Run

1. Clone this repository.
2. Open the project in VS Code.
3. Run `flutter pub get`.
4. Run `flutter run -d chrome`.