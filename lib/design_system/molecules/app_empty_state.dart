import 'package:flutter/material.dart';

import '../atoms/atoms.dart';
import '../tokens/tokens.dart';

/// Empty state molecule
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.neutral400,
              ),
            ),
            AppSpacing.gapVerticalXl,
            AppText.titleMedium(
              title,
              textAlign: TextAlign.center,
              color: AppColors.neutral700,
            ),
            if (description != null) ...[
              AppSpacing.gapVerticalSm,
              AppText.bodyMedium(
                description!,
                textAlign: TextAlign.center,
                color: AppColors.neutral500,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.gapVerticalXl,
              AppButton.primary(
                label: actionLabel!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state molecule with retry
class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.error,
              ),
            ),
            AppSpacing.gapVerticalXl,
            AppText.titleMedium(
              '¡Algo salió mal!',
              textAlign: TextAlign.center,
              color: AppColors.neutral700,
            ),
            AppSpacing.gapVerticalSm,
            AppText.bodyMedium(
              message,
              textAlign: TextAlign.center,
              color: AppColors.neutral500,
            ),
            if (onRetry != null) ...[
              AppSpacing.gapVerticalXl,
              AppButton.primary(
                label: 'Reintentar',
                leadingIcon: Icons.refresh,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading state molecule
class AppLoadingState extends StatelessWidget {
  final String? message;

  const AppLoadingState({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLoadingIndicator.circular(size: 48),
            if (message != null) ...[
              AppSpacing.gapVerticalXl,
              AppText.bodyMedium(
                message!,
                textAlign: TextAlign.center,
                color: AppColors.neutral500,
              ),
            ],
          ],
        ),
      ),
    );
  }
}