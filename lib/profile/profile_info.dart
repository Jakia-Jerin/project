import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    final authController = Get.put(AuthController(), permanent: true);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: contextTheme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      'Account Information'.tr.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              FDivider(
                style: contextTheme.dividerStyles.verticalStyle.copyWith(
                  width: 1,
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FTile(
                  prefixIcon: FIcon(FAssets.icons.squareUser),
                  suffixIcon: FIcon(FAssets.icons.chevronRight),
                  title: Text("My Account"
                      // authController.user.value.name.isNotEmpty
                      //     ? authController.user.value.name
                      //     : 'Guest User',
                      // style: const TextStyle(fontSize: 16),
                      ),
                  onPress: () {
                    Get.toNamed("settings/editprofile");
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FTile(
                  prefixIcon: FIcon(FAssets.icons.lock),
                  title: const Text('Change Password'),
                  suffixIcon: FIcon(FAssets.icons.chevronRight),
                  onPress: () {
                    // Show the bottom sheet with proper configuration
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            decoration: BoxDecoration(
                              color: contextTheme.colorScheme.background,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 20,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Drag handle
                                      Center(
                                        child: Container(
                                          width: 40,
                                          height: 5,
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "Change Password",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Password must be at least 6 characters and include a capital letter,numbers, letters, and special characters(A!@%)",
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),

                                      // Old Password
                                      Obx(() => ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 360),
                                            child: FTextField(
                                              maxLines: 1,
                                              keyboardType: TextInputType.text,
                                              obscureText: authController
                                                  .isPasswordHidden.value,
                                              hint: "Current Password",
                                              controller: authController
                                                  .changepasswordController,
                                              suffixBuilder:
                                                  (context, value, child) =>
                                                      Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    authController
                                                            .isPasswordHidden
                                                            .value =
                                                        !authController
                                                            .isPasswordHidden
                                                            .value;
                                                  },
                                                  child: FIcon(
                                                    authController
                                                            .isPasswordHidden
                                                            .value
                                                        ? FAssets.icons.eyeOff
                                                        : FAssets.icons.eye,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(height: 15),

                                      // New Password
                                      Obx(
                                        () => ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxWidth: 360),
                                          child: FTextField(
                                            maxLines: 1,
                                            obscureText: authController
                                                .isnewPasswordHidden.value,
                                            hint: "New Password",
                                            controller: authController
                                                .newPasswordController,
                                            suffixBuilder:
                                                (context, value, child) =>
                                                    Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14),
                                              child: GestureDetector(
                                                onTap: () {
                                                  authController
                                                          .isnewPasswordHidden
                                                          .value =
                                                      !authController
                                                          .isnewPasswordHidden
                                                          .value;
                                                },
                                                child: FIcon(
                                                  authController
                                                          .isnewPasswordHidden
                                                          .value
                                                      ? FAssets.icons.eyeOff
                                                      : FAssets.icons.eye,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Confirm Password
                                      Obx(
                                        () => ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxWidth: 360),
                                          child: FTextField(
                                            maxLines: 1,
                                            obscureText: authController
                                                .isConfirmPasswordHidden.value,
                                            hint: "Confirm New Password",
                                            controller: authController
                                                .confirmPasswordController,
                                            suffixBuilder:
                                                (context, value, child) =>
                                                    Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14),
                                              child: GestureDetector(
                                                onTap: () {
                                                  authController
                                                          .isConfirmPasswordHidden
                                                          .value =
                                                      !authController
                                                          .isConfirmPasswordHidden
                                                          .value;
                                                },
                                                child: FIcon(
                                                  authController
                                                          .isConfirmPasswordHidden
                                                          .value
                                                      ? FAssets.icons.eyeOff
                                                      : FAssets.icons.eye,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      // Save Button
                                      Center(
                                        child: SizedBox(
                                          width: 200,
                                          child: FButton(
                                            onPress: () {
                                              authController.savePassword();
                                              //        Get.toNamed("/settings");
                                            },
                                            style: contextTheme
                                                .buttonStyles.primary
                                                .copyWith(
                                              contentStyle: contextTheme
                                                  .buttonStyles
                                                  .primary
                                                  .contentStyle
                                                  .copyWith(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 10,
                                                ),
                                              ),
                                            ),
                                            label: Text(
                                              'Save'.tr,
                                              style: contextTheme.typography.sm
                                                  .copyWith(
                                                color: contextTheme
                                                    .typography.sm.color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// class AccountInfoPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final contextTheme = FTheme.of(context);
//     final authController = Get.put(AuthController(), permanent: true);

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: contextTheme.colorScheme.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Row
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     FButton.icon(
//                       onPress: () => Get.toNamed("/settings"),
//                       style: FButtonStyle.outline,
//                       child: FIcon(FAssets.icons.chevronLeft, size: 24),
//                     ),
//                     Text(
//                       'Account Information'.tr.toUpperCase(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(width: 40),
//                   ],
//                 ),
//               ),

//               FDivider(
//                 style: contextTheme.dividerStyles.verticalStyle
//                     .copyWith(width: 1, padding: EdgeInsets.zero),
//               ),
//               const SizedBox(height: 20),

//               // Change Password Tile
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: FTile(
//                   prefixIcon: FIcon(FAssets.icons.lock),
//                   title: const Text('Change Password'),
//                   suffixIcon: FIcon(FAssets.icons.chevronRight),
//                   onPress: () {
//                     Get.bottomSheet(
//                       GestureDetector(
//                         onTap: () =>
//                             FocusManager.instance.primaryFocus?.unfocus(),
//                         child: SingleChildScrollView(
//                           padding: EdgeInsets.only(
//                               bottom: MediaQuery.of(context).viewInsets.bottom +
//                                   20),
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: contextTheme.colorScheme.background,
//                               borderRadius: const BorderRadius.vertical(
//                                 top: Radius.circular(20),
//                               ),
//                             ),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Drag handle
//                                 Center(
//                                   child: Container(
//                                     width: 40,
//                                     height: 5,
//                                     margin: const EdgeInsets.only(bottom: 15),
//                                     decoration: BoxDecoration(
//                                       color: contextTheme.colorScheme.primary,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 ),

//                                 const Text(
//                                   "Change Password",
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 const Text(
//                                   "Password must be at least 6 characters and include numbers, letters, and special characters(!@%)",
//                                   style: TextStyle(fontSize: 14),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(height: 16),

//                                 // Current Password
//                                 Obx(() => TextField(
//                                       controller:
//                                           authController.passwordController,
//                                       obscureText:
//                                           authController.isPasswordHidden.value,
//                                       decoration: InputDecoration(
//                                         labelText: 'Current Password',
//                                         border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                         suffixIcon: IconButton(
//                                           icon: Icon(authController
//                                                   .isPasswordHidden.value
//                                               ? Icons.visibility_off
//                                               : Icons.visibility),
//                                           onPressed: () {
//                                             authController
//                                                     .isPasswordHidden.value =
//                                                 !authController
//                                                     .isPasswordHidden.value;
//                                           },
//                                         ),
//                                       ),
//                                     )),
//                                 const SizedBox(height: 15),

//                                 // New Password
//                                 TextField(
//                                   obscureText: true,
//                                   decoration: InputDecoration(
//                                     labelText: 'New Password',
//                                     border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),

//                                 // Confirm Password
//                                 TextField(
//                                   obscureText: true,
//                                   decoration: InputDecoration(
//                                     labelText: 'Confirm New Password',
//                                     border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),

//                                 // Save Button
//                                 Center(
//                                   child: SizedBox(
//                                     width: 200,
//                                     child: FButton(
//                                       onPress: () {},
//                                       style: contextTheme.buttonStyles.primary
//                                           .copyWith(
//                                         contentStyle: contextTheme
//                                             .buttonStyles.primary.contentStyle
//                                             .copyWith(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 12, vertical: 10),
//                                         ),
//                                       ),
//                                       label: Text(
//                                         'Save'.tr,
//                                         style:
//                                             contextTheme.typography.sm.copyWith(
//                                           color:
//                                               contextTheme.typography.sm.color,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       isScrollControlled: true,
//                       backgroundColor: Colors.transparent,
//                       enableDrag: true,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AccountInfoPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final contextTheme = FTheme.of(context);
//     final authController = Get.put(AuthController(), permanent: true);

//     return Scaffold(
//       resizeToAvoidBottomInset: true, // This might be causing issues
//       backgroundColor: contextTheme.colorScheme.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     FButton.icon(
//                       onPress: () => Get.toNamed("/settings"),
//                       style: FButtonStyle.outline,
//                       child: FIcon(
//                         FAssets.icons.chevronLeft,
//                         size: 24,
//                       ),
//                     ),
//                     Text(
//                       'Account Information'.tr.toUpperCase(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(width: 40),
//                   ],
//                 ),
//               ),
//               FDivider(
//                 style: contextTheme.dividerStyles.verticalStyle.copyWith(
//                   width: 1,
//                   padding: EdgeInsets.zero,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: FTile(
//                   prefixIcon: FIcon(FAssets.icons.lock),
//                   title: const Text('Change Password'),
//                   suffixIcon: FIcon(FAssets.icons.chevronRight),
//                   onPress: () {

//                     Get.bottomSheet(
//                       // Use SingleChildScrollView with proper configuration
//                       SingleChildScrollView(
//                         //   padding: const EdgeInsets.only(bottom: 20),
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                             bottom: MediaQuery.of(context).viewInsets.bottom,
//                           ),
//                           child: Container(
//                             padding: const EdgeInsets.only(
//                               left: 16,
//                               right: 16,
//                               //   top: 16,
//                               //  bottom: 20,
//                             ),
//                             decoration: BoxDecoration(
//                               color: contextTheme.colorScheme.background,
//                               borderRadius: BorderRadius.vertical(
//                                 top: Radius.circular(20),
//                               ),
//                             ),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Center(
//                                 //   child: Icon(
//                                 //     FAssets.icons.lock,
//                                 //     size: 50,
//                                 //     color: contextTheme.colorScheme.primary,
//                                 //   ),
//                                 // ),
//                                 const SizedBox(height: 12),
//                                 const Text(
//                                   "Change Password",
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 const Text(
//                                   "Password must be at least 6 characters and include numbers, letters, and special characters(!@%)",
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                                 const SizedBox(height: 16),

//                                 // Old Password
//                                 Obx(() => ConstrainedBox(
//                                       constraints:
//                                           const BoxConstraints(maxWidth: 360),
//                                       child: FTextField(
//                                         maxLines: 1,
//                                         keyboardType: TextInputType.text,
//                                         obscureText: authController
//                                             .isPasswordHidden.value,
//                                         hint: "Current Password",
//                                         controller:
//                                             authController.passwordController,
//                                         suffixBuilder:
//                                             (context, value, child) => Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 14),
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               authController
//                                                       .isPasswordHidden.value =
//                                                   !authController
//                                                       .isPasswordHidden.value;
//                                             },
//                                             child: FIcon(
//                                               authController
//                                                       .isPasswordHidden.value
//                                                   ? FAssets.icons.eyeOff
//                                                   : FAssets.icons.eye,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     )),
//                                 const SizedBox(height: 15),

//                                 // New Password
//                                 FTextField(
//                                   maxLines: 1,
//                                   obscureText: true,
//                                   hint: "New Password",
//                                 ),
//                                 const SizedBox(height: 12),

//                                 // Confirm Password
//                                 FTextField(
//                                   maxLines: 1,
//                                   obscureText: true,
//                                   hint: "Confirm New Password",
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Padding(
//                                     padding: const EdgeInsets.all(20.0),
//                                     child: FButton(
//                                       onPress: () {},
//                                       style: contextTheme.buttonStyles.primary
//                                           .copyWith(
//                                         contentStyle: contextTheme
//                                             .buttonStyles.primary.contentStyle
//                                             .copyWith(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: 12,
//                                             vertical: 10,
//                                           ),
//                                         ),
//                                       ),
//                                       label: Text(
//                                         'Save'.tr,
//                                         style:
//                                             contextTheme.typography.sm.copyWith(
//                                           color:
//                                               contextTheme.typography.sm.color,
//                                         ),
//                                       ),
//                                     )),

//                                 const SizedBox(height: 10), // Added extra space
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       isScrollControlled: true,
//                       backgroundColor: Colors.transparent, // This is important
//                       // Prevent gray box
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
