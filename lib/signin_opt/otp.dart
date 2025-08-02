// otp_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';
import 'package:theme_desiree/signin_opt/signin_signup.dart';

class OtpPage extends StatelessWidget {
  final String contact;
  final TextEditingController otpController = TextEditingController();

  OtpPage({super.key, required this.contact});

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
                  controller: otpController,
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
                SizedBox(height: 50),

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
                      label: Text(
                        'Verify',
                        style: contextTheme.typography.sm.copyWith(
                          color: contextTheme.typography.sm.color,
                        ),
                      ),
                      onPress: () {
                        final inputOtp = otpController.text.trim();
                        if (authController.verifyOtp(inputOtp)) {
                          //      Get.snackbar('Success', 'OTP Verified');

                          Get.to(() => SigninPage());

                          // Get.toNamed(
                          //     '/profile'); // or wherever you want to go
                        } else {
                          Get.snackbar('Error', 'Invalid OTP');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
// class OtpPage extends StatelessWidget {
//   final String contact;
//   final TextEditingController otpController = TextEditingController();

//   OtpPage({super.key, required this.contact});

//   final authController = Get.find<AuthController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Verify OTP')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Text('Enter the OTP sent to $contact'),
//             SizedBox(height: 20),
//             TextField(
//               controller: otpController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: '6-digit OTP',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               child: Text('Verify'),
//               onPressed: () {
//                 if (authController.verifyOtp(otpController.text.trim())) {
//                   Get.snackbar('Success', 'OTP Verified');
//                   Get.offAllNamed('/OtpPage'); // Or wherever you want
//                 } else {
//                   Get.snackbar('Error', 'Invalid OTP');
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
