import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:theme_desiree/profile/avatar_cropper.dart';
import 'package:theme_desiree/profile/profile_controller.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? getInitials(String input) {
      List<String> words = input.trim().split(RegExp(r'\s+'));
      if (words.isEmpty || words[0].isEmpty) return null;
      String firstLetter = words[0][0].toUpperCase();
      String? secondLetter =
          words.length > 1 ? words[1][0].toUpperCase() : null;
      return secondLetter != null ? '$firstLetter$secondLetter' : firstLetter;
    }

    Future<void> pickAvatar(Function updateAvatar) async {
      final ImagePicker picker = ImagePicker();
      try {
        final XFile? pickedFile =
            await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final Uint8List imageBytes = await pickedFile.readAsBytes();

          if (context.mounted) {
            showAdaptiveDialog(
              context: context,
              builder: (context) {
                return AvatarCropper(image: imageBytes);
              },
            );
          }
        }
      } catch (e) {}
    }

    final contextTheme = FTheme.of(context);
    final authController = Get.put(AuthController(), permanent: true);
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: contextTheme.colorScheme.background,
      body: Column(
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
                ),
                Text(
                  'Profile'.tr.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
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
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.hasError.value || controller.profile.value == null) {
              return const Center(child: Text("Failed to load profile"));
            }

            final profile = controller.profile.value!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      FAvatar(
                        image: Image.network(
                          controller.profile.value?.avatar ?? "",
                        ).image,
                        semanticLabel:
                            getInitials(controller.profile.value?.name ?? ""),
                        size: 150,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: FButton.icon(
                          style: FButtonStyle.secondary,
                          onPress: () => pickAvatar(controller.updateAvatar),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FIcon(
                              FAssets.icons.pencil,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  if (profile.avatar.isNotEmpty)
                    CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(profile.avatar)),
                  const SizedBox(height: 16),
                  Row(
                    spacing: 10,
                    children: [
                      FIcon(FAssets.icons.user),
                      Text(
                        profile.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: contextTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (profile.email.data.isNotEmpty)
                    Row(
                      spacing: 10,
                      children: [
                        FIcon(FAssets.icons.mail),
                        Text(
                          profile.email.data,
                          style: TextStyle(
                            fontSize: 16,
                            color: contextTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 8),
                  if (profile.phone.data.isNotEmpty)
                    Row(
                      spacing: 10,
                      children: [
                        FIcon(FAssets.icons.phoneCall),
                        Text(
                          profile.phone.data,
                          style: TextStyle(
                            fontSize: 16,
                            color: contextTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 8),
                  // if (profile.gender != Gender.none)
                  //   Row(
                  //     spacing: 10,
                  //     children: [
                  //       Image.asset(
                  //         'assets/male-removebg-preview.png',
                  //         width: 25,
                  //         height: 25,
                  //       ),

                  //       //  FIcon(FAssets.icons.phoneCall),
                  //       Text(
                  //         "${profile.gender}",
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           color: Colors.orangeAccent,
                  //         ),
                  //       ),
                  //     ],
                  //   ),

                  // Text("${profile.name}", style: const TextStyle(fontSize: 18)),
                  // const SizedBox(height: 8),
                  // Text(
                  //   "${profile.email.data} ${profile.email.isVerified}",
                  //   style: const TextStyle(fontSize: 16),
                  // ),
                  // const SizedBox(height: 8),
                  // if (profile.phone.data.isNotEmpty)
                  //   Text(
                  //     "Phone: ${profile.phone.data} ${profile.phone.isVerified}",
                  //     style: const TextStyle(fontSize: 16),
                  //   ),
                  // const SizedBox(height: 8),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
