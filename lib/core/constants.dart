import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle heading1(BuildContext context) => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: Theme.of(context).colorScheme.onSurface,
    letterSpacing: -0.5,
  );

  static TextStyle heading2(BuildContext context) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
    letterSpacing: -0.3,
  );

  static TextStyle heading3(BuildContext context) => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle body(BuildContext context) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle label(BuildContext context) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    letterSpacing: 0.5,
  );

  static TextStyle amount(BuildContext context) => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: Theme.of(context).colorScheme.primary,
    letterSpacing: -0.5,
  );

  static TextStyle amountSmall(BuildContext context) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const double full = 999;
}
