import 'package:equatable/equatable.dart';

import '../../domain/entities/saved_item_entity.dart';

/// States for SavedItemsCubit
abstract class SavedItemsState extends Equatable {
  const SavedItemsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SavedItemsInitial extends SavedItemsState {
  const SavedItemsInitial();
}

/// Loading state
class SavedItemsLoading extends SavedItemsState {
  const SavedItemsLoading();
}

/// Loaded state with items
class SavedItemsLoaded extends SavedItemsState {
  final List<SavedItemEntity> items;

  const SavedItemsLoaded({required this.items});

  /// Get set of saved product IDs
  Set<int> get savedProductIds => items.map((i) => i.productId).toSet();

  SavedItemsLoaded copyWith({List<SavedItemEntity>? items}) {
    return SavedItemsLoaded(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}

/// Error state
class SavedItemsError extends SavedItemsState {
  final String message;

  const SavedItemsError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Action state (for operations like save, update, delete)
class SavedItemsActionSuccess extends SavedItemsState {
  final String message;
  final SavedItemsLoaded previousState;

  const SavedItemsActionSuccess({
    required this.message,
    required this.previousState,
  });

  @override
  List<Object?> get props => [message, previousState];
}