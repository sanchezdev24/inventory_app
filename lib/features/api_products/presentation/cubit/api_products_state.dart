import 'package:equatable/equatable.dart';

import '../../domain/entities/product_entity.dart';

/// States for ApiProductsCubit
abstract class ApiProductsState extends Equatable {
  const ApiProductsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ApiProductsInitial extends ApiProductsState {
  const ApiProductsInitial();
}

/// Loading state
class ApiProductsLoading extends ApiProductsState {
  const ApiProductsLoading();
}

/// Loaded state with products
class ApiProductsLoaded extends ApiProductsState {
  final List<ProductEntity> products;
  final List<ProductEntity> filteredProducts;
  final String searchQuery;
  final Set<int> savedProductIds;

  const ApiProductsLoaded({
    required this.products,
    required this.filteredProducts,
    this.searchQuery = '',
    this.savedProductIds = const {},
  });

  /// Get products that are not saved
  List<ProductEntity> get availableProducts {
    return filteredProducts
        .where((p) => !savedProductIds.contains(p.id))
        .toList();
  }

  ApiProductsLoaded copyWith({
    List<ProductEntity>? products,
    List<ProductEntity>? filteredProducts,
    String? searchQuery,
    Set<int>? savedProductIds,
  }) {
    return ApiProductsLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      savedProductIds: savedProductIds ?? this.savedProductIds,
    );
  }

  @override
  List<Object?> get props => [
    products,
    filteredProducts,
    searchQuery,
    savedProductIds,
  ];
}

/// Error state
class ApiProductsError extends ApiProductsState {
  final String message;

  const ApiProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}