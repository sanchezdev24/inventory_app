import 'package:flutter/material.dart';

import 'app_colors.dart';

/// App typography tokens
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Roboto';

  // Display styles
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );

  // Headline styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );

  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // Text theme for ThemeData
  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  static TextTheme textThemeLight = TextTheme(
    displayLarge: displayLarge.copyWith(color: AppColors.neutral900),
    displayMedium: displayMedium.copyWith(color: AppColors.neutral900),
    displaySmall: displaySmall.copyWith(color: AppColors.neutral900),
    headlineLarge: headlineLarge.copyWith(color: AppColors.neutral900),
    headlineMedium: headlineMedium.copyWith(color: AppColors.neutral900),
    headlineSmall: headlineSmall.copyWith(color: AppColors.neutral800),
    titleLarge: titleLarge.copyWith(color: AppColors.neutral800),
    titleMedium: titleMedium.copyWith(color: AppColors.neutral800),
    titleSmall: titleSmall.copyWith(color: AppColors.neutral700),
    bodyLarge: bodyLarge.copyWith(color: AppColors.neutral700),
    bodyMedium: bodyMedium.copyWith(color: AppColors.neutral600),
    bodySmall: bodySmall.copyWith(color: AppColors.neutral500),
    labelLarge: labelLarge.copyWith(color: AppColors.neutral700),
    labelMedium: labelMedium.copyWith(color: AppColors.neutral600),
    labelSmall: labelSmall.copyWith(color: AppColors.neutral500),
  );

  static TextTheme textThemeDark = TextTheme(
    displayLarge: displayLarge.copyWith(color: AppColors.neutral50),
    displayMedium: displayMedium.copyWith(color: AppColors.neutral50),
    displaySmall: displaySmall.copyWith(color: AppColors.neutral50),
    headlineLarge: headlineLarge.copyWith(color: AppColors.neutral50),
    headlineMedium: headlineMedium.copyWith(color: AppColors.neutral50),
    headlineSmall: headlineSmall.copyWith(color: AppColors.neutral100),
    titleLarge: titleLarge.copyWith(color: AppColors.neutral100),
    titleMedium: titleMedium.copyWith(color: AppColors.neutral100),
    titleSmall: titleSmall.copyWith(color: AppColors.neutral200),
    bodyLarge: bodyLarge.copyWith(color: AppColors.neutral200),
    bodyMedium: bodyMedium.copyWith(color: AppColors.neutral300),
    bodySmall: bodySmall.copyWith(color: AppColors.neutral400),
    labelLarge: labelLarge.copyWith(color: AppColors.neutral200),
    labelMedium: labelMedium.copyWith(color: AppColors.neutral300),
    labelSmall: labelSmall.copyWith(color: AppColors.neutral400),
  );
}