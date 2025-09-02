import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: contextTheme.colorScheme.background,

      //   appBar: AppBar(title: Text("Reset Password")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FButton.icon(
                          onPress: () => Get.toNamed("/settings"),
                          style: FButtonStyle.outline,
                          child: FIcon(
                            FAssets.icons.chevronLeft,
                            size: 24,
                          ),
                        )
                      ]),
                ),
                FDivider(
                  style: contextTheme.dividerStyles.verticalStyle.copyWith(
                    width: 1,
                    padding: EdgeInsets.zero,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reset Password",
                        style: contextTheme.typography.lg.copyWith(
                            fontWeight: FontWeight.bold,
                            color: contextTheme.colorScheme.primary),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        "Please enter the account that you want to reset the password",
                        style: contextTheme.typography.sm,
                      ),
                      const SizedBox(height: 24),

                      // Account Input
                      FTextField(
                        controller: authController.accountController,
                        hint: "Enter email or phone",
                        prefixBuilder: (context, value, child) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          child: FIcon(FAssets.icons.mail),
                        ),
                      ),
                      const SizedBox(height: 100),

                      // Continue Button
                      FButton(
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
                        onPress: () {
                          final account =
                              authController.accountController.text.trim();
                          if (account.isNotEmpty) {
                            authController.forgotPassword(account);
                            // Get.toNamed(
                            //   "settings/otpreset",
                            //   arguments: {"contact": account},
                            // );
                          } else {
                            Get.snackbar(
                                "Error", "Please enter email or phone");
                          }
                          print("Sending request for account: $account");
                          Get.toNamed("settings/Otpresetpage");
                          //   Get.toNamed("/settings/verify");

                          // Get.to(() => VerificationMethodPage(
                          //     account: authController.accountController.text));
                        },
                        label: Text("Continue"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
