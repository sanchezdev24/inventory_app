import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/tokens/tokens.dart';
import 'app_router.dart';

/// Shell page containing bottom navigation
class ShellPage extends StatelessWidget {
  final Widget child;

  const ShellPage({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.prefs)) return 1;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.apiList);
        break;
      case 1:
        context.go(AppRoutes.prefs);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: AppSpacing.animationFast,
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: child,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => _onItemTapped(context, index),
          backgroundColor: theme.colorScheme.surface,
          indicatorColor: theme.colorScheme.primaryContainer,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: AppSpacing.animationMedium,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.store_outlined,
                color: currentIndex == 0
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.store,
                color: theme.colorScheme.primary,
              ),
              label: 'Catálogo',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite_outline,
                color: currentIndex == 1
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.favorite,
                color: theme.colorScheme.primary,
              ),
              label: 'Guardados',
            ),
          ],
        ),
      ),
    );
  }
}