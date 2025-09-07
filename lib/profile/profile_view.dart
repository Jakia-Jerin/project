import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:theme_desiree/a/ui/loader_view.dart';
import 'package:theme_desiree/profile/avatar_cropper.dart';
import 'package:theme_desiree/profile/profile_controller.dart';
import 'package:theme_desiree/profile/userprofile_model.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
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

    String? getInitials(String input) {
      List<String> words = input.trim().split(RegExp(r'\s+'));
      if (words.isEmpty || words[0].isEmpty) return null;
      String firstLetter = words[0][0].toUpperCase();
      String? secondLetter =
          words.length > 1 ? words[1][0].toUpperCase() : null;
      return secondLetter != null ? '$firstLetter$secondLetter' : firstLetter;
    }

    profileController.fetchProfile();
    return Column(
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
                'Profile'.tr.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(width: 40)
            ],
          ),
        ),
        FDivider(
          style: FTheme.of(context)
              .dividerStyles
              .verticalStyle
              .copyWith(width: 1, padding: EdgeInsets.zero),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetX<ProfileController>(
                  builder: (controller) {
                    final isLoading = controller.isLoading;
                    final hasError = controller.hasError;
                    if (isLoading.value || hasError.value) {
                      return Center(child: LoaderView(size: 100));
                    }
                    return Column(
                      spacing: 8,
                      children: [
                        Stack(
                          children: [
                            FAvatar(
                              image: Image.network(
                                controller.profile.value?.avatar ?? "",
                              ).image,
                              semanticLabel: getInitials(
                                  controller.profile.value?.name ?? ""),
                              size: 150,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: FButton.icon(
                                style: FButtonStyle.secondary,
                                onPress: () =>
                                    pickAvatar(controller.updateAvatar),
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
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: FTextField(
                            onChange: (value) {
                              controller.updateName(value);
                            },
                            initialValue: controller.profile.value?.name ?? "",
                            hint: 'Enter your full name',
                            keyboardType: TextInputType.text,
                            prefixBuilder: (context, value, child) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: FIcon(FAssets.icons.userRoundPen),
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: FSelectMenuTile(
                            groupController: controller.genderController,
                            autoHide: true,
                            prefixIcon: FIcon(
                              FAssets.icons.baby,
                              size: 20,
                            ),
                            onSaved: (newValue) {
                              controller.updateGender(newValue!.first);
                            },
                            title: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'Gender',
                                style:
                                    FTheme.of(context).typography.sm.copyWith(
                                          color: FTheme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                              ),
                            ),
                            details: ListenableBuilder(
                              listenable: controller.genderController,
                              builder: (context, _) => Text(
                                switch (controller
                                    .genderController.value.firstOrNull) {
                                  Gender.male => 'Male',
                                  Gender.female => 'Female',
                                  Gender.other => 'Other',
                                  Gender.none || null => 'None'
                                },
                              ),
                            ),
                            menu: [
                              FSelectTile(
                                title: const Text('Male'),
                                value: Gender.male,
                              ),
                              FSelectTile(
                                  title: const Text('Female'),
                                  value: Gender.female),
                              FSelectTile(
                                  title: const Text('Other'),
                                  value: Gender.other),
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Expanded(
                                child: FTextField(
                                  onChange: (value) {
                                    controller.updateEmail(value);
                                  },
                                  initialValue:
                                      controller.profile.value?.email.data ??
                                          "",
                                  hint: 'Enter your email',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixBuilder: (context, value, child) =>
                                      Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: FIcon(FAssets.icons.atSign),
                                  ),
                                ),
                              ),
                              FButton(
                                onPress:
                                    (controller.profile.value?.email.data ==
                                                controller.editedProfile.value
                                                    ?.email.data &&
                                            !(controller.profile.value?.email
                                                    .isVerified ??
                                                false))
                                        ? null
                                        : () {
                                            // Handle the verify action
                                          },
                                label: Text('Verify'),
                              ),
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Expanded(
                                child: FTextField(
                                  onChange: (value) =>
                                      controller.updatePhone(value),
                                  initialValue: controller
                                      .editedProfile.value?.phone.data,
                                  prefixBuilder: (context, value, child) =>
                                      Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: FIcon(FAssets.icons.phoneCall),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              FButton(
                                onPress:
                                    (controller.profile.value?.phone.data ==
                                                controller.editedProfile.value
                                                    ?.phone.data &&
                                            !(controller.profile.value?.phone
                                                    .isVerified ??
                                                false))
                                        ? null
                                        : () {
                                            // Handle the verify action
                                          },
                                label: Text('Verify'),
                              )
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 360),
                          child: FButton(
                            onPress: () {},
                            // onPress: (controller.editedProfile.value?.name !=
                            //             controller.profile.value?.name ||
                            //         controller.editedProfile.value?.gender !=
                            //             controller.profile.value?.gender ||
                            //         controller
                            //                 .editedProfile.value?.email.data !=
                            //             controller.profile.value?.email.data ||
                            //         controller
                            //                 .editedProfile.value?.phone.data !=
                            //             controller.profile.value?.phone.data)
                            //     ? () => controller.updateProfile
                            //     : null,
                            label: Text('Update'),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
