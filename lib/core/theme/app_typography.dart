import 'package:flutter/material.dart';

/// Typography system based on "The Luminous Sanctuary" design spec.
/// Display & Headlines use Plus Jakarta Sans (editorial personality).
/// Body & Labels use Inter (friendly macOS-inspired legibility).
class AppTypography {
  AppTypography._();

  static const _headline = 'Inter';
  static const _body = 'Inter';

  /// Display styles — editorial moments
  static const TextStyle displayLg = TextStyle(
    fontFamily: _headline,
    fontSize: 57,
    fontWeight: FontWeight.w800,
    height: 1.12,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMd = TextStyle(
    fontFamily: _headline,
    fontSize: 45,
    fontWeight: FontWeight.w800,
    height: 1.16,
    letterSpacing: 0,
  );

  static const TextStyle displaySm = TextStyle(
    fontFamily: _headline,
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.22,
    letterSpacing: 0,
  );

  /// Headline styles — section headers
  static const TextStyle headlineLg = TextStyle(
    fontFamily: _headline,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: _headline,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: 0,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: _headline,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0,
  );

  /// Title styles
  static const TextStyle titleLg = TextStyle(
    fontFamily: _body,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
    letterSpacing: 0,
  );

  static const TextStyle titleMd = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSm = TextStyle(
    fontFamily: _body,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
  );

  /// Body styles — high-density information
  static const TextStyle bodyLg = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: _body,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: _body,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
  );

  /// Label styles
  static const TextStyle labelLg = TextStyle(
    fontFamily: _body,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: _body,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: _body,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
  );
}
