import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_management/core/adaptive/responsive_helper.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final bool isOutlined;
  final bool isLoading;
  final bool fullWidth;

  const AdaptiveButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.textColor,
    this.isOutlined = false,
    this.isLoading = false,
    this.fullWidth = true,
  });

  bool get _isIOS => Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.primaryColor;
    final foregroundColor = textColor ?? Colors.white;

    final Widget buttonChild = isLoading
        ? SizedBox(
            width: ResponsiveHelper.w(20),
            height: ResponsiveHelper.w(20),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: ResponsiveHelper.sp(18), color: foregroundColor),
                ResponsiveHelper.horizontalSpace(8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(15),
                  fontWeight: FontWeight.w600,
                  color: isOutlined ? buttonColor : foregroundColor,
                ),
              ),
            ],
          );

    final double buttonHeight = ResponsiveHelper.h(50);
    final double borderRadius = ResponsiveHelper.r(12);

    if (_isIOS) {
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        height: buttonHeight,
        child: isOutlined
            ? CupertinoButton(
                padding: ResponsiveHelper.paddingH(24),
                borderRadius: BorderRadius.circular(borderRadius),
                color: Colors.transparent,
                disabledColor: Colors.transparent,
                onPressed: isLoading ? null : onPressed,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: buttonColor, width: 1.5),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  alignment: Alignment.center,
                  child: buttonChild,
                ),
              )
            : CupertinoButton.filled(
                padding: ResponsiveHelper.paddingH(24),
                borderRadius: BorderRadius.circular(borderRadius),
                disabledColor: buttonColor.withValues(alpha:0.5),
                onPressed: isLoading ? null : onPressed,
                child: buttonChild,
              ),
      );
    }

    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor, width: 1.5),
            minimumSize: Size(fullWidth ? double.infinity : 0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: ResponsiveHelper.paddingH(24),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: foregroundColor,
            disabledBackgroundColor: buttonColor.withValues(alpha:0.5),
            minimumSize: Size(fullWidth ? double.infinity : 0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: ResponsiveHelper.paddingH(24),
          );

    return isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          );
  }
}
