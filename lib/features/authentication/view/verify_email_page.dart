import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/adaptive/responsive_helper.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/authentication/controller/verify_email_controller.dart';
import 'package:hr_management/features/authentication/view/login_page.dart';

class VerifyEmailPage extends StatelessWidget {
  VerifyEmailPage({super.key});

  final VerifyEmailController controller = Get.put(VerifyEmailController());

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

              ResponsiveHelper.verticalSpace(36),

              // Title
              Text(
                'Verify your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(24),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              ResponsiveHelper.verticalSpace(12),
              
              Text(
                'We have sent a verification code to your email. Please enter it below to activate your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(14),
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              ResponsiveHelper.verticalSpace(36),

              // Form
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Token Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('Verification Code'),
                        Obx(() => GestureDetector(
                          onTap: controller.isResending.value ? null : controller.onResendCode,
                          child: Text(
                            controller.isResending.value ? 'Resending...' : 'Resend Code',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(13),
                              fontWeight: FontWeight.w500,
                              color: controller.isResending.value ? AppColors.disabledText : AppColors.primary,
                            ),
                          ),
                        )),
                      ],
                    ),
                    ResponsiveHelper.verticalSpace(8),
                    _buildTextField(
                      controller: controller.tokenController,
                      hintText: 'Enter 6-digit code',
                      prefixIcon: Icons.lock_outline,
                      validator: controller.validateToken,
                    ),

                    ResponsiveHelper.verticalSpace(32),

                    // Verify Button
                    Obx(() => SizedBox(
                          width: double.infinity,
                          height: ResponsiveHelper.h(52),
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value ? null : controller.onVerify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textWhite,
                              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
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
                                    'Verify Email',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.sp(16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        )),
                        
                    ResponsiveHelper.verticalSpace(24),
                    
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.offAll(() => LoginPage()),
                        child: Text(
                          'Back to Login',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
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
