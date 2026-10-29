import 'package:flutter/material.dart';

/// Minimalist Obsidian & Linear-inspired Design Tokens
class AppColors {
  // Canvas & Backgrounds
  static const Color canvas = Color(0xFF090A0C);
  static const Color canvasDark = Color(0xFF060708);
  static const Color surface1 = Color(0xFF0F1115);
  static const Color surface2 = Color(0xFF15181E);
  static const Color surface3 = Color(0xFF1D212A);
  static const Color surface4 = Color(0xFF262C38);

  // Surface Tokens
  static const Color surface = Color(0xFF12141A);
  static const Color surfaceDim = Color(0xFF0F1014);
  static const Color surfaceBright = Color(0xFF2E323D);
  static const Color surfaceContainer = Color(0xFF181B22);
  static const Color surfaceContainerHigh = Color(0xFF222630);

  // Content & Typography
  static const Color onSurface = Color(0xFFEDEDF0);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD0D3DB);
  static const Color textTertiary = Color(0xFF8B92A0);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF4B5362);

  // Accent & Brand (Electric Linear Indigo)
  static const Color primary = Color(0xFF5E6AD2);
  static const Color primaryLight = Color(0xFFA5B4FC);
  static const Color primaryHover = Color(0xFF707EFC);
  static const Color primaryContainer = Color(0xFF4338CA);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Status Colors (Minimalist muted accents)
  static const Color statusBacklog = Color(0xFF6B7280);
  static const Color statusTodo = Color(0xFFE2E8F0);
  static const Color statusInProgress = Color(0xFFF59E0B);
  static const Color statusDone = Color(0xFF6366F1);
  static const Color statusCanceled = Color(0xFFEF4444);

  // Priority Colors
  static const Color priorityUrgent = Color(0xFFEF4444);
  static const Color priorityHigh = Color(0xFFF97316);
  static const Color priorityMedium = Color(0xFFEAB308);
  static const Color priorityLow = Color(0xFF6366F1);
  static const Color priorityNone = Color(0xFF64748B);

  // Hairline subtle borders
  static const Color borderDefault = Color(0x18FFFFFF);
  static const Color borderSubtle = Color(0x0EFFFFFF);
  static const Color borderFocus = Color(0x666366F1);
  static const Color borderCard = Color(0x1AFFFFFF);

  // Helper Tint Generators
  static Color priorityTint(Color baseColor) => baseColor.withValues(alpha: 0.12);
  static Color priorityBorder(Color baseColor) => baseColor.withValues(alpha: 0.28);
}
