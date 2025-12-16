/// API Constants for FakeStore API
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://fakestoreapi.com';
  static const String products = '/products';
  static const String productById = '/products/';

  static const Duration timeout = Duration(seconds: 30);
}