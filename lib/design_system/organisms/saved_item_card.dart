import 'package:flutter/material.dart';

import '../../features/saved_items/domain/entities/saved_item_entity.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';
import '../tokens/tokens.dart';

/// Saved item card organism
class SavedItemCard extends StatelessWidget {
  final SavedItemEntity item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SavedItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await AppDialog.showDeleteConfirmation(
          context: context,
          itemName: item.customName,
        );
      },
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: AppCard(
        onTap: onTap,
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: AppSpacing.borderRadiusMd,
              child: AppNetworkImage(
                imageUrl: item.productImage,
                width: 72,
                height: 72,
                fit: BoxFit.contain,
                backgroundColor: Colors.white,
              ),
            ),
            AppSpacing.gapHorizontalMd,
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.titleSmall(
                    item.customName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.gapVerticalXs,
                  AppText.bodySmall(
                    item.productTitle,
                    color: AppColors.neutral500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.gapVerticalSm,
                  Row(
                    children: [
                      AppBadge.neutral(
                        item.productCategory,
                        isSmall: true,
                      ),
                      const Spacer(),
                      AppText.labelMedium(
                        '\$${item.productPrice.toStringAsFixed(2)}',
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapHorizontalSm,
            // Arrow
            const Icon(
              Icons.chevron_right,
              color: AppColors.neutral400,
            ),
          ],
        ),
      ),
    );
  }
}

/// Saved item list tile (compact version)
class SavedItemTile extends StatelessWidget {
  final SavedItemEntity item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SavedItemTile({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppListItem(
      leading: ClipRRect(
        borderRadius: AppSpacing.borderRadiusSm,
        child: AppNetworkImage(
          imageUrl: item.productImage,
          width: 48,
          height: 48,
          fit: BoxFit.contain,
          backgroundColor: Colors.white,
        ),
      ),
      title: item.customName,
      subtitle: item.productTitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.labelMedium(
            '\$${item.productPrice.toStringAsFixed(2)}',
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.gapHorizontalSm,
          if (onDelete != null)
            IconButton(
              onPressed: () async {
                final confirm = await AppDialog.showDeleteConfirmation(
                  context: context,
                  itemName: item.customName,
                );
                if (confirm == true) {
                  onDelete?.call();
                }
              },
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 20,
              ),
            ),
        ],
      ),
      onTap: onTap,
      showDivider: true,
    );
  }
}

/// Skeleton saved item card
class SavedItemCardSkeleton extends StatelessWidget {
  const SavedItemCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.paddingMd,
      child: Row(
        children: [
          const AppSkeleton.rectangle(width: 72, height: 72),
          AppSpacing.gapHorizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSkeleton(height: 16, width: 120),
                AppSpacing.gapVerticalSm,
                const AppSkeleton(height: 12, width: 180),
                AppSpacing.gapVerticalMd,
                Row(
                  children: [
                    const AppSkeleton(height: 20, width: 60),
                    const Spacer(),
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