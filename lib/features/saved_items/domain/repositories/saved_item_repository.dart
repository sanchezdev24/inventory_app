import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/saved_item_entity.dart';

/// Abstract repository for saved items (Native Storage)
abstract class SavedItemRepository {
  /// Get all saved items
  Future<Either<Failure, List<SavedItemEntity>>> getSavedItems();

  /// Get saved item by ID
  Future<Either<Failure, SavedItemEntity>> getSavedItemById(String id);

  /// Save new item
  Future<Either<Failure, SavedItemEntity>> saveItem(SavedItemEntity item);

  /// Update item
  Future<Either<Failure, SavedItemEntity>> updateItem(SavedItemEntity item);

  /// Delete item
  Future<Either<Failure, void>> deleteItem(String id);

  /// Check if product is already saved
  Future<Either<Failure, bool>> isProductSaved(int productId);
}