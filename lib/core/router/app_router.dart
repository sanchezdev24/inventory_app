import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/api_products/domain/entities/product_entity.dart';
import '../../features/api_products/presentation/pages/api_products_page.dart';
import '../../features/saved_items/domain/entities/saved_item_entity.dart';
import '../../features/saved_items/presentation/pages/saved_item_detail_page.dart';
import '../../features/saved_items/presentation/pages/saved_items_page.dart';
import '../../features/saved_items/presentation/pages/create_saved_item_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../constants/app_constants.dart';
import 'shell_page.dart';

/// Route names
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String apiList = '/api-list';
  static const String prefs = '/prefs';
  static const String prefsNew = '/prefs/new';
  static const String prefsDetail = '/prefs/:id';
}

/// Router configuration
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash route
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: AppConstants.mediumAnimation,
        ),
      ),

      // Shell route with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ShellPage(child: child),
        routes: [
          // API Products list
          GoRoute(
            path: AppRoutes.apiList,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ApiProductsPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: AppConstants.shortAnimation,
            ),
          ),

          // Saved items list
          GoRoute(
            path: AppRoutes.prefs,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const SavedItemsPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: AppConstants.shortAnimation,
            ),
          ),
        ],
      ),

      // Create new saved item
      GoRoute(
        path: AppRoutes.prefsNew,
        pageBuilder: (context, state) {
          final product = state.extra as ProductEntity?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: CreateSavedItemPage(product: product),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: Curves.easeOutCubic),
              );
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: AppConstants.mediumAnimation,
          );
        },
      ),

      // Saved item detail
      GoRoute(
        path: AppRoutes.prefsDetail,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final item = state.extra as SavedItemEntity?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: SavedItemDetailPage(itemId: id, item: item),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: Curves.easeOutCubic),
              );
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: AppConstants.mediumAnimation,
          );
        },
      ),
    ],
  );
}