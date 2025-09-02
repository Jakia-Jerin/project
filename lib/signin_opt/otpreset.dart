import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class OtpResetPage extends StatelessWidget {
  final String contact;
  final TextEditingController otpController = TextEditingController();

  OtpResetPage({super.key, required this.contact});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    final recognizer = TapGestureRecognizer();
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return SafeArea(
      child: Scaffold(
          backgroundColor: contextTheme.colorScheme.background,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
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
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Image
                Image.asset(
                  'assets/phone-image.png',
                  height: 250,
                ),

                const SizedBox(height: 30),

                // Title
                Center(
                  child: Text(
                    'Your Phone!',
                    style: contextTheme.typography.lg.copyWith(
                      height: 1,
                      fontWeight: FontWeight.bold,
                      color: contextTheme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text(
                    'We will send you a one time password (OTP) to verify your ${authController.getContactLabel(contact)}',
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 5),

                // appBar: AppBar(title: const Text('Verify OTP')),
                // body: Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         'Enter the OTP sent to $contact',
                //         style: const TextStyle(fontSize: 16),
                //         textAlign: TextAlign.center,
                //       ),
                const SizedBox(height: 30),

                Pinput(
                  controller: authController.otpController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: contextTheme.colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: contextTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onCompleted: (value) {
                    authController.otpController.text = value;
                    debugPrint("Completed OTP: $value");
                  },
                ),

                const SizedBox(height: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                          text: 'Didnot get the code?',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                          children: [
                            TextSpan(
                                text: 'Resend it',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: contextTheme.colorScheme.primary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {}),
                          ]),
                    ),
                    SizedBox(height: 20),

                    //    Text('Didnot get the code? Resend it')
                  ],
                ),
                SizedBox(height: 30),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FButton(
                      style: contextTheme.buttonStyles.primary.copyWith(
                        contentStyle: contextTheme
                            .buttonStyles.primary.contentStyle
                            .copyWith(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                      ),
                      onPress: () async {
                        final otp = authController.otpController.text.trim();
                        final email =
                            authController.emailController.text.trim();
                        final phone =
                            authController.phoneController.text.trim();
                        final contact = this.contact;
                        bool verified = false;
                        if (otp.isEmpty) {
                          Get.snackbar('Error', 'Please enter OTP');
                          return;
                        }

                        final result =
                            await authController.verifyForgotToken(otp);
                        if (result != null) {
                          // Token verified successfully
                          final contact = result['phone'] ??
                              result['email']; // phone or email

                          final resetToken = otp;
                          print(" Reset Token: $resetToken");
                          print(
                              "Contact: $contact"); // Phone verification uses OTP as token
                          //   final resetToken = result['token'];

                          Get.toNamed('settings/resetpassword', arguments: {
                            'resetToken': resetToken,
                            'contact': contact
                          });

                        

                          print(" Reset Token: $resetToken");
                        } else {
                          Get.snackbar('Error', 'Invalid OTP or token expired');
                        }
                        // if (contact.contains('@')) {
                        //   verified =
                        //       await authController.verifyEmail(contact, otp);
                        // } else {
                        //   verified =
                        //       await authController.verifyPhone(contact, otp);
                        // }
                        // if (verified) {
                        //   Get.snackbar('Success', 'OTP Verified');
                        //   // Get.toNamed('/settings/resetpassword');
                        // } else {
                        //   Get.snackbar('Error', 'Invalid OTP');
                        // }
                        // Get.toNamed("settings/profile");

                        //    await authController.verifyEmail(email, otp);
                        print(" Verify button clicked");
                        print(" Email from contact: $email");
                        print(" OTP from input: $otp");
                        print(" OTP: $otp");
                        print(" Verified: $verified");

                        //  authController.signUp();
                        // Get.toNamed('settings/profile');
                      },
                      label: Text(
                        'Verify',
                        style: contextTheme.typography.sm.copyWith(
                          color: contextTheme.typography.sm.color,
                        ),
                      ),
                      // onPress: () {
                      //   final otp = authController.otpController.text.trim();
                      //   final inputOtp = otpController.text.trim();
                      //   final email = contact;
                      //   if (authController.verifyOtp(inputOtp)) {
                      //     authController.verifyEmail(email, otp);
                      //     //      Get.snackbar('Success', 'OTP Verified');

                      //     Get.toNamed("settings/resetpassword");

                      //     // Get.toNamed(
                      //     //     '/profile'); // or wherever you want to go
                      //   } else {
                      //     Get.snackbar('Error', 'Invalid OTP');
                      //   }
                      // },
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
