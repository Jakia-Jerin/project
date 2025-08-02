// import 'package:flutter/material.dart';
// import 'package:forui/forui.dart';
// import 'package:get/get.dart';
// import 'package:theme_desiree/signin_opt/phonecontroller.dart';

// class PhoneView extends StatefulWidget {
//   const PhoneView({super.key});

//   @override
//   State<PhoneView> createState() => _PhoneViewState();
// }

// class _PhoneViewState extends State<PhoneView> {
//   final phonecontroller = Get.put(Phonecontroller());

//   @override
//   Widget build(BuildContext context)
// {
//     final contextTheme = FTheme.of(context);

//     return Scaffold(
//       backgroundColor: contextTheme.colorScheme.background,
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(
//             left: 18,
//             right: 18,
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 50),

//               // Image
//               Image.asset(
//                 'assets/phone-image.png',
//                 height: 250,
//               ),

//               const SizedBox(height: 30),

//               // Title
//               Center(
//                 child: Text(
//                   'Your Phone!',
//                   style: contextTheme.typography.lg.copyWith(
//                     height: 1,
//                     fontWeight: FontWeight.bold,
//                     color: contextTheme.colorScheme.primary,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Subtitle
//               Padding(
//                 padding: const EdgeInsets.all(9.0),
//                 child: Text(
//                   'We will send you a one time password (OTP) to verify your phone number.',
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // Phone TextField
//               FTextField(
//                 keyboardType: TextInputType.phone,
//                 controller: phonecontroller.phonecontroller,
//                 hint: 'Enter Phone Number'.tr,
//                 prefixBuilder: (context, value, child) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: FIcon(FAssets.icons.phone),
//                   );
//                 },
//               ),

//              const SizedBox(height: 20),

//               // Button or OTP Sent Text
//               Obx(() {
//                 if (phonecontroller.isOtpSent.value) {
//                   return Center(
//                     child: Text(
//                       'OTP Sent!',
//                       style: TextStyle(
//                         color: contextTheme.colorScheme.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 } else {
//                   return FButton(
//                     style: FButtonStyle.primary,
//                     label: Text(
//                       'Receive OTP',
//                       style: TextStyle(
//                         color: contextTheme.colorScheme.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     onPress: phonecontroller.sendOtp,
//                   );
//                 }
//               }),

//               const SizedBox(height: 40), // Extra space at bottom
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
