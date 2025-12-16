import 'package:flutter/material.dart';

import '../atoms/atoms.dart';
import '../tokens/tokens.dart';

/// Custom app bar organism
class AppCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? leading;
  final Color? backgroundColor;
  final bool centerTitle;

  const AppCustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = false,
    this.onBack,
    this.leading,
    this.backgroundColor,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 72 : 56);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  onPressed: onBack ?? () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.neutral800,
                )
              else if (leading != null)
                leading!,
              if (showBackButton || leading != null)
                AppSpacing.gapHorizontalSm,
              Expanded(
                child: centerTitle
                    ? Center(
                  child: _buildTitles(),
                )
                    : _buildTitles(),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitles() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
      centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        AppText.titleLarge(title),
        if (subtitle != null) ...[
          AppSpacing.gapVerticalXs,
          AppText.bodySmall(
            subtitle!,
            color: AppColors.neutral500,
          ),
        ],
      ],
    );
  }
}

/// Sliver app bar with search
class AppSliverAppBar extends StatelessWidget {
  final String title;
  final bool showSearch;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String? searchHint;
  final List<Widget>? actions;
  final bool floating;
  final bool pinned;

  const AppSliverAppBar({
    super.key,
    required this.title,
    this.showSearch = false,
    this.searchController,
    this.onSearchChanged,
    this.searchHint,
    this.actions,
    this.floating = true,
    this.pinned = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: floating,
      pinned: pinned,
      expandedHeight: showSearch ? 120 : null,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      title: AppText.titleLarge(title),
      actions: actions,
      flexibleSpace: showSearch
          ? FlexibleSpaceBar(
        background: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: AppSearchField(
            controller: searchController,
            onChanged: onSearchChanged,
            hint: searchHint,
          ),
        ),
      )
          : null,
    );
  }
}