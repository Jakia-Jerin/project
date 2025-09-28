import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/settings.dart';
import 'package:theme_desiree/profile/profile_controller.dart';
import 'package:theme_desiree/profile/userprofile_model.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  final accountController = Get.put(SettingsController());
  final authController = Get.put(AuthController());
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: contextTheme.colorScheme.background,
      ),
      child: Obx(() {
        if (!authController.isLoggedIn.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Column(
                children: [
                  Image.asset(
                      'assets/ee0edf14-208d-4815-84d7-012ff6bf5189-removebg-preview.png'),
                  FButton(
                    onPress: () => Get.toNamed('/settings/profile'),
                    style: contextTheme.buttonStyles.primary,
                    label: Text(
                      'Sign up or Log in'.tr,
                      style: contextTheme.typography.sm.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final profile = controller.profile.value;

        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Account'.tr.toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),

            FDivider(
              style: contextTheme.dividerStyles.verticalStyle
                  .copyWith(width: 1, padding: EdgeInsets.zero),
            ),
            const SizedBox(height: 10),

            // Profile info row
            if (profile != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(
                    //   authController.userEmailOrPhone.value,
                    //   style: contextTheme.typography.sm.copyWith(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 20,
                    //   ),
                    // ),
                    Obx(() => Text(
                          authController.userEmailOrPhone.value.isNotEmpty
                              ? authController.userEmailOrPhone.value
                              : "Guest User",
                          style: contextTheme.typography.sm.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.5,
                            minChildSize: 0.3,
                            maxChildSize: 0.9,
                            builder: (_, scrollController) => Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 50,
                                        height: 5,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    // Center(
                                    //   child: Stack(
                                    //     children: [
                                    //       CircleAvatar(
                                    //         radius: 50,
                                    //         backgroundImage:
                                    //             NetworkImage(profile.avatar),
                                    //       ),
                                    //       Positioned(
                                    //         right: 0,
                                    //         bottom: 0,
                                    //         child: GestureDetector(
                                    //           // onTap: () => pickAvatar(
                                    //           //     controller.updateAvatar),
                                    //           child: Container(
                                    //             decoration: BoxDecoration(
                                    //               color: Colors.blue,
                                    //               shape: BoxShape.circle,
                                    //             ),
                                    //             padding:
                                    //                 const EdgeInsets.all(6),
                                    //             child: const Icon(
                                    //               Icons.edit,
                                    //               color: Colors.white,
                                    //               size: 20,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),

                                    ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 360),
                                      child: FTextField(
                                        readOnly: true,
                                        onChange: (value) {
                                          controller.profile.value?.name ?? '';
                                        },
                                        initialValue:
                                            controller.profile.value?.name ??
                                                "",
                                        // hint: 'Enter your full name',
                                        //  keyboardType: TextInputType.text,
                                        prefixBuilder:
                                            (context, value, child) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child:
                                              FIcon(FAssets.icons.userRoundPen),
                                        ),
                                      ),
                                      // child: FTextField(
                                      //   controller: TextEditingController(
                                      //       text: profile.name),

                                      //     //   prefixIcon: FIcon(FAssets.icons.user),
                                      //     label: Text("Name"),

                                      //   ),
                                    ),

                                    const SizedBox(height: 12),
                                    if (profile.email.data.isNotEmpty)
                                      ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 360),
                                        child: FTextField(
                                          readOnly: true,
                                          onChange: (value) {
                                            controller
                                                .profile.value?.email.data;
                                          },
                                          initialValue: controller
                                                  .profile.value?.email.data ??
                                              "",

                                          // hint: 'Enter your full name',
                                          //  keyboardType: TextInputType.text,
                                          prefixBuilder:
                                              (context, value, child) =>
                                                  Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14),
                                            child: FIcon(FAssets.icons.mail),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 12),
                                    if (profile.phone.data.isNotEmpty)
                                      ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 360),
                                        child: FTextField(
                                          readOnly: true,
                                          onChange: (value) {
                                            controller
                                                .profile.value?.phone.data;
                                          },
                                          initialValue: controller
                                                  .profile.value?.phone.data ??
                                              "",

                                          // hint: 'Enter your full name',
                                          //  keyboardType: TextInputType.text,
                                          prefixBuilder:
                                              (context, value, child) =>
                                                  Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14),
                                            child:
                                                FIcon(FAssets.icons.phoneCall),
                                          ),
                                        ),
                                      ),

                                    //   const SizedBox(height: 12),
                                    ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 360),
                                      child: FTextField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: profile.gender == Gender.male
                                                ? "Male"
                                                : "Female"),
                                        prefixBuilder:
                                            (context, value, child) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child: FIcon(FAssets.icons.user),
                                        ),
                                        // prefixIcon: Image.asset(
                                        //   profile.gender == Gender.male
                                        //       ? 'assets/male-removebg-preview.png'
                                        //       : 'assets/female-removebg-preview.png',
                                        //   width: 25,
                                        //   height: 25,
                                        // ),
                                        // label: Text("Gender"),
                                      ),
                                    ),

                                    // child: FTextField(
                                    //   controller: TextEditingController(
                                    //       text: profile.name),

                                    //     //   prefixIcon: FIcon(FAssets.icons.user),
                                    //     label: Text("Name"),

                                    //   ),

                                    // TextField(
                                    //   controller: TextEditingController(
                                    //       text: profile.email.data),
                                    //   decoration: InputDecoration(
                                    //     //   prefixIcon: FIcon(FAssets.icons.mail),
                                    //     labelText: "Email",
                                    //     border: OutlineInputBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(12),
                                    //     ),
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 12),
                                    // if (profile.phone.data.isNotEmpty)
                                    //   TextField(
                                    //     controller: TextEditingController(
                                    //         text: profile.phone.data),
                                    //     decoration: InputDecoration(
                                    //       prefixIcon:
                                    //           FIcon(FAssets.icons.phoneCall),
                                    //       labelText: "Phone",
                                    //       border: OutlineInputBorder(
                                    //         borderRadius:
                                    //             BorderRadius.circular(12),
                                    //       ),
                                    //     ),
                                    //   ),

                                    // SizedBox(
                                    //   width: double.infinity,
                                    //   child: ElevatedButton(
                                    //     onPressed: () {
                                    //       // TODO: call controller.updateProfile()
                                    //       Get.back();
                                    //     },
                                    //     style: ElevatedButton.styleFrom(
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius:
                                    //             BorderRadius.circular(12),
                                    //       ),
                                    //       padding: const EdgeInsets.symmetric(
                                    //           vertical: 14),
                                    //     ),
                                    //     child: const Text(
                                    //       "Save Changes",
                                    //       style: TextStyle(fontSize: 16),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );

                        //  Get.toNamed('settings/userme');
                      },
                      child: FIcon(FAssets.icons.circleUser,
                          size: 25, color: Colors.black),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            FDivider(
              style: contextTheme.dividerStyles.verticalStyle
                  .copyWith(width: 1, padding: EdgeInsets.zero),
            ),

            // Profile info row
            // if (profile != null)
            //   Padding(
            //     padding: const EdgeInsets.all(12.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           authController.userEmailOrPhone.value,
            //           style: contextTheme.typography.sm.copyWith(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 20,
            //           ),
            //         ),
            //         FIcon(FAssets.icons.circleUser,
            //             size: 25, color: Colors.black),
            //       ],
            //     ),
            //   ),

            // Menus + logout
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GetX<SettingsController>(
                      builder: (controller) {
                        return FTileGroup.builder(
                          count: controller.profileMenus.length,
                          tileBuilder: (context, index) {
                            final item = controller.profileMenus[index];
                            return FTile(
                              onPress: () => Get.toNamed(item.route),
                              title: Text(item.title.tr),
                              subtitle: Text(item.subtitle.tr),
                              prefixIcon: item.icon,
                              suffixIcon: FIcon(FAssets.icons.chevronRight),
                            );
                          },
                          divider: FTileDivider.full,
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Logout tile
                    FTile(
                      onPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Log out'),
                              content: const Text(
                                  'Are you sure you want to log out?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    authController.logout();
                                    Get.offAllNamed('/');
                                  },
                                  child: const Text('LOG OUT'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      title: Text(
                        "Logout".tr,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      prefixIcon: FIcon(
                        FAssets.icons.logOut,
                        size: 22,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      suffixIcon: FIcon(
                        FAssets.icons.chevronRight,
                        size: 22,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Version info
                    Text(
                      'Version 10.2.3',
                      style: contextTheme.typography.xs.copyWith(
                        fontStyle: FontStyle.italic,
                        color: contextTheme.colorScheme.secondaryForeground
                            .withAlpha(80),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}


// class Settings extends StatelessWidget {
//   Settings({super.key});

//   final accountController = Get.put(SettingsController());
//   final authController = Get.put(AuthController());

//   final controller = Get.put(ProfileController());
//   @override
//   Widget build(BuildContext context) {
//     final contextTheme = FTheme.of(context);
//     final profile = controller.profile.value;
//     return Container(
//       decoration: BoxDecoration(
//         color: contextTheme.colorScheme.background,
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Account'.tr.toUpperCase(),
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//                 ),
//               ],
//             ),
//           ),
//           FDivider(
//             style: FTheme.of(context)
//                 .dividerStyles
//                 .verticalStyle
//                 .copyWith(width: 1, padding: EdgeInsets.zero),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Obx(() {
//             // if (!authController.isLoggedIn.value) {
//             //   return Center(
//             //     child: Column(
//             //       mainAxisAlignment: MainAxisAlignment.center,
//             //       children: [
//             //         FIcon(FAssets.icons.lock, size: 80),
//             //         SizedBox(height: 16),
//             //         Text(
//             //           "Please login to view your orders",
//             //           style: TextStyle(fontSize: 18),
//             //           textAlign: TextAlign.center,
//             //         ),
//             //         SizedBox(height: 16),
//             //         Padding(
//             //           padding: const EdgeInsets.all(20.0),
//             //           child: FButton(
//             //             style: FButtonStyle.primary,
//             //             onPress: () => Get.toNamed("/settings/profile"),
//             //             label: Text("Login Now",
//             //                 style: contextTheme.typography.sm),
//             //           ),
//             //         ),
//             //       ],
//             //     ),
//             //   );
//             // }
           
//             if (authController.isLoggedIn.value && profile != null) {
//               return Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Text(
//                     //   "Logged in as",
//                     //   style: contextTheme.typography.sm.copyWith(
//                     //     fontWeight: FontWeight.bold,
//                     //   ),
//                     // ),
//                     // SizedBox(height: 6),
//                     Text(
//                       authController.userEmailOrPhone.value,
//                       style: contextTheme.typography.sm
//                           .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),

//                     GestureDetector(
//                       onTap: () {
//                         showModalBottomSheet(
//                           context: context,
//                           isScrollControlled: true,
//                           backgroundColor: Colors.transparent,
//                           builder: (context) => DraggableScrollableSheet(
//                             expand: false,
//                             initialChildSize: 0.5,
//                             minChildSize: 0.3,
//                             maxChildSize: 0.9,
//                             builder: (_, scrollController) => Container(
//                               padding: const EdgeInsets.all(20),
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.vertical(
//                                   top: Radius.circular(25),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     blurRadius: 10,
//                                     spreadRadius: 2,
//                                   ),
//                                 ],
//                               ),
//                               child: SingleChildScrollView(
//                                 controller: scrollController,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Center(
//                                       child: Container(
//                                         width: 50,
//                                         height: 5,
//                                         margin:
//                                             const EdgeInsets.only(bottom: 20),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[300],
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                       ),
//                                     ),
//                                     // Center(
//                                     //   child: Stack(
//                                     //     children: [
//                                     //       CircleAvatar(
//                                     //         radius: 50,
//                                     //         backgroundImage:
//                                     //             NetworkImage(profile.avatar),
//                                     //       ),
//                                     //       Positioned(
//                                     //         right: 0,
//                                     //         bottom: 0,
//                                     //         child: GestureDetector(
//                                     //           // onTap: () => pickAvatar(
//                                     //           //     controller.updateAvatar),
//                                     //           child: Container(
//                                     //             decoration: BoxDecoration(
//                                     //               color: Colors.blue,
//                                     //               shape: BoxShape.circle,
//                                     //             ),
//                                     //             padding:
//                                     //                 const EdgeInsets.all(6),
//                                     //             child: const Icon(
//                                     //               Icons.edit,
//                                     //               color: Colors.white,
//                                     //               size: 20,
//                                     //             ),
//                                     //           ),
//                                     //         ),
//                                     //       ),
//                                     //     ],
//                                     //   ),
//                                     // ),

//                                     ConstrainedBox(
//                                       constraints:
//                                           const BoxConstraints(maxWidth: 360),
//                                       child: FTextField(
//                                         readOnly: true,
//                                         onChange: (value) {
//                                           controller.profile.value?.name ?? '';
//                                         },
//                                         initialValue:
//                                             controller.profile.value?.name ??
//                                                 "",
//                                         // hint: 'Enter your full name',
//                                         //  keyboardType: TextInputType.text,
//                                         prefixBuilder:
//                                             (context, value, child) => Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 14),
//                                           child:
//                                               FIcon(FAssets.icons.userRoundPen),
//                                         ),
//                                       ),
//                                       // child: FTextField(
//                                       //   controller: TextEditingController(
//                                       //       text: profile.name),

//                                       //     //   prefixIcon: FIcon(FAssets.icons.user),
//                                       //     label: Text("Name"),

//                                       //   ),
//                                     ),

//                                     const SizedBox(height: 12),
//                                     if (profile.email.data.isNotEmpty)
//                                       ConstrainedBox(
//                                         constraints:
//                                             const BoxConstraints(maxWidth: 360),
//                                         child: FTextField(
//                                           readOnly: true,
//                                           onChange: (value) {
//                                             controller
//                                                 .profile.value?.email.data;
//                                           },
//                                           initialValue: controller
//                                                   .profile.value?.email.data ??
//                                               "",

//                                           // hint: 'Enter your full name',
//                                           //  keyboardType: TextInputType.text,
//                                           prefixBuilder:
//                                               (context, value, child) =>
//                                                   Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 14),
//                                             child: FIcon(FAssets.icons.mail),
//                                           ),
//                                         ),
//                                       ),
//                                     const SizedBox(height: 12),
//                                     if (profile.phone.data.isNotEmpty)
//                                       ConstrainedBox(
//                                         constraints:
//                                             const BoxConstraints(maxWidth: 360),
//                                         child: FTextField(
//                                           readOnly: true,
//                                           onChange: (value) {
//                                             controller
//                                                 .profile.value?.phone.data;
//                                           },
//                                           initialValue: controller
//                                                   .profile.value?.phone.data ??
//                                               "",

//                                           // hint: 'Enter your full name',
//                                           //  keyboardType: TextInputType.text,
//                                           prefixBuilder:
//                                               (context, value, child) =>
//                                                   Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 14),
//                                             child:
//                                                 FIcon(FAssets.icons.phoneCall),
//                                           ),
//                                         ),
//                                       ),

//                                     //   const SizedBox(height: 12),
//                                     ConstrainedBox(
//                                       constraints:
//                                           const BoxConstraints(maxWidth: 360),
//                                       child: FTextField(
//                                         readOnly: true,
//                                         controller: TextEditingController(
//                                             text: profile.gender == Gender.male
//                                                 ? "Male"
//                                                 : "Female"),
//                                         prefixBuilder:
//                                             (context, value, child) => Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 14),
//                                           child: FIcon(FAssets.icons.user),
//                                         ),
//                                         // prefixIcon: Image.asset(
//                                         //   profile.gender == Gender.male
//                                         //       ? 'assets/male-removebg-preview.png'
//                                         //       : 'assets/female-removebg-preview.png',
//                                         //   width: 25,
//                                         //   height: 25,
//                                         // ),
//                                         // label: Text("Gender"),
//                                       ),
//                                     ),

//                                     // child: FTextField(
//                                     //   controller: TextEditingController(
//                                     //       text: profile.name),

//                                     //     //   prefixIcon: FIcon(FAssets.icons.user),
//                                     //     label: Text("Name"),

//                                     //   ),

//                                     // TextField(
//                                     //   controller: TextEditingController(
//                                     //       text: profile.email.data),
//                                     //   decoration: InputDecoration(
//                                     //     //   prefixIcon: FIcon(FAssets.icons.mail),
//                                     //     labelText: "Email",
//                                     //     border: OutlineInputBorder(
//                                     //       borderRadius:
//                                     //           BorderRadius.circular(12),
//                                     //     ),
//                                     //   ),
//                                     // ),
//                                     // const SizedBox(height: 12),
//                                     // if (profile.phone.data.isNotEmpty)
//                                     //   TextField(
//                                     //     controller: TextEditingController(
//                                     //         text: profile.phone.data),
//                                     //     decoration: InputDecoration(
//                                     //       prefixIcon:
//                                     //           FIcon(FAssets.icons.phoneCall),
//                                     //       labelText: "Phone",
//                                     //       border: OutlineInputBorder(
//                                     //         borderRadius:
//                                     //             BorderRadius.circular(12),
//                                     //       ),
//                                     //     ),
//                                     //   ),

//                                     // SizedBox(
//                                     //   width: double.infinity,
//                                     //   child: ElevatedButton(
//                                     //     onPressed: () {
//                                     //       // TODO: call controller.updateProfile()
//                                     //       Get.back();
//                                     //     },
//                                     //     style: ElevatedButton.styleFrom(
//                                     //       shape: RoundedRectangleBorder(
//                                     //         borderRadius:
//                                     //             BorderRadius.circular(12),
//                                     //       ),
//                                     //       padding: const EdgeInsets.symmetric(
//                                     //           vertical: 14),
//                                     //     ),
//                                     //     child: const Text(
//                                     //       "Save Changes",
//                                     //       style: TextStyle(fontSize: 16),
//                                     //     ),
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );

//                         //  Get.toNamed('settings/userme');
//                       },
//                       child: FIcon(
//                         FAssets.icons.circleUser,
//                         size: 25,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 17),
//                 child: FButton(
//                   onPress: () => Get.toNamed('settings/profile'),
//                   style: contextTheme.buttonStyles.primary.copyWith(
//                     contentStyle:
//                         contextTheme.buttonStyles.primary.contentStyle.copyWith(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 10,
//                       ),
//                     ),
//                   ),
//                   label: Text(
//                     'Sign up or Log in'.tr,
//                     style: contextTheme.typography.sm.copyWith(
//                       color: contextTheme.typography.sm.color,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               );
//             }
//           }),
//           SizedBox(height: 10),
//           FDivider(
//             style: FTheme.of(context)
//                 .dividerStyles
//                 .verticalStyle
//                 .copyWith(width: 1, padding: EdgeInsets.zero),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     GetX<SettingsController>(
//                       builder: (controller) {
//                         return FTileGroup.builder(
//                           count: controller.profileMenus.length,
//                           tileBuilder: (context, index) {
//                             final item = controller.profileMenus[index];
//                             return FTile(
//                               onPress: () {
//                                 Get.toNamed(item.route);
//                               },
//                               title: Text(item.title.tr),
//                               subtitle: Text(item.subtitle.tr),
//                               prefixIcon: item.icon,
//                               suffixIcon: FIcon(FAssets.icons.chevronRight),
//                             );
//                           },
//                           divider: FTileDivider.full,
//                         );
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     FTile(
//                       onPress: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                                 title: Text('Log out'),
//                                 content: const Text(
//                                   'Are you sure you want to log out?',
//                                 ),
//                                 //   actionsAlignment: MainAxisAlignment.end,
//                                 actions: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       SizedBox(width: 10),
//                                       FButton(
//                                         style: contextTheme.buttonStyles.primary
//                                             .copyWith(
//                                           contentStyle: contextTheme
//                                               .buttonStyles.primary.contentStyle
//                                               .copyWith(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 6, vertical: 8),
//                                           ),
//                                         ),
//                                         onPress: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                         label: Text('CANCEL',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: contextTheme
//                                                     .typography.lg.color,
//                                                 fontSize: 15)),
//                                       ),
//                                       SizedBox(width: 16),
//                                       FButton(
//                                         style: contextTheme.buttonStyles.primary
//                                             .copyWith(
//                                           contentStyle: contextTheme
//                                               .buttonStyles.primary.contentStyle
//                                               .copyWith(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 6, vertical: 8),
//                                           ),
//                                         ),
//                                         onPress: () {
//                                           authController.logout();
//                                         },
//                                         label: Text(
//                                           'LOG OUT',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: contextTheme
//                                                   .typography.lg.color,
//                                               fontSize: 15),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ]);
//                           },
//                         );
//                       },
//                       title: Text(
//                         "Logout".tr,
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       ),
//                       prefixIcon: FIcon(
//                         FAssets.icons.logOut,
//                         size: 22,
//                         color: Theme.of(context).colorScheme.error,
//                       ),
//                       suffixIcon: FIcon(
//                         FAssets.icons.chevronRight,
//                         size: 22,
//                         color: FTheme.of(context).colorScheme.error,
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     Text(
//                       'Version 10.2.3',
//                       style: FTheme.of(context).typography.xs.copyWith(
//                             fontStyle: FontStyle.italic,
//                             color: FTheme.of(context)
//                                 .colorScheme
//                                 .secondaryForeground
//                                 .withAlpha(80),
//                           ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
