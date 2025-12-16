import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/saved_item_model.dart';

/// Local data source for saved items using Hive
abstract class SavedItemLocalDataSource {
  /// Get all saved items
  Future<List<SavedItemModel>> getSavedItems();

  /// Get saved item by ID
  Future<SavedItemModel> getSavedItemById(String id);

  /// Save item
  Future<SavedItemModel> saveItem(SavedItemModel item);

  /// Update item
  Future<SavedItemModel> updateItem(SavedItemModel item);

  /// Delete item
  Future<void> deleteItem(String id);

  /// Check if product is saved
  Future<bool> isProductSaved(int productId);
}

/// Implementation using Hive
class SavedItemLocalDataSourceImpl implements SavedItemLocalDataSource {
  final Box<SavedItemModel> box;

  SavedItemLocalDataSourceImpl({required this.box});

  /// Open or get the box
  static Future<Box<SavedItemModel>> openBox() async {
    if (Hive.isBoxOpen(AppConstants.hiveBoxName)) {
      return Hive.box<SavedItemModel>(AppConstants.hiveBoxName);
    }
    return await Hive.openBox<SavedItemModel>(AppConstants.hiveBoxName);
  }

  @override
  Future<List<SavedItemModel>> getSavedItems() async {
    try {
      return box.values.toList();
    } catch (e) {
      throw CacheException(message: 'Error al obtener items guardados: $e');
    }
  }

  @override
  Future<SavedItemModel> getSavedItemById(String id) async {
    try {
      final item = box.get(id);
      if (item == null) {
        throw const NotFoundException(message: 'Item no encontrado');
      }
      return item;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw CacheException(message: 'Error al obtener item: $e');
    }
  }

  @override
  Future<SavedItemModel> saveItem(SavedItemModel item) async {
    try {
      await box.put(item.id, item);
      return item;
    } catch (e) {
      throw CacheException(message: 'Error al guardar item: $e');
    }
  }

  @override
  Future<SavedItemModel> updateItem(SavedItemModel item) async {
    try {
      if (!box.containsKey(item.id)) {
        throw const NotFoundException(message: 'Item no encontrado');
      }
      await box.put(item.id, item);
      return item;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw CacheException(message: 'Error al actualizar item: $e');
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      if (!box.containsKey(id)) {
        throw const NotFoundException(message: 'Item no encontrado');
      }
      await box.delete(id);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw CacheException(message: 'Error al eliminar item: $e');
    }
  }

  @override
  Future<bool> isProductSaved(int productId) async {
    try {
      return box.values.any((item) => item.productId == productId);
    } catch (e) {
      throw CacheException(message: 'Error al verificar item: $e');
    }
  }
}