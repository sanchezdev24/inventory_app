import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';

/// Abstract repository for products
abstract class ProductRepository {
  /// Get all products from API
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  /// Get product by ID
  Future<Either<Failure, ProductEntity>> getProductById(int id);

  /// Search products by query
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
}