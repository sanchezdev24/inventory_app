import '../../domain/entities/rating_entity.dart';

/// Rating model for JSON serialization
class RatingModel extends RatingEntity {
  const RatingModel({
    required super.rate,
    required super.count,
  });

  /// Create from JSON
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }

  /// Create from entity
  factory RatingModel.fromEntity(RatingEntity entity) {
    return RatingModel(
      rate: entity.rate,
      count: entity.count,
    );
  }
}