import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/saved_item_entity.dart';
import '../../domain/repositories/saved_item_repository.dart';
import '../datasources/saved_item_local_datasource.dart';
import '../models/saved_item_model.dart';

/// Implementation of saved item repository
class SavedItemRepositoryImpl implements SavedItemRepository {
  final SavedItemLocalDataSource localDataSource;

  SavedItemRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SavedItemEntity>>> getSavedItems() async {
    try {
      final items = await localDataSource.getSavedItems();
      return Right(items.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavedItemEntity>> getSavedItemById(String id) async {
    try {
      final item = await localDataSource.getSavedItemById(id);
      return Right(item.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavedItemEntity>> saveItem(
      SavedItemEntity item) async {
    try {
      final model = SavedItemModel.fromEntity(item);
      final saved = await localDataSource.saveItem(model);
      return Right(saved.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavedItemEntity>> updateItem(
      SavedItemEntity item) async {
    try {
      final model = SavedItemModel.fromEntity(item);
      final updated = await localDataSource.updateItem(model);
      return Right(updated.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    try {
      await localDataSource.deleteItem(id);
      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isProductSaved(int productId) async {
    try {
      final isSaved = await localDataSource.isProductSaved(productId);
      return Right(isSaved);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}