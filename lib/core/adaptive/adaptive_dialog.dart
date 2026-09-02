import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_management/core/adaptive/responsive_helper.dart';
import 'package:hr_management/core/utils/app_colors.dart';

class AdaptiveDialog {
  AdaptiveDialog._(); // Prevent instantiation

  static bool get _isIOS => Platform.isIOS;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    String? cancelText = 'Cancel',
    Color? confirmColor,
    bool isDismissible = true,
  }) {
    final effectiveConfirmColor = confirmColor ?? AppColors.primary;

    if (_isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        barrierDismissible: isDismissible,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: ResponsiveHelper.sp(17)),
          ),
          content: Padding(
            padding: EdgeInsets.only(top: ResponsiveHelper.h(8)),
            child: Text(
              message,
              style: TextStyle(fontSize: ResponsiveHelper.sp(13)),
            ),
          ),
          actions: [
            if (cancelText != null)
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(cancelText),
              ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                confirmText,
                style: TextStyle(color: effectiveConfirmColor),
              ),
            ),
          ],
        ),
      );
    }

    return showDialog<bool>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
        ),
        backgroundColor: AppColors.surface,
        title: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(14),
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                cancelText,
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(14),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              confirmText,
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(14),
                fontWeight: FontWeight.w600,
                color: effectiveConfirmColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmColor: confirmColor,
    );
  }

  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmText: 'OK',
      cancelText: null,
      confirmColor: AppColors.primary,
    );
  }

  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmText: 'OK',
      cancelText: null,
      confirmColor: AppColors.success,
    );
  }

  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmText: 'OK',
      cancelText: null,
      confirmColor: AppColors.error,
    );
  }

  static Future<bool?> showDestructive({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
  }) {
    if (_isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: ResponsiveHelper.sp(17)),
          ),
          content: Padding(
            padding: EdgeInsets.only(top: ResponsiveHelper.h(8)),
            child: Text(
              message,
              style: TextStyle(fontSize: ResponsiveHelper.sp(13)),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(cancelText),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(confirmText),
            ),
          ],
        ),
      );
    }

    return show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmColor: AppColors.error,
    );
  }
}
