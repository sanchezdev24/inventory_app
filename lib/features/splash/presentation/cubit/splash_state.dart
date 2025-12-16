import 'package:equatable/equatable.dart';

/// States for SplashCubit
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Initial/loading state
class SplashLoading extends SplashState {
  const SplashLoading();
}

/// Ready to navigate
class SplashReady extends SplashState {
  const SplashReady();
}