import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../design_system/design_system.dart';
import '../../domain/entities/saved_item_entity.dart';
import '../cubit/cubit.dart';

/// Page showing detail of a saved item
class SavedItemDetailPage extends StatefulWidget {
  final String itemId;
  final SavedItemEntity? item;

  const SavedItemDetailPage({
    super.key,
    required this.itemId,
    this.item,
  });

  @override
  State<SavedItemDetailPage> createState() => _SavedItemDetailPageState();
}

class _SavedItemDetailPageState extends State<SavedItemDetailPage> {
  late TextEditingController _nameController;
  bool _isEditing = false;
  bool _isSaving = false;
  String? _errorText;

  SavedItemEntity? get _item {
    return widget.item ??
        context.read<SavedItemsCubit>().getItemById(widget.itemId);
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _item?.customName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _nameController.text = _item?.customName ?? '';
        _errorText = null;
      }
    });
  }

  Future<void> _saveChanges() async {
    final item = _item;
    if (item == null) return;

    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      setState(() {
        _errorText = 'El nombre es requerido';
      });
      return;
    }

    if (newName == item.customName) {
      _toggleEdit();
      return;
    }

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    final success =
    await context.read<SavedItemsCubit>().updateItemCustomName(
      itemId: item.id,
      newCustomName: newName,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      _toggleEdit();
      AppSnackbar.showSuccess(
        context: context,
        message: 'Nombre actualizado',
      );
    } else {
      AppSnackbar.showError(
        context: context,
        message: 'Error al actualizar',
      );
    }
  }

  Future<void> _deleteItem() async {
    final item = _item;
    if (item == null) return;

    final confirm = await AppDialog.showDeleteConfirmation(
      context: context,
      itemName: item.customName,
    );

    if (confirm != true || !mounted) return;

    final success =
    await context.read<SavedItemsCubit>().deleteItemById(item.id);

    if (!mounted) return;

    if (success) {
      AppSnackbar.showSuccess(
        context: context,
        message: '${item.customName} eliminado',
      );
      context.go(AppRoutes.prefs);
    } else {
      AppSnackbar.showError(
        context: context,
        message: 'Error al eliminar',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedItemsCubit, SavedItemsState>(
      builder: (context, state) {
        final item = _item;

        if (item == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const AppEmptyState(
              icon: Icons.error_outline,
              title: 'Elemento no encontrado',
              description: 'Este elemento ya no existe.',
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(item),
              SliverToBoxAdapter(
                child: _buildContent(item),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(item),
        );
      },
    );
  }

  Widget _buildSliverAppBar(SavedItemEntity item) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, size: 20),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isEditing ? Icons.close : Icons.edit,
              size: 20,
            ),
          ),
          onPressed: _toggleEdit,
        ),
        AppSpacing.gapHorizontalSm,
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          child: Hero(
            tag: 'product_${item.id}',
            child: AppNetworkImage(
              imageUrl: item.productImage,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(SavedItemEntity item) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.gapVerticalLg,

          // Category and rating row
          Row(
            children: [
              AppBadge.neutral(item.productCategory),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.tertiaryDark,
                    ),
                    AppSpacing.gapHorizontalXs,
                    AppText.labelMedium(
                      '${item.productRating}',
                      color: AppColors.tertiaryDark,
                    ),
                    AppSpacing.gapHorizontalXs,
                    AppText.labelSmall(
                      '(${item.productRatingCount})',
                      color: AppColors.neutral500,
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppSpacing.gapVerticalLg,

          // Custom name (editable)
          if (_isEditing) ...[
            AppTextField(
              label: 'Mi nombre personalizado',
              controller: _nameController,
              errorText: _errorText,
              maxLength: 100,
              autofocus: true,
              onChanged: (_) {
                if (_errorText != null) {
                  setState(() => _errorText = null);
                }
              },
            ),
            AppSpacing.gapVerticalMd,
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    label: 'Cancelar',
                    onPressed: _toggleEdit,
                  ),
                ),
                AppSpacing.gapHorizontalMd,
                Expanded(
                  child: AppButton.primary(
                    label: 'Guardar',
                    isLoading: _isSaving,
                    onPressed: _isSaving ? null : _saveChanges,
                  ),
                ),
              ],
            ),
          ] else ...[
            AppText.labelMedium(
              'Mi nombre',
              color: AppColors.neutral500,
            ),
            AppSpacing.gapVerticalXs,
            AppText.headlineSmall(item.customName),
          ],

          AppSpacing.gapVerticalXl,

          // Original name
          AppText.labelMedium(
            'Nombre original',
            color: AppColors.neutral500,
          ),
          AppSpacing.gapVerticalXs,
          AppText.titleMedium(item.productTitle),

          AppSpacing.gapVerticalXl,

          // Price
          AppText.labelMedium(
            'Precio',
            color: AppColors.neutral500,
          ),
          AppSpacing.gapVerticalXs,
          AppPriceBadge(
            price: item.productPrice,
            isLarge: true,
          ),

          AppSpacing.gapVerticalXl,

          // Description
          AppText.labelMedium(
            'Descripción',
            color: AppColors.neutral500,
          ),
          AppSpacing.gapVerticalSm,
          AppText.bodyMedium(
            item.productDescription,
            color: AppColors.neutral700,
          ),

          AppSpacing.gapVerticalXxl,
        ],
      ),
    );
  }

  Widget _buildBottomBar(SavedItemEntity item) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton.danger(
              label: 'Eliminar',
              leadingIcon: Icons.delete_outline,
              onPressed: _deleteItem,
            ),
          ),
          AppSpacing.gapHorizontalMd,
          Expanded(
            child: AppButton.outline(
              label: 'Volver',
              leadingIcon: Icons.arrow_back,
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}