import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../design_system/design_system.dart';
import '../../../saved_items/presentation/cubit/cubit.dart';
import '../cubit/cubit.dart';
import '../widgets/product_grid.dart';

/// API Products list page
class ApiProductsPage extends StatefulWidget {
  const ApiProductsPage({super.key});

  @override
  State<ApiProductsPage> createState() => _ApiProductsPageState();
}

class _ApiProductsPageState extends State<ApiProductsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    context.read<ApiProductsCubit>().loadProducts();
  }

  void _onSearch(String query) {
    context.read<ApiProductsCubit>().searchProducts(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search
            _buildHeader(),
            // Products grid
            Expanded(
              child: _buildContent(),
            ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText.headlineSmall('Catálogo'),
                    AppSpacing.gapVerticalXs,
                    BlocBuilder<ApiProductsCubit, ApiProductsState>(
                      builder: (context, state) {
                        if (state is ApiProductsLoaded) {
                          final count = state.availableProducts.length;
                          return AppText.bodySmall(
                            '$count productos disponibles',
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
                onPressed: _loadProducts,
                icon: const Icon(Icons.refresh),
                color: AppColors.primary,
              ),
            ],
          ),
          AppSpacing.gapVerticalMd,
          AppSearchField(
            controller: _searchController,
            hint: 'Buscar productos...',
            onChanged: _onSearch,
            onClear: () => _onSearch(''),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<ApiProductsCubit, ApiProductsState>(
      listener: (context, state) {
        // Update saved product IDs when products are loaded
        if (state is ApiProductsLoaded) {
          final savedState = context.read<SavedItemsCubit>().state;
          if (savedState is SavedItemsLoaded) {
            final savedIds = savedState.items.map((i) => i.productId).toSet();
            context.read<ApiProductsCubit>().updateSavedProductIds(savedIds);
          }
        }
      },
      builder: (context, state) {
        if (state is ApiProductsLoading) {
          return const _LoadingView();
        }

        if (state is ApiProductsError) {
          return AppErrorState(
            message: state.message,
            onRetry: _loadProducts,
          );
        }

        if (state is ApiProductsLoaded) {
          final products = state.availableProducts;

          if (products.isEmpty) {
            if (state.searchQuery.isNotEmpty) {
              return AppEmptyState(
                icon: Icons.search_off,
                title: 'Sin resultados',
                description:
                'No se encontraron productos para "${state.searchQuery}"',
                actionLabel: 'Limpiar búsqueda',
                onAction: () {
                  _searchController.clear();
                  _onSearch('');
                },
              );
            }
            return const AppEmptyState(
              icon: Icons.check_circle_outline,
              title: '¡Todo guardado!',
              description:
              'Ya has guardado todos los productos disponibles.',
            );
          }

          return ProductGrid(
            products: products,
            savedProductIds: state.savedProductIds,
            onProductTap: (product) {
              context.push(AppRoutes.prefsNew, extra: product);
            },
            onSaveProduct: (product) {
              context.push(AppRoutes.prefsNew, extra: product);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// Loading view with skeletons
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppSpacing.screenPadding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ProductCardSkeleton(),
    );
  }
}