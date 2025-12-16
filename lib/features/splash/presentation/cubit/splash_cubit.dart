import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_state.dart';

/// Cubit for managing splash screen
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashLoading());

  /// Initialize app and prepare for navigation
  Future<void> initialize() async {
    // Simulate initialization (e.g., loading configs, preloading data)
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(const SplashReady());
  }
}