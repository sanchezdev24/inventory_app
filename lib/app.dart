import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/api_products/presentation/cubit/api_products_cubit.dart';
import 'features/saved_items/presentation/cubit/saved_items_cubit.dart';
import 'features/splash/presentation/cubit/splash_cubit.dart';
import 'injection_container.dart';

/// Main application widget
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashCubit>(
          create: (_) => sl<SplashCubit>(),
        ),
        BlocProvider<ApiProductsCubit>(
          create: (_) => sl<ApiProductsCubit>(),
        ),
        BlocProvider<SavedItemsCubit>(
          create: (_) => sl<SavedItemsCubit>()..loadSavedItems(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Inventory App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}