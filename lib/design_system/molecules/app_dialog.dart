import 'package:flutter/material.dart';

import '../atoms/atoms.dart';
import '../tokens/tokens.dart';

/// Custom dialog molecule
class AppDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final bool isDanger;

  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      child: Padding(
        padding: AppSpacing.paddingXxl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText.titleLarge(
              title,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppSpacing.gapVerticalMd,
              AppText.bodyMedium(
                message!,
                textAlign: TextAlign.center,
                color: AppColors.neutral600,
              ),
            ],
            if (content != null) ...[
              AppSpacing.gapVerticalLg,
              content!,
            ],
            AppSpacing.gapVerticalXl,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (secondaryActionLabel != null)
                  Expanded(
                    child: AppButton.outline(
                      label: secondaryActionLabel!,
                      onPressed: onSecondaryAction ?? () => Navigator.pop(context),
                    ),
                  ),
                if (secondaryActionLabel != null && primaryActionLabel != null)
                  AppSpacing.gapHorizontalMd,
                if (primaryActionLabel != null)
                  Expanded(
                    child: isDanger
                        ? AppButton.danger(
                      label: primaryActionLabel!,
                      onPressed: onPrimaryAction,
                    )
                        : AppButton.primary(
                      label: primaryActionLabel!,
                      onPressed: onPrimaryAction,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show confirmation dialog
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        primaryActionLabel: confirmLabel,
        onPrimaryAction: () => Navigator.pop(context, true),
        secondaryActionLabel: cancelLabel,
        onSecondaryAction: () => Navigator.pop(context, false),
        isDanger: isDanger,
      ),
    );
  }

  /// Show delete confirmation dialog
  static Future<bool?> showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
  }) {
    return showConfirmation(
      context: context,
      title: 'Eliminar elemento',
      message: '¿Estás seguro de que deseas eliminar "$itemName"? Esta acción no se puede deshacer.',
      confirmLabel: 'Eliminar',
      cancelLabel: 'Cancelar',
      isDanger: true,
    );
  }
}

/// Snackbar helper
class AppSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: isError ? AppColors.error : AppColors.neutral800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        margin: AppSpacing.screenPadding,
        duration: duration,
        action: action,
      ),
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            AppSpacing.gapHorizontalSm,
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        margin: AppSpacing.screenPadding,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    show(context: context, message: message, isError: true);
  }
}