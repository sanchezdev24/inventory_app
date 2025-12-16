import 'package:equatable/equatable.dart';

/// Saved item entity
class SavedItemEntity extends Equatable {
  final String id;
  final int productId;
  final String customName;
  final String productTitle;
  final String productDescription;
  final double productPrice;
  final String productCategory;
  final String productImage;
  final double productRating;
  final int productRatingCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SavedItemEntity({
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

  SavedItemEntity copyWith({
    String? id,
    int? productId,
    String? customName,
    String? productTitle,
    String? productDescription,
    double? productPrice,
    String? productCategory,
    String? productImage,
    double? productRating,
    int? productRatingCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavedItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      customName: customName ?? this.customName,
      productTitle: productTitle ?? this.productTitle,
      productDescription: productDescription ?? this.productDescription,
      productPrice: productPrice ?? this.productPrice,
      productCategory: productCategory ?? this.productCategory,
      productImage: productImage ?? this.productImage,
      productRating: productRating ?? this.productRating,
      productRatingCount: productRatingCount ?? this.productRatingCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    customName,
    productTitle,
    productDescription,
    productPrice,
    productCategory,
    productImage,
    productRating,
    productRatingCount,
    createdAt,
    updatedAt,
  ];
}