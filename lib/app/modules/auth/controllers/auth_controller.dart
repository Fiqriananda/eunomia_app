import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final ApiService api = ApiService.to;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isRegisterMode = false.obs;
  final obscurePassword = true.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (emailController.text.isEmpty) {
      emailController.text = '';
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  void toggleMode() {
    isRegisterMode.value = !isRegisterMode.value;
    errorMessage.value = '';
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    errorMessage.value = '';
    isLoading.value = true;

    try {
      bool success = false;
      if (isRegisterMode.value) {
        success = await api.register(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text.trim(),
        );
      } else {
        success = await api.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }

      if (success) {
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        errorMessage.value = 'Authentication failed. Please verify credentials.';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
