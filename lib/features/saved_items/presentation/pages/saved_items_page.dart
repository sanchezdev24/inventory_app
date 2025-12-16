import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../design_system/design_system.dart';
import '../../../api_products/presentation/cubit/cubit.dart';
import '../cubit/cubit.dart';

/// Saved items list page
class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({super.key});

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    context.read<SavedItemsCubit>().loadSavedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText.headlineSmall('Mis Guardados'),
                AppSpacing.gapVerticalXs,
                BlocBuilder<SavedItemsCubit, SavedItemsState>(
                  builder: (context, state) {
                    if (state is SavedItemsLoaded) {
                      return AppText.bodySmall(
                        '${state.items.length} elementos guardados',
                        color: AppColors.neutral500,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _loadItems,
            icon: const Icon(Icons.refresh),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<SavedItemsCubit, SavedItemsState>(
      listener: (context, state) {
        // Update API products when saved items change
        if (state is SavedItemsLoaded) {
          context.read<ApiProductsCubit>().updateSavedProductIds(
            state.savedProductIds,
          );
        }
      },
      builder: (context, state) {
        if (state is SavedItemsLoading) {
          return _buildLoadingView();
        }

        if (state is SavedItemsError) {
          return AppErrorState(
            message: state.message,
            onRetry: _loadItems,
          );
        }

        if (state is SavedItemsLoaded) {
          if (state.items.isEmpty) {
            return AppEmptyState(
              icon: Icons.favorite_outline,
              title: 'Sin elementos guardados',
              description:
              'Guarda productos del catálogo para verlos aquí.',
              actionLabel: 'Ver Catálogo',
              onAction: () => context.go(AppRoutes.apiList),
            );
          }

          return _buildItemsList(state.items);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingView() {
    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: const SavedItemCardSkeleton(),
      ),
    );
  }

  Widget _buildItemsList(List items) {
    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 200 + (index * 50)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(20 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: SavedItemCard(
              item: item,
              onTap: () {
                context.push(
                  '/prefs/${item.id}',
                  extra: item,
                );
              },
              onDelete: () async {
                final deleted = await context
                    .read<SavedItemsCubit>()
                    .deleteItemById(item.id);
                if (deleted && mounted) {
                  AppSnackbar.showSuccess(
                    context: context,
                    message: '${item.customName} eliminado',
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}