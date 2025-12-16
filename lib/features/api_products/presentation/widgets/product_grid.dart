import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../domain/entities/product_entity.dart';

/// Grid of product cards with animations
class ProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final Set<int> savedProductIds;
  final void Function(ProductEntity product)? onProductTap;
  final void Function(ProductEntity product)? onSaveProduct;

  const ProductGrid({
    super.key,
    required this.products,
    this.savedProductIds = const {},
    this.onProductTap,
    this.onSaveProduct,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppSpacing.screenPadding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isSaved = savedProductIds.contains(product.id);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 200 + (index * 50)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: ProductCard(
            product: product,
            isSaved: isSaved,
            onTap: () => onProductTap?.call(product),
            onSave: () => onSaveProduct?.call(product),
          ),
        );
      },
    );
  }
}