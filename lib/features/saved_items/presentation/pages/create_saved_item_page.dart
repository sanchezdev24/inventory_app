import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/design_system.dart';
import '../../../api_products/domain/entities/product_entity.dart';
import '../../../api_products/presentation/cubit/cubit.dart';
import '../cubit/cubit.dart';

/// Page to create a new saved item with custom name
class CreateSavedItemPage extends StatefulWidget {
  final ProductEntity? product;

  const CreateSavedItemPage({super.key, this.product});

  @override
  State<CreateSavedItemPage> createState() => _CreateSavedItemPageState();
}

class _CreateSavedItemPageState extends State<CreateSavedItemPage> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.title ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (widget.product == null) return;

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorText = 'El nombre es requerido';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    final success = await context.read<SavedItemsCubit>().saveProductWithCustomName(
      product: widget.product!,
      customName: name,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      // Update API products to hide this product
      context.read<ApiProductsCubit>().updateSavedProductIds(
        context.read<SavedItemsCubit>().savedProductIds,
      );

      AppSnackbar.showSuccess(
        context: context,
        message: '¡Guardado exitosamente!',
      );
      context.pop();
    } else {
      AppSnackbar.showError(
        context: context,
        message: 'Error al guardar',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: const AppEmptyState(
          icon: Icons.error_outline,
          title: 'Producto no encontrado',
          description: 'No se pudo cargar la información del producto.',
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const AppText.titleMedium('Guardar Producto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product preview
            _buildProductPreview(product),

            // Form
            Padding(
              padding: AppSpacing.screenPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSpacing.gapVerticalLg,

                    AppTextField(
                      label: 'Nombre personalizado',
                      hint: 'Ej: Mi producto favorito',
                      controller: _nameController,
                      errorText: _errorText,
                      maxLength: 100,
                      onChanged: (_) {
                        if (_errorText != null) {
                          setState(() {
                            _errorText = null;
                          });
                        }
                      },
                    ),

                    AppSpacing.gapVerticalSm,

                    AppText.bodySmall(
                      'Dale un nombre personalizado a este producto para identificarlo fácilmente.',
                      color: AppColors.neutral500,
                    ),

                    AppSpacing.gapVerticalXxl,

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.outline(
                            label: 'Cancelar',
                            onPressed: () => context.pop(),
                          ),
                        ),
                        AppSpacing.gapHorizontalMd,
                        Expanded(
                          child: AppButton.primary(
                            label: 'Guardar',
                            leadingIcon: Icons.favorite,
                            isLoading: _isSaving,
                            onPressed: _isSaving ? null : _saveItem,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductPreview(ProductEntity product) {
    return Container(
      margin: AppSpacing.screenPadding,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusMd,
            child: Container(
              width: 80,
              height: 80,
              color: Colors.white,
              child: AppNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          AppSpacing.gapHorizontalMd,

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBadge.neutral(product.category, isSmall: true),
                AppSpacing.gapVerticalSm,
                AppText.titleSmall(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.gapVerticalSm,
                Row(
                  children: [
                    AppPriceBadge(price: product.price),
                    const Spacer(),
                    Icon(
                      Icons.star,
                      size: 14,
                      color: AppColors.tertiary,
                    ),
                    AppSpacing.gapHorizontalXs,
                    AppText.labelSmall(
                      '${product.rating.rate}',
                      color: AppColors.neutral600,
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