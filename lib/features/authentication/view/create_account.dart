import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/adaptive/responsive_helper.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/authentication/controller/create_account_controller.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAccountController());
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.paddingH(24),
          child: Column(
            children: [
              ResponsiveHelper.verticalSpace(40),

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
                'Create your professional\nportal account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(22),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),

              ResponsiveHelper.verticalSpace(32),

              // Form
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name
                    _buildLabel('Full Name'),
                    ResponsiveHelper.verticalSpace(8),
                    _buildTextField(
                      controller: controller.fullnameController,
                      hintText: 'John Doe',
                      prefixIcon: Icons.person_outline,
                      validator: controller.validateFullname,
                    ),

                    ResponsiveHelper.verticalSpace(16),

                    // Email Address
                    _buildLabel('Email Address'),
                    ResponsiveHelper.verticalSpace(8),
                    _buildTextField(
                      controller: controller.emailController,
                      hintText: 'john@company.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                    ),

                    ResponsiveHelper.verticalSpace(16),

                    // Department Dropdown
                    _buildLabel('Department'),
                    ResponsiveHelper.verticalSpace(8),
                    _buildDropdown(controller),

                    ResponsiveHelper.verticalSpace(16),

                    // Password
                    _buildLabel('Password'),
                    ResponsiveHelper.verticalSpace(8),
                    Obx(() => _buildTextField(
                          controller: controller.passwordController,
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

                    // Create Account Button
                    Obx(() => SizedBox(
                          width: double.infinity,
                          height: ResponsiveHelper.h(52),
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value ? null : controller.onCreateAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textWhite,
                              disabledBackgroundColor:
                                  AppColors.primary.withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.r(12),
                                ),
                              ),
                              elevation: 0,
                            ),
                            child: controller.isLoading.value
                                ? SizedBox(
                                    width: ResponsiveHelper.w(20),
                                    height: ResponsiveHelper.w(20),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.sp(16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        )),

                    ResponsiveHelper.verticalSpace(16),
                  ],
                ),
              ),

              // SECURE REGISTRATION
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: ResponsiveHelper.paddingH(16),
                          child: Text(
                            'SECURE REGISTRATION',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(11),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textHint,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.border)),
                      ],
                    ),

                    ResponsiveHelper.verticalSpace(16),

                    // Already have account
                    Center(
                      child: GestureDetector(
                        onTap: controller.onLoginTap,
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(14),
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login here',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(28),
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

  // Department Dropdown
  Widget _buildDropdown(CreateAccountController controller) {
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedDepartment.value,
          hint: Text(
            'Select your department',
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(15),
              color: AppColors.textHint,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textHint,
            size: ResponsiveHelper.sp(24),
          ),
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(15),
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.business_outlined,
              size: ResponsiveHelper.sp(20),
              color: AppColors.textHint,
            ),
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
          ),
          items: controller.departments.map((dept) {
            return DropdownMenuItem<String>(
              value: dept,
              child: Text(dept),
            );
          }).toList(),
          onChanged: controller.setDepartment,
          validator: controller.validateDepartment,
        ));
  }
}