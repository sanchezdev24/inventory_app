import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Text variants for the app
enum AppTextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

/// Reusable text atom
class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final TextDecoration? decoration;

  const AppText(
      this.text, {
        super.key,
        this.variant = AppTextVariant.bodyMedium,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.fontWeight,
        this.letterSpacing,
        this.decoration,
      });

  // Factory constructors for common variants
  const AppText.displayLarge(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.displayLarge;

  const AppText.displayMedium(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.displayMedium;

  const AppText.headlineLarge(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.headlineLarge;

  const AppText.headlineMedium(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.headlineMedium;

  const AppText.headlineSmall(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.headlineSmall;

  const AppText.titleLarge(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.titleLarge;

  const AppText.titleMedium(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.titleMedium;

  const AppText.titleSmall(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.titleSmall;

  const AppText.bodyLarge(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.bodyLarge;

  const AppText.bodyMedium(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.bodyMedium;

  const AppText.bodySmall(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.bodySmall;

  const AppText.labelLarge(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.labelLarge;

  const AppText.labelMedium(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.labelMedium;

  const AppText.labelSmall(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.fontWeight, this.letterSpacing, this.decoration})
      : variant = AppTextVariant.labelSmall;

  TextStyle _getStyle() {
    switch (variant) {
      case AppTextVariant.displayLarge:
        return AppTypography.displayLarge;
      case AppTextVariant.displayMedium:
        return AppTypography.displayMedium;
      case AppTextVariant.displaySmall:
        return AppTypography.displaySmall;
      case AppTextVariant.headlineLarge:
        return AppTypography.headlineLarge;
      case AppTextVariant.headlineMedium:
        return AppTypography.headlineMedium;
      case AppTextVariant.headlineSmall:
        return AppTypography.headlineSmall;
      case AppTextVariant.titleLarge:
        return AppTypography.titleLarge;
      case AppTextVariant.titleMedium:
        return AppTypography.titleMedium;
      case AppTextVariant.titleSmall:
        return AppTypography.titleSmall;
      case AppTextVariant.bodyLarge:
        return AppTypography.bodyLarge;
      case AppTextVariant.bodyMedium:
        return AppTypography.bodyMedium;
      case AppTextVariant.bodySmall:
        return AppTypography.bodySmall;
      case AppTextVariant.labelLarge:
        return AppTypography.labelLarge;
      case AppTextVariant.labelMedium:
        return AppTypography.labelMedium;
      case AppTextVariant.labelSmall:
        return AppTypography.labelSmall;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = _getStyle();

    return Text(
      text,
      style: baseStyle.copyWith(
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        decoration: decoration,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }
}