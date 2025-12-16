import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products.dart';
import 'api_products_state.dart';

/// Cubit for managing API products
class ApiProductsCubit extends Cubit<ApiProductsState> {
  final GetProducts getProducts;

  ApiProductsCubit({
    required this.getProducts,
  }) : super(const ApiProductsInitial());

  /// Load products from API
  Future<void> loadProducts() async {
    emit(const ApiProductsLoading());

    final result = await getProducts();

    result.fold(
          (failure) => emit(ApiProductsError(message: failure.message)),
          (products) => emit(ApiProductsLoaded(
        products: products,
        filteredProducts: products,
      )),
    );
  }

  /// Search products by query
  void searchProducts(String query) {
    final currentState = state;
    if (currentState is! ApiProductsLoaded) return;

    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      emit(currentState.copyWith(
        filteredProducts: currentState.products,
        searchQuery: '',
      ));
      return;
    }

    final filtered = currentState.products.where((product) {
      return product.title.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery) ||
          product.category.toLowerCase().contains(lowerQuery);
    }).toList();

    emit(currentState.copyWith(
      filteredProducts: filtered,
      searchQuery: query,
    ));
  }

  /// Update saved product IDs to filter out already saved products
  void updateSavedProductIds(Set<int> savedIds) {
    final currentState = state;
    if (currentState is ApiProductsLoaded) {
      emit(currentState.copyWith(savedProductIds: savedIds));
    }
  }

  /// Get product by ID
  ProductEntity? getProductById(int id) {
    final currentState = state;
    if (currentState is ApiProductsLoaded) {
      try {
        return currentState.products.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}