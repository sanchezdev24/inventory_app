import 'package:equatable/equatable.dart';

/// Rating entity
class RatingEntity extends Equatable {
  final double rate;
  final int count;

  const RatingEntity({
    required this.rate,
    required this.count,
  });

  @override
  List<Object?> get props => [rate, count];
}