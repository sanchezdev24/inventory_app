import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_item_entity.dart';
import '../repositories/saved_item_repository.dart';

/// Get all saved items use case
class GetSavedItems implements UseCaseNoParams<List<SavedItemEntity>> {
  final SavedItemRepository repository;

  GetSavedItems(this.repository);

  @override
  Future<Either<Failure, List<SavedItemEntity>>> call() {
    return repository.getSavedItems();
  }
}

/// Get saved item by ID use case
class GetSavedItemById implements UseCase<SavedItemEntity, String> {
  final SavedItemRepository repository;

  GetSavedItemById(this.repository);

  @override
  Future<Either<Failure, SavedItemEntity>> call(String id) {
    return repository.getSavedItemById(id);
  }
}

/// Save item use case
class SaveItem implements UseCase<SavedItemEntity, SavedItemEntity> {
  final SavedItemRepository repository;

  SaveItem(this.repository);

  @override
  Future<Either<Failure, SavedItemEntity>> call(SavedItemEntity item) {
    return repository.saveItem(item);
  }
}

/// Update item use case
class UpdateItem implements UseCase<SavedItemEntity, SavedItemEntity> {
  final SavedItemRepository repository;

  UpdateItem(this.repository);

  @override
  Future<Either<Failure, SavedItemEntity>> call(SavedItemEntity item) {
    return repository.updateItem(item);
  }
}

/// Delete item use case
class DeleteItem implements UseCase<void, String> {
  final SavedItemRepository repository;

  DeleteItem(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteItem(id);
  }
}

/// Check if product is saved use case
class IsProductSaved implements UseCase<bool, int> {
  final SavedItemRepository repository;

  IsProductSaved(this.repository);

  @override
  Future<Either<Failure, bool>> call(int productId) {
    return repository.isProductSaved(productId);
  }
}