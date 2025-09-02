import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class VerificationMethodPage extends StatelessWidget {
  final String account;
  final authController = Get.find<AuthController>();

  VerificationMethodPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    return Scaffold(
        backgroundColor: contextTheme.colorScheme.background,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FButton.icon(
                          onPress: () => Get.toNamed("/settings/resetpass"),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                  child: Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            "We need to verify your account\n"
                            "Choose whether to receive a verification code via Email or Phone.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(height: 50),
                        FTile(
                            prefixIcon: FIcon(FAssets.icons.mail),
                            title: Text(
                              'Verify via Email',
                            ),
                            suffixIcon: FIcon(FAssets.icons.chevronRight),
                            onPress: () {
                              authController.sendOtpOrEmail(account, "email");
                              authController.forgotPassword(account);
                            }),
                        SizedBox(height: 20),
                        FTile(
                            prefixIcon: FIcon(FAssets.icons.phone),
                            title: const Text(
                              'Verify via Phone',
                            ),
                            suffixIcon: FIcon(FAssets.icons.chevronRight),
                            onPress: () {
                              // authController.sendOtpOrEmail(account, "phone");
                              //  authController.forgotPassword(account);
                              //   Get.toNamed('settings/OtpPage');
                            }),
                      ]),
                )
              ],
            ),
          ),
        )));
  }
}
