import 'package:flutter/material.dart';

/// "The Luminous Sanctuary" color system
/// Based on warm, organic tones — creams, ochres, and soft earths.
class AppColors {
  AppColors._();

  // ── Primary ──────────────────────────────────────
  static const primary = Color(0xFF735B40);
  static const primaryDim = Color(0xFF664F35);
  static const primaryFixed = Color(0xFFFFDDBA);
  static const primaryFixedDim = Color(0xFFF0CFAD);
  static const onPrimary = Color(0xFFFFF7F3);
  static const onPrimaryFixed = Color(0xFF513B23);
  static const onPrimaryFixedVariant = Color(0xFF6F573C);
  static const onPrimaryContainer = Color(0xFF654D33);
  static const inversePrimary = Color(0xFFFFDDBA);

  // ── Secondary ────────────────────────────────────
  static const secondary = Color(0xFF5A6064);
  static const secondaryDim = Color(0xFF4E5457);
  static const secondaryFixed = Color(0xFFDDE3E7);
  static const secondaryFixedDim = Color(0xFFCFD5D9);
  static const onSecondary = Color(0xFFF4FAFE);
  static const onSecondaryFixed = Color(0xFF3A4044);
  static const onSecondaryFixedVariant = Color(0xFF565C60);
  static const onSecondaryContainer = Color(0xFF4C5356);
  static const secondaryContainer = Color(0xFFDDE3E7);

  // ── Tertiary ─────────────────────────────────────
  static const tertiary = Color(0xFF61622D);
  static const tertiaryDim = Color(0xFF545622);
  static const tertiaryFixed = Color(0xFFFAFBB6);
  static const tertiaryFixedDim = Color(0xFFECECA9);
  static const onTertiary = Color(0xFFFDFDB8);
  static const onTertiaryFixed = Color(0xFF4C4E1B);
  static const onTertiaryFixedVariant = Color(0xFF696B35);
  static const onTertiaryContainer = Color(0xFF5F602B);
  static const tertiaryContainer = Color(0xFFFAFBB6);

  // ── Error ────────────────────────────────────────
  static const error = Color(0xFFA73B21);
  static const errorDim = Color(0xFF791903);
  static const errorContainer = Color(0xFFFD795A);
  static const onError = Color(0xFFFFF7F6);
  static const onErrorContainer = Color(0xFF6E1400);

  // ── Surfaces ─────────────────────────────────────
  static const background = Color(0xFFFBF9F5);
  static const onBackground = Color(0xFF31332F);
  static const surface = Color(0xFFFBF9F5);
  static const onSurface = Color(0xFF31332F);
  static const onSurfaceVariant = Color(0xFF5E605B);
  static const surfaceBright = Color(0xFFFBF9F5);
  static const surfaceDim = Color(0xFFDADAD4);
  static const surfaceTint = Color(0xFF735B40);
  static const surfaceVariant = Color(0xFFE3E3DC);

  // Surface containers (lowest → highest = deepest nesting)
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF5F4EF);
  static const surfaceContainer = Color(0xFFEFEEE9);
  static const surfaceContainerHigh = Color(0xFFE9E8E3);
  static const surfaceContainerHighest = Color(0xFFE3E3DC);

  // ── Outlines ─────────────────────────────────────
  static const outline = Color(0xFF7A7B76);
  static const outlineVariant = Color(0xFFB2B2AD);

  // ── Inverse ──────────────────────────────────────
  static const inverseSurface = Color(0xFF0E0E0D);
  static const inverseOnSurface = Color(0xFF9E9D99);

  // ── Dark Mode ────────────────────────────────────
  static const darkBackground = Color(0xFF1A1A18);
  static const darkSurface = Color(0xFF1A1A18);
  static const darkOnSurface = Color(0xFFE3E3DC);
  static const darkOnSurfaceVariant = Color(0xFFB2B2AD);
  static const darkSurfaceContainerLowest = Color(0xFF141413);
  static const darkSurfaceContainerLow = Color(0xFF222220);
  static const darkSurfaceContainer = Color(0xFF262624);
  static const darkSurfaceContainerHigh = Color(0xFF313130);
  static const darkSurfaceContainerHighest = Color(0xFF3B3B39);
  static const darkOutline = Color(0xFF8C8C87);
  static const darkOutlineVariant = Color(0xFF424240);

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFDDBA),
    onPrimary: Color(0xFF513B23),
    primaryContainer: primaryFixed,
    onPrimaryContainer: Color(0xFFFFDDBA),
    secondary: Color(0xFFDDE3E7),
    onSecondary: Color(0xFF3A4044),
    secondaryContainer: Color(0xFF4E5457),
    onSecondaryContainer: Color(0xFFDDE3E7),
    tertiary: Color(0xFFFAFBB6),
    onTertiary: Color(0xFF4C4E1B),
    tertiaryContainer: Color(0xFF545622),
    onTertiaryContainer: Color(0xFFFAFBB6),
    error: Color(0xFFFD795A),
    onError: Color(0xFF6E1400),
    errorContainer: Color(0xFFA73B21),
    onErrorContainer: Color(0xFFFFF7F6),
    surface: darkSurface,
    onSurface: darkOnSurface,
    surfaceContainerHighest: darkSurfaceContainerHighest,
    surfaceContainerHigh: darkSurfaceContainerHigh,
    surfaceContainerLowest: darkSurfaceContainerLowest,
    surfaceContainerLow: darkSurfaceContainerLow,
    surfaceContainer: darkSurfaceContainer,
    onSurfaceVariant: darkOnSurfaceVariant,
    outline: darkOutline,
    outlineVariant: darkOutlineVariant,
    inverseSurface: Color(0xFFE3E3DC),
    onInverseSurface: Color(0xFF1A1A18),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  // ── Semantic helpers ─────────────────────────────
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryFixed,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: onSurface,
    surfaceContainerHighest: surfaceContainerHighest,
    surfaceContainerHigh: surfaceContainerHigh,
    surfaceContainerLowest: surfaceContainerLowest,
    surfaceContainerLow: surfaceContainerLow,
    surfaceContainer: surfaceContainer,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
    inverseSurface: inverseSurface,
    onInverseSurface: inverseOnSurface,
    shadow: Color(0xFF31332F),
    scrim: Color(0xFF31332F),
  );
}
