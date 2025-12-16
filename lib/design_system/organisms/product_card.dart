import 'package:flutter/material.dart';

import '../../features/api_products/domain/entities/product_entity.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';
import '../tokens/tokens.dart';

/// Product card organism for API products
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool isSaved;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onSave,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLg),
                ),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: AppNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.contain,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              // Category badge
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: AppBadge.neutral(
                  product.category,
                  isSmall: true,
                ),
              ),
              // Save button
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: _SaveButton(
                  isSaved: isSaved,
                  onTap: onSave,
                ),
              ),
            ],
          ),
          // Content section
          Padding(
            padding: AppSpacing.paddingMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.titleSmall(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.gapVerticalSm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppPriceBadge(price: product.price),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.tertiary,
                        ),
                        AppSpacing.gapHorizontalXs,
                        AppText.labelSmall(
                          product.rating.rate.toStringAsFixed(1),
                          color: AppColors.neutral600,
                        ),
                        AppSpacing.gapHorizontalXs,
                        AppText.labelSmall(
                          '(${product.rating.count})',
                          color: AppColors.neutral400,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated save button
class _SaveButton extends StatefulWidget {
  final bool isSaved;
  final VoidCallback? onTap;

  const _SaveButton({
    required this.isSaved,
    this.onTap,
  });

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_SaveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSaved != oldWidget.isSaved && widget.isSaved) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: AppShadows.sm,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: AppSpacing.animationFast,
              child: Icon(
                widget.isSaved ? Icons.favorite : Icons.favorite_outline,
                key: ValueKey(widget.isSaved),
                size: 20,
                color: widget.isSaved ? AppColors.error : AppColors.neutral400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Skeleton product card for loading state
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: AppShimmer(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusLg),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: AppSpacing.paddingMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSkeleton(height: 16),
                AppSpacing.gapVerticalSm,
                const AppSkeleton(height: 16, width: 100),
                AppSpacing.gapVerticalMd,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppSkeleton(height: 28, width: 60),
                    const AppSkeleton(height: 16, width: 50),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}