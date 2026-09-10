import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/adaptive/responsive_helper.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/authentication/controller/login_controller.dart';
import 'package:hr_management/features/authentication/view/create_account.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
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
                'Management Portal',
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
                    // Email Address
                    _buildLabel('Email Address'),
                    ResponsiveHelper.verticalSpace(8),
                    _buildTextField(
                      controller: controller.emailController,
                      hintText: 'name@company.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                    ),

                    ResponsiveHelper.verticalSpace(20),

                    // Password label + Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('Password'),
                        GestureDetector(
                          onTap: (){},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(13),
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
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

                    ResponsiveHelper.verticalSpace(16),

                    // Keep me logged in 
                    Obx(() => GestureDetector(
                          onTap: () => controller.toggleKeepMeLoggedIn(
                              !controller.keepMeLoggedIn.value),
                          child: Row(
                            children: [
                              SizedBox(
                                width: ResponsiveHelper.w(22),
                                height: ResponsiveHelper.w(22),
                                child: Checkbox(
                                  value: controller.keepMeLoggedIn.value,
                                  onChanged: controller.toggleKeepMeLoggedIn,
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.r(4),
                                    ),
                                  ),
                                  side: BorderSide(
                                    color: AppColors.border,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.w(8)),
                              Text(
                                'Keep me logged in',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.sp(14),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )),

                    ResponsiveHelper.verticalSpace(24),

                    // Login Button 
                    Obx(() => SizedBox(
                          width: double.infinity,
                          height: ResponsiveHelper.h(52),
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.onLogin,
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
                                    'Login',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.sp(16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        )),

                    ResponsiveHelper.verticalSpace(28),

                    // ENTERPRISE SSO Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: ResponsiveHelper.paddingH(16),
                          child: Text(
                            'ENTERPRISE SSO',
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

                    ResponsiveHelper.verticalSpace(20),

                    // Google Sign In
                    _buildSSOButton(
                      label: 'Google',
                      imageAsset: 'assets/images/googleLogo.jpg',
                      onTap: (){},
                    ),

                    ResponsiveHelper.verticalSpace(12),

                    // Phone Number Sign In
                    _buildSSOButton(
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      iconColor: AppColors.primary,
                      onTap: (){},
                    ),

                    ResponsiveHelper.verticalSpace(28),

                    // Don't have an account
                    Center(
                      child: GestureDetector(
                        onTap: (){
                          Get.to(()=>CreateAccount());
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(14),
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Register here',
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

  // SSO Button
  Widget _buildSSOButton({
    required String label,
    IconData? icon,
    Color? iconColor,
    String? imageAsset,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: ResponsiveHelper.h(50),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: imageAsset != null
            ? Image.asset(imageAsset, height: ResponsiveHelper.sp(22))
            : Icon(icon, size: ResponsiveHelper.sp(22), color: iconColor),
        label: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(15),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
          ),
        ),
      ),
    );
  }
}