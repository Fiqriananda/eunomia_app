import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Icon
                    Center(
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.surface2,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          border: Border.all(color: AppColors.borderDefault),
                        ),
                        alignment: Alignment.center,
                        child: const AppSvg(
                          AppSvgIcons.eunomiaLogo,
                          size: 26,
                          color: Color(0xffFFB45D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Header Title
                    Obx(() => Text(
                          controller.isRegisterMode.value ? 'Create Account' : 'Welcome to Eunomia',
                          textAlign: TextAlign.center,
                          style: AppTheme.headlineLg,
                        )),
                    const SizedBox(height: 6),
                    Text(
                      'Minimalist project management & issue tracking',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 32),

                    // Error Banner
                    Obx(() {
                      if (controller.errorMessage.isEmpty) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.priorityTint(AppColors.priorityUrgent),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          border: Border.all(color: AppColors.priorityBorder(AppColors.priorityUrgent)),
                        ),
                        child: Row(
                          children: [
                            const AppSvg(AppSvgIcons.close, size: 14, color: AppColors.priorityUrgent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMessage.value,
                                style: AppTheme.bodySm.copyWith(color: AppColors.priorityUrgent),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Name Field (Register Mode Only)
                    Obx(() {
                      if (!controller.isRegisterMode.value) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Full Name', style: AppTheme.labelAction),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: controller.nameController,
                            style: AppTheme.bodyMd.copyWith(color: AppColors.textPrimary),
                            decoration: _inputDecoration(
                              hintText: 'John Doe',
                              prefixIcon: AppSvgIcons.user,
                            ),
                            validator: (v) {
                              if (controller.isRegisterMode.value && (v == null || v.trim().isEmpty)) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),

                    // Email Field
                    Text('Email Address', style: AppTheme.labelAction),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTheme.bodyMd.copyWith(color: AppColors.textPrimary),
                      decoration: _inputDecoration(
                        hintText: 'name@work-email.com',
                        prefixIcon: AppSvgIcons.mail,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Please enter your email';
                        if (!v.contains('@') || !v.contains('.')) return 'Invalid email address';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    Text('Password', style: AppTheme.labelAction),
                    const SizedBox(height: 6),
                    Obx(() => TextFormField(
                          controller: controller.passwordController,
                          obscureText: controller.obscurePassword.value,
                          style: AppTheme.bodyMd.copyWith(color: AppColors.textPrimary),
                          decoration: _inputDecoration(
                            hintText: controller.isRegisterMode.value ? 'At least 6 characters' : 'Enter password',
                            prefixIcon: AppSvgIcons.lock,
                            suffix: GestureDetector(
                              onTap: controller.togglePasswordVisibility,
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: AppSvg(
                                  controller.obscurePassword.value ? AppSvgIcons.eyeOff : AppSvgIcons.eye,
                                  size: 16,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Please enter your password';
                            if (controller.isRegisterMode.value && v.trim().length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        )),
                    const SizedBox(height: 24),

                    // Submit Action Button
                    Obx(() {
                      final loading = controller.isLoading.value;
                      return SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: loading ? null : controller.submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                            ),
                            elevation: 0,
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppSvg(
                                      controller.isRegisterMode.value ? AppSvgIcons.plus : AppSvgIcons.logIn,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      controller.isRegisterMode.value ? 'Create Account' : 'Sign In',
                                      style: AppTheme.labelAction.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),

                    // Mode Toggle Footnote
                    Center(
                      child: GestureDetector(
                        onTap: controller.toggleMode,
                        behavior: HitTestBehavior.opaque,
                        child: Obx(() => Text.rich(
                              TextSpan(
                                text: controller.isRegisterMode.value
                                    ? 'Already have an account? '
                                    : "Don't have an account? ",
                                style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
                                children: [
                                  TextSpan(
                                    text: controller.isRegisterMode.value ? 'Sign In' : 'Sign Up',
                                    style: AppTheme.bodySm.copyWith(
                                      color: AppColors.primaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required String prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTheme.bodyMd.copyWith(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.surface1,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: AppSvg(prefixIcon, size: 16, color: AppColors.textMuted),
      ),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
        borderSide: const BorderSide(color: AppColors.priorityUrgent),
      ),
    );
  }
}
