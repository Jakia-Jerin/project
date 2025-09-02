import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class ResetPassword extends StatelessWidget {
//  final String resetToken;
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    print('\x1b[32m this is onesignal api key \x1b[0m');
//    print("Reset token: $resetToken");
    final contextTheme = FTheme.of(context);
    final authController = Get.put(AuthController());
    final resetToken = Get.arguments['resetToken'];
    final contact = Get.arguments['contact'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: contextTheme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Top Bar
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FButton.icon(
                      onPress: () => Get.toNamed("/settings/verify"),
                      style: FButtonStyle.outline,
                      child: FIcon(
                        FAssets.icons.chevronLeft,
                        size: 24,
                      ),
                    ),
                    Text(
                      'Reset Password'.tr.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // 🔹 Divider
              FDivider(
                style: contextTheme.dividerStyles.verticalStyle.copyWith(
                  width: 1,
                  padding: EdgeInsets.zero,
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Main Form
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please enter your new password below.",
                      style: contextTheme.typography.sm.copyWith(
                        color: contextTheme.typography.sm.color,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Current Password Field
                    Obx(
                      () => FTextField(
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        controller: authController.resetPasswordController,
                        obscureText: authController.isresetPasswordHidden.value,
                        hint: "New Password",
                        prefixBuilder: (context, value, child) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          child: FIcon(FAssets.icons.lock),
                        ),
                        suffixBuilder: (context, value, child) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: GestureDetector(
                            onTap: () {
                              authController.isresetPasswordHidden.value =
                                  !authController.isresetPasswordHidden.value;
                            },
                            child: FIcon(
                              authController.isresetPasswordHidden.value
                                  ? FAssets.icons.eyeOff
                                  : FAssets.icons.eye,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Confirm Password Field
                    Obx(
                      () => FTextField(
                        maxLines: 1,
                        controller:
                            authController.confirmresetPasswordController,
                        obscureText: authController.isPasswordHidden.value,
                        keyboardType: TextInputType.text,
                        //   label: const Text("Confirm Password"),
                        hint: "Re-enter password",
                        prefixBuilder: (context, value, child) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          child: FIcon(FAssets.icons.lock),
                        ),
                        suffixBuilder: (context, value, child) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: GestureDetector(
                            onTap: () {
                              authController.isPasswordHidden.value =
                                  !authController.isPasswordHidden.value;
                            },
                            child: FIcon(
                              authController.isPasswordHidden.value
                                  ? FAssets.icons.eyeOff
                                  : FAssets.icons.eye,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔹 Reset Button
                    FButton(
                      onPress: () async {
                        final newPassword =
                            authController.resetPasswordController.text.trim();
                        final confirmPassword = authController
                            .confirmresetPasswordController.text
                            .trim();

                        if (newPassword.isEmpty || confirmPassword.isEmpty) {
                          Get.snackbar("Error", "Please enter password fields");
                          return;
                        }

                        if (newPassword != confirmPassword) {
                          Get.snackbar("Error", "Passwords do not match");
                          return;
                        }

                        // API call
                        bool success = await authController.resetPassword(
                            contact: contact,
                            token: resetToken,
                            newPassword: newPassword);

                        if (success) {
                          Get.snackbar(
                              "Success", "Password reset successfully");
                          Get.toNamed(
                              "settings/profile"); // Redirect to login page
                        } else {
                          Get.snackbar("Error", "Failed to reset password");
                        }

                        //    Get.snackbar("Success", "Password reset successfully");
                      },
                      style: contextTheme.buttonStyles.primary.copyWith(
                        contentStyle: contextTheme
                            .buttonStyles.primary.contentStyle
                            .copyWith(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                      label: Text(
                        "Reset Password",
                        style:
                            TextStyle(color: contextTheme.typography.sm.color),
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
}
