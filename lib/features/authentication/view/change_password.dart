import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/adaptive/responsive_helper.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/authentication/controller/change_password_controller.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.paddingH(24),
          child: Column(
            children: [
              ResponsiveHelper.verticalSpace(50),

              // Logo
              Container(
                width: ResponsiveHelper.w(160),
                height: ResponsiveHelper.w(80),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0,
                      offset: const Offset(0, 12),
                      blurRadius: 20,
                      color: AppColors.shadow.withValues(alpha: 0.10),
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset("assets/images/CompanyLogo.png"),
                )
              ),

              ResponsiveHelper.verticalSpace(24),

              // Title 
              Text(
                'Change Password Portal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(24),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              ResponsiveHelper.verticalSpace(36),

              // Form
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Password
                    _buildLabel('Current Password'),
                    ResponsiveHelper.verticalSpace(8),
                    Obx(() => _buildTextField(
                          controller: controller.currentPasswordController,
                          hintText: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          obscureText: controller.obscurePassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: ResponsiveHelper.sp(20),
                              color: AppColors.textHint,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          validator: controller.validatePassword,
                        )),

                    ResponsiveHelper.verticalSpace(20),

                    // New Password
                    _buildLabel('New Password'),
                    ResponsiveHelper.verticalSpace(8),
                    Obx(() => _buildTextField(
                          controller: controller.NewPasswordController,
                          hintText: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          obscureText: controller.obscurePassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: ResponsiveHelper.sp(20),
                              color: AppColors.textHint,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          validator: controller.validatePassword,
                        )),

                    ResponsiveHelper.verticalSpace(24),

                    // Change Password Button 
                    SizedBox(
                      width: double.infinity,
                      height: ResponsiveHelper.h(52),
                      child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.r(12),
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(16),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Label
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: ResponsiveHelper.sp(14),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  // Reusable Text Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        fontSize: ResponsiveHelper.sp(15),
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: ResponsiveHelper.sp(15),
          color: AppColors.textHint,
        ),
        prefixIcon: Icon(
          prefixIcon,
          size: ResponsiveHelper.sp(20),
          color: AppColors.textHint,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.background,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16),
          vertical: ResponsiveHelper.h(14),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}