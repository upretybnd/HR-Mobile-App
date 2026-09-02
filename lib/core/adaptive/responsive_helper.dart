import 'dart:math';
import 'package:flutter/material.dart';

/// A utility class that makes your UI responsive across all screen sizes
/// and font size settings.
///
/// **How to use:**
///
/// 1. Initialize once in your app's top-level widget:
///    ```dart
///    ResponsiveHelper.init(context);
///    ```
///
/// 2. Use everywhere instead of hardcoded pixel values:
///    ```dart
///    // Width  → ResponsiveHelper.w(200)
///    // Height → ResponsiveHelper.h(50)
///    // Font   → ResponsiveHelper.sp(16)
///    // Radius → ResponsiveHelper.r(12)
///    ```
///
/// **Design base size:** 375 x 812 (iPhone 13/14 — most common Figma design size).
/// Change [_designWidth] and [_designHeight] if your designer uses a different canvas.
class ResponsiveHelper {
  // ─── Design Reference Size ───────────────────────────────────────────
  // Change these to match your Figma/XD design canvas dimensions.
  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  // ─── Actual Device Values (set during init) ──────────────────────────
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _statusBarHeight;
  static late double _bottomBarHeight;
  static late double _textScaleFactor;

  // ─── Computed Scale Factors ──────────────────────────────────────────
  static late double _scaleWidth;
  static late double _scaleHeight;
  static late double _scaleText;

  /// Call this ONCE in your top-level widget's build method.
  ///
  /// Example (in your MaterialApp or GetMaterialApp wrapper):
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   ResponsiveHelper.init(context);
  ///   return Scaffold(...);
  /// }
  /// ```
  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = mediaQuery.padding.bottom;
    _textScaleFactor = mediaQuery.textScaler.scale(1.0);

    _scaleWidth = _screenWidth / _designWidth;
    _scaleHeight = _screenHeight / _designHeight;

    // For text, use the smaller scale to prevent overflow,
    // and cap the user's system text scale to avoid extreme sizes.
    _scaleText = min(_scaleWidth, _scaleHeight);
  }

  // ─── Getters ─────────────────────────────────────────────────────────

  /// Actual device screen width in logical pixels.
  static double get screenWidth => _screenWidth;

  /// Actual device screen height in logical pixels.
  static double get screenHeight => _screenHeight;

  /// Height of the status bar (notch area).
  static double get statusBarHeight => _statusBarHeight;

  /// Height of the bottom safe area (home indicator on iPhones).
  static double get bottomBarHeight => _bottomBarHeight;

  /// The user's system text scale factor.
  static double get textScaleFactor => _textScaleFactor;

  // ─── Core Scaling Methods ────────────────────────────────────────────

  /// Scale a WIDTH value proportionally.
  ///
  /// Use for: `width`, horizontal `padding`, horizontal `margin`.
  ///
  /// ```dart
  /// Container(width: ResponsiveHelper.w(200))
  /// ```
  static double w(double width) {
    return width * _scaleWidth;
  }

  /// Scale a HEIGHT value proportionally.
  ///
  /// Use for: `height`, vertical `padding`, vertical `margin`, `SizedBox` heights.
  ///
  /// ```dart
  /// SizedBox(height: ResponsiveHelper.h(20))
  /// ```
  static double h(double height) {
    return height * _scaleHeight;
  }

  /// Scale a FONT SIZE proportionally, with a cap to prevent extreme scaling.
  ///
  /// Use for: `fontSize` in `TextStyle`.
  ///
  /// ```dart
  /// Text('Hello', style: TextStyle(fontSize: ResponsiveHelper.sp(16)))
  /// ```
  static double sp(double fontSize) {
    // Cap the text scale factor between 0.8x and 1.3x to prevent
    // the UI from breaking with very large or very small system font settings.
    final clampedTextScale = _textScaleFactor.clamp(0.8, 1.3);
    return fontSize * _scaleText * clampedTextScale;
  }

  /// Scale a RADIUS value (uses the smaller of width/height scale).
  ///
  /// Use for: `BorderRadius`, `CircularProgressIndicator` size.
  ///
  /// ```dart
  /// BorderRadius.circular(ResponsiveHelper.r(12))
  /// ```
  static double r(double radius) {
    return radius * min(_scaleWidth, _scaleHeight);
  }

  // ─── Convenience Methods ─────────────────────────────────────────────

  /// Returns symmetric horizontal padding, scaled proportionally.
  ///
  /// ```dart
  /// Padding(padding: ResponsiveHelper.paddingH(16))
  /// ```
  static EdgeInsets paddingH(double value) {
    return EdgeInsets.symmetric(horizontal: w(value));
  }

  /// Returns symmetric vertical padding, scaled proportionally.
  ///
  /// ```dart
  /// Padding(padding: ResponsiveHelper.paddingV(12))
  /// ```
  static EdgeInsets paddingV(double value) {
    return EdgeInsets.symmetric(vertical: h(value));
  }

  /// Returns padding on all sides, scaled proportionally.
  ///
  /// ```dart
  /// Padding(padding: ResponsiveHelper.paddingAll(16))
  /// ```
  static EdgeInsets paddingAll(double value) {
    return EdgeInsets.symmetric(horizontal: w(value), vertical: h(value));
  }

  /// Returns a vertical SizedBox with scaled height.
  ///
  /// ```dart
  /// ResponsiveHelper.verticalSpace(20)
  /// ```
  static SizedBox verticalSpace(double height) {
    return SizedBox(height: h(height));
  }

  /// Returns a horizontal SizedBox with scaled width.
  ///
  /// ```dart
  /// ResponsiveHelper.horizontalSpace(10)
  /// ```
  static SizedBox horizontalSpace(double width) {
    return SizedBox(width: w(width));
  }
}
