import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/platform/native_storage_channel.dart';
import '../../domain/entities/saved_item_entity.dart';
import '../../domain/repositories/saved_item_repository.dart';

/// Implementation of saved item repository using Native Storage (Method Channel)
class SavedItemRepositoryImpl implements SavedItemRepository {
  final NativeStorageChannel nativeChannel;

  SavedItemRepositoryImpl({required this.nativeChannel});

  @override
  Future<Either<Failure, List<SavedItemEntity>>> getSavedItems() async {
    try {
      final itemsMap = await nativeChannel.getItems();
      final items = itemsMap.map((e) => _mapToEntity(e)).toList();
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Error getting items: $e'));
    }
  }

  @override
  Future<Either<Failure, SavedItemEntity>> getSavedItemById(String id) async {
    try {
      final itemMap = await nativeChannel.getItemById(id);
      if (itemMap == null) {
        return const Left(NotFoundFailure(message: 'Item no encontrado'));
      }
      return Right(_mapToEntity(itemMap));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Error getting item: $e'));
    }
  }

  @override
  Future<Either<Failure, SavedItemEntity>> saveItem(SavedItemEntity item) async {
    try {
      final itemMap = _entityToMap(item);
      final savedMap = await nativeChannel.saveItem(itemMap);
      if (savedMap == null) {
        return const Left(CacheFailure(message: 'Error al guardar item'));
      }
      return Right(_mapToEntity(savedMap));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Error saving item: $e'));
    }
  }

  @override
  Future<Either<Failure, SavedItemEntity>> updateItem(SavedItemEntity item) async {
    try {
      final itemMap = _entityToMap(item);
      final updatedMap = await nativeChannel.updateItem(itemMap);
      if (updatedMap == null) {
        return const Left(NotFoundFailure(message: 'Item no encontrado'));
      }
      return Right(_mapToEntity(updatedMap));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Error updating item: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    try {
      final result = await nativeChannel.deleteItem(id);
      if (!result) {
        return const Left(NotFoundFailure(message: 'Item no encontrado'));
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Error deleting item: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isProductSaved(int productId) async {
    try {
      final isSaved = await nativeChannel.isProductSaved(productId);
      return Right(isSaved);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Error checking product: $e'));
    }
  }

  /// Convert entity to map for native storage
  Map<String, dynamic> _entityToMap(SavedItemEntity entity) {
    return {
      'id': entity.id,
      'productId': entity.productId,
      'customName': entity.customName,
      'productTitle': entity.productTitle,
      'productDescription': entity.productDescription,
      'productPrice': entity.productPrice,
      'productCategory': entity.productCategory,
      'productImage': entity.productImage,
      'productRating': entity.productRating,
      'productRatingCount': entity.productRatingCount,
      'createdAt': entity.createdAt.toIso8601String(),
      'updatedAt': entity.updatedAt.toIso8601String(),
    };
  }

  /// Convert map from native storage to entity
  SavedItemEntity _mapToEntity(Map<String, dynamic> map) {
    return SavedItemEntity(
      id: map['id'] as String,
      productId: map['productId'] as int,
      customName: map['customName'] as String,
      productTitle: map['productTitle'] as String,
      productDescription: map['productDescription'] as String,
      productPrice: (map['productPrice'] as num).toDouble(),
      productCategory: map['productCategory'] as String,
      productImage: map['productImage'] as String,
      productRating: (map['productRating'] as num).toDouble(),
      productRatingCount: map['productRatingCount'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}