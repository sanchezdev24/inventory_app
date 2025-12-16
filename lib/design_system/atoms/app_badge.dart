import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Badge variants
enum AppBadgeVariant { primary, secondary, success, warning, error, neutral }

/// Badge/Chip atom
class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;
  final bool isSmall;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.primary,
    this.icon,
    this.isSmall = false,
  });

  const AppBadge.primary(this.label, {super.key, this.icon, this.isSmall = false})
      : variant = AppBadgeVariant.primary;

  const AppBadge.secondary(this.label, {super.key, this.icon, this.isSmall = false})
      : variant = AppBadgeVariant.secondary;

  const AppBadge.success(this.label, {super.key, this.icon, this.isSmall = false})
      : variant = AppBadgeVariant.success;

  const AppBadge.warning(this.label, {super.key, this.icon, this.isSmall = false})
      : variant = AppBadgeVariant.warning;

  const AppBadge.error(this.label, {super.key, this.icon, this.isSmall = false})
      : variant = AppBadgeVariant.error;

  const AppBadge.neutral(this.label, {super.key, this.icon, this.isSmall = false})
      : variant = AppBadgeVariant.neutral;

  Color _getBackgroundColor() {
    switch (variant) {
      case AppBadgeVariant.primary:
        return AppColors.primaryContainer;
      case AppBadgeVariant.secondary:
        return AppColors.secondaryContainer;
      case AppBadgeVariant.success:
        return AppColors.successLight;
      case AppBadgeVariant.warning:
        return AppColors.warningLight;
      case AppBadgeVariant.error:
        return AppColors.errorLight;
      case AppBadgeVariant.neutral:
        return AppColors.neutral200;
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case AppBadgeVariant.primary:
        return AppColors.primaryDark;
      case AppBadgeVariant.secondary:
        return AppColors.secondaryDark;
      case AppBadgeVariant.success:
        return AppColors.success;
      case AppBadgeVariant.warning:
        return AppColors.tertiaryDark;
      case AppBadgeVariant.error:
        return AppColors.error;
      case AppBadgeVariant.neutral:
        return AppColors.neutral700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? AppSpacing.sm : AppSpacing.md,
        vertical: isSmall ? AppSpacing.xxs : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: AppSpacing.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: isSmall ? 12 : 14,
              color: _getForegroundColor(),
            ),
            SizedBox(width: isSmall ? 4 : 6),
          ],
          Text(
            label,
            style: (isSmall ? AppTypography.labelSmall : AppTypography.labelMedium)
                .copyWith(color: _getForegroundColor()),
          ),
        ],
      ),
    );
  }
}

/// Price badge
class AppPriceBadge extends StatelessWidget {
  final double price;
  final String currency;
  final bool isLarge;

  const AppPriceBadge({
    super.key,
    required this.price,
    this.currency = '\$',
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? AppSpacing.lg : AppSpacing.md,
        vertical: isLarge ? AppSpacing.sm : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppSpacing.borderRadiusMd,
        boxShadow: AppShadows.primarySm(AppColors.primary),
      ),
      child: Text(
        '$currency${price.toStringAsFixed(2)}',
        style: (isLarge ? AppTypography.titleMedium : AppTypography.labelLarge)
            .copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}