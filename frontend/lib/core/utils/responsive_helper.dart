import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Mobile-first design - optimized for Android/iOS only

  // Legacy compatibility method - always returns mobile value
  static double getValue(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return mobile; // Always return mobile value for mobile-only app
  }

  // Responsive padding
  static EdgeInsets getPagePadding(BuildContext context) {
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }

  static EdgeInsets getCardPadding(BuildContext context) {
    return const EdgeInsets.all(12);
  }

  static EdgeInsets getCardMargin(BuildContext context) {
    return const EdgeInsets.only(bottom: 12);
  }

  // Responsive spacing
  static double getSpacing(BuildContext context, {String size = 'medium'}) {
    switch (size) {
      case 'small':
        return 4;
      case 'medium':
        return 8;
      case 'large':
        return 16;
      default:
        return 8;
    }
  }

  // Responsive font sizes
  static double getTitle1(BuildContext context) => 20;

  static double getTitle2(BuildContext context) => 18;

  static double getHeadline(BuildContext context) => 16;

  static double getBody(BuildContext context) => 13;

  static double getCaption(BuildContext context) => 11;

  // Responsive app bar height
  static double getAppBarHeight(BuildContext context) => 80;

  // Responsive icon size
  static double getIconSize(BuildContext context, {String size = 'medium'}) {
    switch (size) {
      case 'small':
        return 18;
      case 'medium':
        return 22;
      case 'large':
        return 28;
      default:
        return 22;
    }
  }

  // Responsive border radius
  static double getBorderRadius(
    BuildContext context, {
    String size = 'medium',
  }) {
    switch (size) {
      case 'small':
        return 8;
      case 'medium':
        return 12;
      case 'large':
        return 16;
      default:
        return 12;
    }
  }

  // Grid column count for responsive layouts
  static int getGridColumns(BuildContext context) => 1;

  // Responsive grid column count for specific layouts
  static int getMatchGridColumns(BuildContext context) => 1;
}
