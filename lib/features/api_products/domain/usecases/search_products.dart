import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Search products use case
class SearchProducts implements UseCase<List<ProductEntity>, String> {
  final ProductRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(String query) {
    return repository.searchProducts(query);
  }
}