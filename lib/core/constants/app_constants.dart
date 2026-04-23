import 'package:flutter/material.dart';

/// App-wide constants following "The Luminous Sanctuary" design system.
class AppConstants {
  AppConstants._();

  // ── Border Radius ────────────────────────────────
  static const double radiusSm = 8;
  static const double radiusDefault = 16;
  static const double radiusMd = 24;
  static const double radiusLg = 32;
  static const double radiusXl = 48;
  static const double radiusFull = 9999;

  // ── Spacing ──────────────────────────────────────
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  // ── Ambient Shadow ───────────────────────────────
  static List<BoxShadow> get ambientShadow => [
        BoxShadow(
          color: const Color(0xFF31332F).withValues(alpha: 0.06),
          blurRadius: 40,
          offset: const Offset(0, 12),
        ),
      ];

  // ── Ghost Border ─────────────────────────────────
  static Color get ghostBorderColor =>
      const Color(0xFFB2B2AD).withValues(alpha: 0.15);

  // ── Animation Durations ──────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);

  // ── Photo Grid ───────────────────────────────────
  static const int photoGridColumns = 2;
  static const double photoAspectRatio = 4 / 5;

  // ── Appwrite Config ──────────────────────────────
  static const String appwriteEndpoint = 'https://sgp.cloud.appwrite.io/v1';
  static const String appwriteProjectId = '69e702cc00061bb69bae';
  static const String appwriteDatabaseId = 'duo_db';
  static const String couplesCollectionId = 'couples';
  static const String tasksCollectionId = 'tasks';
  static const String momentsCollectionId = 'moments';
  static const String photosBucketId = 'photos';

  // ── Gemini Config ────────────────────────────────
  static const String geminiApiKey =
      String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
}
