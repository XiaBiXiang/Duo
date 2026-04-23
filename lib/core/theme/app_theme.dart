import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// "The Luminous Sanctuary" theme configuration.
/// - Tonal layering instead of shadows
/// - No-line rule: boundaries via background color shifts
/// - Warm, organic palette
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: AppColors.lightColorScheme,
        brightness: Brightness.light,

        // ── Scaffold ───────────────────────────────
        scaffoldBackgroundColor: AppColors.background,

        // ── AppBar (glass effect) ───────────────────
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.02,
            color: AppColors.primary,
          ),
          iconTheme: IconThemeData(color: AppColors.primary),
        ),

        // ── Card ────────────────────────────────────
        cardTheme: CardThemeData(
          color: AppColors.surfaceContainerLowest,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.zero,
        ),

        // ── Elevated Button ─────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: AppTypography.labelLg,
          ),
        ),

        // ── Text Button ─────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.labelLg,
          ),
        ),

        // ── Outlined Button ─────────────────────────
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: AppTypography.labelLg,
          ),
        ),

        // ── Input Decoration ────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceContainerLow,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintStyle: AppTypography.bodyMd.copyWith(
            color: AppColors.outlineVariant,
          ),
          labelStyle: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),

        // ── Chip ────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceContainerHigh,
          selectedColor: AppColors.primary,
          labelStyle: AppTypography.labelSm,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: const StadiumBorder(),
          side: BorderSide.none,
        ),

        // ── Divider ─────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: Colors.transparent, // No-line rule
        ),

        // ── Text Theme ──────────────────────────────
        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLg,
          displayMedium: AppTypography.displayMd,
          displaySmall: AppTypography.displaySm,
          headlineLarge: AppTypography.headlineLg,
          headlineMedium: AppTypography.headlineMd,
          headlineSmall: AppTypography.headlineSm,
          titleLarge: AppTypography.titleLg,
          titleMedium: AppTypography.titleMd,
          titleSmall: AppTypography.titleSm,
          bodyLarge: AppTypography.bodyLg,
          bodyMedium: AppTypography.bodyMd,
          bodySmall: AppTypography.bodySm,
          labelLarge: AppTypography.labelLg,
          labelMedium: AppTypography.labelMd,
          labelSmall: AppTypography.labelSm,
        ),

        // ── Floating Action Button ──────────────────
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: AppColors.darkColorScheme,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.02,
            color: AppColors.primaryFixed,
          ),
          iconTheme: IconThemeData(color: AppColors.primaryFixed),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurfaceContainerLow,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryFixed,
            foregroundColor: AppColors.onPrimaryFixed,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: AppTypography.labelLg,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurfaceContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.darkOutlineVariant,
              width: 1,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintStyle: AppTypography.bodyMd.copyWith(
            color: AppColors.darkOnSurfaceVariant,
          ),
          labelStyle: AppTypography.labelMd.copyWith(
            color: AppColors.darkOnSurfaceVariant,
          ),
        ),
        dividerTheme: const DividerThemeData(color: Colors.transparent),
        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLg,
          displayMedium: AppTypography.displayMd,
          displaySmall: AppTypography.displaySm,
          headlineLarge: AppTypography.headlineLg,
          headlineMedium: AppTypography.headlineMd,
          headlineSmall: AppTypography.headlineSm,
          titleLarge: AppTypography.titleLg,
          titleMedium: AppTypography.titleMd,
          titleSmall: AppTypography.titleSm,
          bodyLarge: AppTypography.bodyLg,
          bodyMedium: AppTypography.bodyMd,
          bodySmall: AppTypography.bodySm,
          labelLarge: AppTypography.labelLg,
          labelMedium: AppTypography.labelMd,
          labelSmall: AppTypography.labelSm,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryFixed,
          foregroundColor: AppColors.onPrimaryFixed,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
}
