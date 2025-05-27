// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:theme_desiree/signin/signin_model.dart';
// import 'package:theme_desiree/signin/signin_view_model.dart';

// class SigninView extends StatefulWidget {
//   const SigninView({super.key});

//   @override
//   State<SigninView> createState() => _SigninViewState();
// }

// class _SigninViewState extends State<SigninView> {
//   TextEditingController identityController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool isButtonEnabled = false;
//   bool passwordVisibility = false;

//   @override
//   void initState() {
//     super.initState();
//     identityController.addListener(_updateButtonState);
//     passwordController.addListener(_updateButtonState);
//   }

//   @override
//   void dispose() {
//     identityController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   void _updateButtonState() {
//     setState(() {
//       isButtonEnabled = identityController.text.trim().length > 6 &&
//           passwordController.text.length > 6;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ShadCard(
//                 padding: EdgeInsets.all(4),
//                 child: Column(
//                   spacing: 8,
//                   children: [
//                     ShadInput(
//                       controller: identityController,
//                       prefix: const Text('Identity'),
//                       placeholder: Text('Enter email or phone'),
//                       keyboardType: TextInputType.text,
//                     ),
//                     Flex(
//                       direction: Axis.horizontal,
//                       children: [
//                         Flexible(
//                           child: ShadInput(
//                             controller: passwordController,
//                             prefix: const Text('Password'),
//                             placeholder: Text('Type your password'),
//                             keyboardType: TextInputType.text,
//                             obscureText: !passwordVisibility,
//                           ),
//                         ),
//                         ShadButton(
//                           onPressed: () {
//                             setState(() {
//                               passwordVisibility = !passwordVisibility;
//                             });
//                           },
//                           size: ShadButtonSize.sm,
//                           child: Text(!passwordVisibility ? 'Show' : 'Hide'),
//                         )
//                       ],
//                     ),
//                     ShadButton(
//                       enabled: isButtonEnabled,
//                       onPressed: () async {
//                         final SigninModel response =
//                             await SigninViewModel().tryToSign();
//                         if (context.mounted && response.error == 0) {
//                           identityController.clear();
//                           passwordController.clear();
//                           passwordVisibility = false;
//                           Get.toNamed("/settings");
//                         } else if (context.mounted && response.error != 0) {
//                           showShadDialog(
//                             context: context,
//                             builder: (context) => Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: ShadDialog.alert(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 title: const Text('Incorrect'),
//                                 description: Text(response.message),
//                                 expandActionsWhenTiny: false,
//                                 removeBorderRadiusWhenTiny: false,
//                                 radius: BorderRadius.circular(12),
//                                 descriptionTextAlign: TextAlign.start,
//                                 actionsAxis: Axis.horizontal,
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 actions: [
//                                   ShadButton.outline(
//                                     onPressed: () =>
//                                         Navigator.of(context).pop(false),
//                                     child: Text('Dismiss'),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                       width: double.infinity,
//                       child: Text('Sign in'),
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ShadButton.outline(
//                             onPressed: () => Get.toNamed("/reset"),
//                             width: double.infinity,
//                             child: Text('Reset password'),
//                           ),
//                         ),
//                         Expanded(
//                           child: ShadButton.outline(
//                             onPressed: () => Get.toNamed("/signup"),
//                             width: double.infinity,
//                             child: Text('Sign up'),
//                           ),
//                         ),
//                       ],
//                     )
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
