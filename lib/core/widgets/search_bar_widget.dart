import 'package:flutter/material.dart';
import 'package:hr_management/core/utils/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final IconData? suffixIcon;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search here',
    this.suffixIcon,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: AppColors.disabledText),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: AppColors.textSecondary, size: 20)
            : null,
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.disabledText),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
