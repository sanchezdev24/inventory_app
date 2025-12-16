import 'package:hive/hive.dart';

import '../../domain/entities/saved_item_entity.dart';

part 'saved_item_model.g.dart';

/// Saved item model for Hive storage
@HiveType(typeId: 0)
class SavedItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int productId;

  @HiveField(2)
  final String customName;

  @HiveField(3)
  final String productTitle;

  @HiveField(4)
  final String productDescription;

  @HiveField(5)
  final double productPrice;

  @HiveField(6)
  final String productCategory;

  @HiveField(7)
  final String productImage;

  @HiveField(8)
  final double productRating;

  @HiveField(9)
  final int productRatingCount;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  SavedItemModel({
    required this.id,
    required this.productId,
    required this.customName,
    required this.productTitle,
    required this.productDescription,
    required this.productPrice,
    required this.productCategory,
    required this.productImage,
    required this.productRating,
    required this.productRatingCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert to entity
  SavedItemEntity toEntity() {
    return SavedItemEntity(
      id: id,
      productId: productId,
      customName: customName,
      productTitle: productTitle,
      productDescription: productDescription,
      productPrice: productPrice,
      productCategory: productCategory,
      productImage: productImage,
      productRating: productRating,
      productRatingCount: productRatingCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from entity
  factory SavedItemModel.fromEntity(SavedItemEntity entity) {
    return SavedItemModel(
      id: entity.id,
      productId: entity.productId,
      customName: entity.customName,
      productTitle: entity.productTitle,
      productDescription: entity.productDescription,
      productPrice: entity.productPrice,
      productCategory: entity.productCategory,
      productImage: entity.productImage,
      productRating: entity.productRating,
      productRatingCount: entity.productRatingCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}