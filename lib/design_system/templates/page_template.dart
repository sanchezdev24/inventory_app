import 'package:flutter/material.dart';

import '../molecules/molecules.dart';
import '../organisms/organisms.dart';
import '../tokens/tokens.dart';

/// Base page template
class PageTemplate extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const PageTemplate({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.actions,
    this.showBackButton = false,
    this.onBack,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: AppCustomAppBar(
        title: title,
        subtitle: subtitle,
        actions: actions,
        showBackButton: showBackButton,
        onBack: onBack,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// List page template with search
class ListPageTemplate extends StatelessWidget {
  final String title;
  final bool showSearch;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String? searchHint;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const ListPageTemplate({
    super.key,
    required this.title,
    this.showSearch = false,
    this.searchController,
    this.onSearchChanged,
    this.searchHint,
    required this.child,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          AppSliverAppBar(
            title: title,
            showSearch: showSearch,
            searchController: searchController,
            onSearchChanged: onSearchChanged,
            searchHint: searchHint,
            actions: actions,
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: child,
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

/// State template for handling loading/error/success states
class StateTemplate<T> extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final T? data;
  final VoidCallback? onRetry;
  final Widget Function(T data) builder;
  final Widget? loadingWidget;
  final String? loadingMessage;
  final Widget? emptyWidget;
  final bool Function(T data)? isEmpty;

  const StateTemplate({
    super.key,
    required this.isLoading,
    this.errorMessage,
    this.data,
    this.onRetry,
    required this.builder,
    this.loadingWidget,
    this.loadingMessage,
    this.emptyWidget,
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? AppLoadingState(message: loadingMessage);
    }

    if (errorMessage != null) {
      return AppErrorState(
        message: errorMessage!,
        onRetry: onRetry,
      );
    }

    if (data == null) {
      return emptyWidget ??
          const AppEmptyState(
            icon: Icons.inbox_outlined,
            title: 'No hay datos',
            description: 'No se encontraron elementos para mostrar.',
          );
    }

    if (isEmpty != null && isEmpty!(data as T)) {
      return emptyWidget ??
          const AppEmptyState(
            icon: Icons.inbox_outlined,
            title: 'Lista vacía',
            description: 'No hay elementos para mostrar.',
          );
    }

    return builder(data as T);
  }
}