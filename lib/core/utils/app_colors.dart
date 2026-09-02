import 'package:flutter/material.dart';
class AppColors {
  AppColors._(); 

  // Primary
  static const Color primary = Color(0xFF348439);       // Main brand green
  static const Color primaryLight = Color(0xFF5DAF62);   // Lighter shade
  static const Color primaryDark = Color(0xFF1E5C22);    // Darker shade

  // Secondary
  static const Color secondary = Color(0xFFEF4444);      // Red accent
  static const Color secondaryLight = Color(0xFFF87171);  // Lighter shade
  static const Color secondaryDark = Color(0xFFDC2626);   // Darker shade

  // Background
  static const Color background = Color(0xFFFFFFFF);     // White background
  static const Color surface = Color(0xFFF3F4F6);        // Card / container white
  static const Color scaffoldBg = Color(0xFFFFFFFF);     // Scaffold background

  // Text
  static const Color textPrimary = Color(0xFF1D1D1D);    // Headings, titles
  static const Color textSecondary = Color(0xFF6B7280);  // Subtitles, labels
  static const Color textHint = Color(0xFF9CA3AF);       // Placeholder text
  static const Color textWhite = Color(0xFFFFFFFF);      // Text on dark backgrounds

  // Status / Feedback
  static const Color success = Color(0xFF22C55E);        // Approved, checked-in
  static const Color warning = Color(0xFFFBBF24);        // Pending, caution
  static const Color error = Color(0xFFEF4444);          // Rejected, error
  static const Color info = Color(0xFF3B82F6);           // Informational

  // Borders & Dividers
  static const Color border = Color(0xFFE5E7EB);         // Input borders, card borders
  static const Color divider = Color(0xFFE5E7EB);        // Divider lines

  // Shadows
  static const Color shadow = Color(0x1A000000);         // Subtle shadow (10% black)

  // Disabled 
  static const Color disabled = Color(0xFFD1D5DB);       // Disabled buttons/fields
  static const Color disabledText = Color(0xFF9CA3AF);   // Disabled text
}
