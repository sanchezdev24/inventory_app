import 'package:flutter/material.dart';

import '../atoms/atoms.dart';
import '../tokens/tokens.dart';

/// List item with leading, title, subtitle, and trailing
class AppListItem extends StatefulWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final bool showDivider;

  const AppListItem({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.showDivider = false,
  });

  @override
  State<AppListItem> createState() => _AppListItemState();
}

class _AppListItemState extends State<AppListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppSpacing.animationFast,
    );
    _backgroundAnimation = ColorTween(
      begin: Colors.transparent,
      end: AppColors.neutral100,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
          onTapUp: widget.onTap != null
              ? (_) {
            _controller.reverse();
            widget.onTap?.call();
          }
              : null,
          onTapCancel:
          widget.onTap != null ? () => _controller.reverse() : null,
          onLongPress: widget.onLongPress,
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                color: _backgroundAnimation.value,
                padding: widget.padding ??
                    const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                child: child,
              );
            },
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  AppSpacing.gapHorizontalMd,
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText.titleSmall(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitle != null) ...[
                        AppSpacing.gapVerticalXs,
                        AppText.bodySmall(
                          widget.subtitle!,
                          color: AppColors.neutral500,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.trailing != null) ...[
                  AppSpacing.gapHorizontalMd,
                  widget.trailing!,
                ],
              ],
            ),
          ),
        ),
        if (widget.showDivider)
          const Divider(
            height: 1,
            indent: AppSpacing.lg,
            endIndent: AppSpacing.lg,
            color: AppColors.neutral200,
          ),
      ],
    );
  }
}

/// Skeleton list item for loading state
class AppListItemSkeleton extends StatelessWidget {
  final bool showLeading;
  final bool showTrailing;

  const AppListItemSkeleton({
    super.key,
    this.showLeading = true,
    this.showTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          if (showLeading) ...[
            const AppSkeleton.circular(size: 48),
            AppSpacing.gapHorizontalMd,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(width: 150, height: 16),
                AppSpacing.gapVerticalSm,
                AppSkeleton(width: 100, height: 12),
              ],
            ),
          ),
          if (showTrailing) ...[
            AppSpacing.gapHorizontalMd,
            const AppSkeleton(width: 60, height: 24),
          ],
        ],
      ),
    );
  }
}