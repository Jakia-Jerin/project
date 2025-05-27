// import 'package:easy_stepper/easy_stepper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class SignupView extends StatefulWidget {
//   const SignupView({super.key});

//   @override
//   State<SignupView> createState() => _SignupViewState();
// }

// class _SignupViewState extends State<SignupView> {
//   late int activeStep = 0;
//   final genders = {
//     'male': 'Male',
//     'female': 'Female',
//     'other': 'Other',
//   };
//   bool passwordVisibility = false;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         AppBar(
//           elevation: 2,
//           title: Text(
//             "Sign up",
//             style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           leading: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: ShadButton.outline(
//               onPressed: () => Get.toNamed("/settings"),
//               icon: Icon(
//                 LucideIcons.chevronLeft,
//                 size: 22,
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ShadCard(
//                 padding: EdgeInsets.all(4),
//                 child: Column(
//                   children: [
//                     Container(
//                       color: Colors.red,
//                       child: EasyStepper(
                        
//                         activeStep: activeStep,
//                         activeStepTextColor: Colors.black87,
//                         finishedStepTextColor: Colors.black87,
//                         internalPadding: 20,
//                         showLoadingAnimation: true,
//                         enableStepTapping : false,
//                         stepRadius: 8,
//                         showStepBorder: true,
//                         steps: [
//                           EasyStep(
//                               customStep: Container(),
//                               title: 'Info'),
//                           EasyStep(
//                               customStep: Container(),
//                               title: 'Contact'),
//                           EasyStep(
//                               customStep: Container(),
//                               title: 'Verify'),
//                         ],
//                         onStepReached: (index) => setState(
//                           () => activeStep = index,
//                         ),
//                       ),
//                     ),
//                     Divider(
//                       height: 22,
//                     ),
//                     Visibility(
//                       visible: activeStep == 0,
//                       child: Column(
//                         children: [
//                           ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 360),
//                             child: ShadInput(
//                               prefix: const Text('Name'),
//                               placeholder: Text('Enter full name'),
//                               keyboardType: TextInputType.text,
//                             ),
//                           ),
//                           ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 360),
//                             child: ShadSelect<String>(
//                               placeholder: Text('Gender'),
//                               minWidth: double.maxFinite,
//                               shrinkWrap: true,
//                               options: [
//                                 ...genders.entries.map((e) => ShadOption(
//                                     value: e.key, child: Text(e.value))),
//                               ],
//                               selectedOptionBuilder: (context, value) {
//                                 return Text(genders['male']!);
//                               },
//                               onChanged: print,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ShadInput(
//                                   prefix: const Text('Password'),
//                                   placeholder: Text('Enter new password'),
//                                   keyboardType: TextInputType.text,
//                                   obscureText: !passwordVisibility,
//                                 ),
//                               ),
//                               ShadButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     passwordVisibility = !passwordVisibility;
//                                   });
//                                 },
//                                 size: ShadButtonSize.sm,
//                                 child:
//                                     Text(!passwordVisibility ? 'Show' : 'Hide'),
//                               )
//                             ],
//                           ),
//                           ShadButton(
//                             onPressed: () {
//                               setState(() {
//                                 activeStep = 1;
//                               });
//                             },
//                             width: double.infinity,
//                             child: Text('Next'),
//                           )
//                         ],
//                       ),
//                     ),
//                     Visibility(
//                       visible: activeStep == 1,
//                       child: Column(
//                         children: [
//                           ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 360),
//                             child: ShadInput(
//                               prefix: const Text('Email'),
//                               placeholder: Text('Enter new email'),
//                               keyboardType: TextInputType.emailAddress,
//                               obscureText: true,
//                             ),
//                           ),
//                           ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 360),
//                             child: ShadSelect<String>(
//                               placeholder: Text('Country'),
//                               minWidth: double.maxFinite,
//                               shrinkWrap: true,
//                               options: [
//                                 ...genders.entries.map((e) => ShadOption(
//                                     value: e.key, child: Text(e.value))),
//                               ],
//                               selectedOptionBuilder: (context, value) {
//                                 return Text(genders['male']!);
//                               },
//                               onChanged: print,
//                             ),
//                           ),
//                           ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 360),
//                             child: ShadInput(
//                               prefix: const Text('880'),
//                               placeholder: Text('Enter phone number'),
//                               keyboardType: TextInputType.phone,
//                               obscureText: true,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ShadButton.outline(
//                                   onPressed: () {
//                                     setState(() {
//                                       activeStep = 0;
//                                     });
//                                   },
//                                   width: double.infinity,
//                                   child: Text('Back'),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: ShadButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       activeStep = 2;
//                                     });
//                                   },
//                                   width: double.infinity,
//                                   child: Text('Next'),
//                                 ),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     Visibility(
//                       visible: activeStep == 2,
//                       child: Column(
//                         spacing: 8,
//                         children: [
//                           ShadInputOTP(
//                             onChanged: (v) => print('OTP: $v'),
//                             maxLength: 6,
//                             children: const [
//                               ShadInputOTPGroup(
//                                 children: [
//                                   ShadInputOTPSlot(),
//                                   ShadInputOTPSlot(),
//                                   ShadInputOTPSlot(),
//                                 ],
//                               ),
//                               Icon(size: 24, LucideIcons.minus),
//                               ShadInputOTPGroup(
//                                 children: [
//                                   ShadInputOTPSlot(),
//                                   ShadInputOTPSlot(),
//                                   ShadInputOTPSlot(),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             width: 280,
//                             child: Text(
//                                 'Check your email. We sent you a six digit verification code. Type the code here.'),
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ShadButton.outline(
//                                   onPressed: () {
//                                     setState(() {
//                                       activeStep = 1;
//                                     });
//                                   },
//                                   width: double.infinity,
//                                   child: Text('Back'),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: ShadButton(
//                                   onPressed: () {},
//                                   width: double.infinity,
//                                   child: Text('Done'),
//                                 ),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
