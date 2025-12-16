import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../api_products/domain/entities/product_entity.dart';
import '../../domain/entities/saved_item_entity.dart';
import '../../domain/usecases/saved_item_usecases.dart';
import 'saved_items_state.dart';

/// Cubit for managing saved items (preferences)
class SavedItemsCubit extends Cubit<SavedItemsState> {
  final GetSavedItems getSavedItems;
  final GetSavedItemById getSavedItemById;
  final SaveItem saveItem;
  final UpdateItem updateItem;
  final DeleteItem deleteItem;

  SavedItemsCubit({
    required this.getSavedItems,
    required this.getSavedItemById,
    required this.saveItem,
    required this.updateItem,
    required this.deleteItem,
  }) : super(const SavedItemsInitial());

  /// Load all saved items
  Future<void> loadSavedItems() async {
    emit(const SavedItemsLoading());

    final result = await getSavedItems();

    result.fold(
          (failure) => emit(SavedItemsError(message: failure.message)),
          (items) => emit(SavedItemsLoaded(items: items)),
    );
  }

  /// Save a new item from a product
  Future<bool> saveProductWithCustomName({
    required ProductEntity product,
    required String customName,
  }) async {
    final currentState = state;
    final now = DateTime.now();

    final newItem = SavedItemEntity(
      id: '${product.id}_${now.millisecondsSinceEpoch}',
      productId: product.id,
      customName: customName,
      productTitle: product.title,
      productDescription: product.description,
      productPrice: product.price,
      productCategory: product.category,
      productImage: product.image,
      productRating: product.rating.rate,
      productRatingCount: product.rating.count,
      createdAt: now,
      updatedAt: now,
    );

    final result = await saveItem(newItem);

    return result.fold(
          (failure) {
        if (currentState is SavedItemsLoaded) {
          emit(currentState);
        }
        return false;
      },
          (savedItem) {
        if (currentState is SavedItemsLoaded) {
          final updatedItems = [...currentState.items, savedItem];
          emit(SavedItemsLoaded(items: updatedItems));
        } else {
          emit(SavedItemsLoaded(items: [savedItem]));
        }
        return true;
      },
    );
  }

  /// Update an existing item's custom name
  Future<bool> updateItemCustomName({
    required String itemId,
    required String newCustomName,
  }) async {
    final currentState = state;
    if (currentState is! SavedItemsLoaded) return false;

    final itemIndex = currentState.items.indexWhere((i) => i.id == itemId);
    if (itemIndex == -1) return false;

    final item = currentState.items[itemIndex];
    final updatedItem = item.copyWith(
      customName: newCustomName,
      updatedAt: DateTime.now(),
    );

    final result = await updateItem(updatedItem);

    return result.fold(
          (failure) {
        emit(currentState);
        return false;
      },
          (updated) {
        final updatedItems = List<SavedItemEntity>.from(currentState.items);
        updatedItems[itemIndex] = updated;
        emit(SavedItemsLoaded(items: updatedItems));
        return true;
      },
    );
  }

  /// Delete an item
  Future<bool> deleteItemById(String itemId) async {
    final currentState = state;
    if (currentState is! SavedItemsLoaded) return false;

    final result = await deleteItem(itemId);

    return result.fold(
          (failure) {
        emit(currentState);
        return false;
      },
          (_) {
        final updatedItems =
        currentState.items.where((i) => i.id != itemId).toList();
        emit(SavedItemsLoaded(items: updatedItems));
        return true;
      },
    );
  }

  /// Get saved item by ID (from current state)
  SavedItemEntity? getItemById(String id) {
    final currentState = state;
    if (currentState is SavedItemsLoaded) {
      try {
        return currentState.items.firstWhere((i) => i.id == id);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Check if product is saved
  bool isProductSaved(int productId) {
    final currentState = state;
    if (currentState is SavedItemsLoaded) {
      return currentState.items.any((i) => i.productId == productId);
    }
    return false;
  }

  /// Get set of saved product IDs
  Set<int> get savedProductIds {
    final currentState = state;
    if (currentState is SavedItemsLoaded) {
      return currentState.savedProductIds;
    }
    return {};
  }
}