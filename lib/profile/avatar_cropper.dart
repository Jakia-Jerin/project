import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/profile/profile_controller.dart';

class AvatarCropper extends StatelessWidget {
  final Uint8List image;
  const AvatarCropper({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final cropController = CropController();
    return Container(
      color: FTheme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          Expanded(
            child: Crop(
              image: image,
              controller: cropController,
              aspectRatio: 1 / 1,
              onStatusChanged: (value) {
                switch (value) {
                  case CropStatus.loading:
                    print('Image loading....');
                  case CropStatus.nothing:
                    Navigator.of(context).pop();
                  case CropStatus.ready:
                    print('Image is ready to crop');
                  case CropStatus.cropping:
                    profileController.isUploading.value = true;
                }
              },
              onCropped: (result) async {
                print('readt to upload');
                switch (result) {
                  case CropSuccess(:final croppedImage):
                    final bool succeed =
                        await profileController.updateAvatar(croppedImage);
                    print(succeed);
                    if (succeed) {
                      Navigator.of(context).pop();
                    }
                  case CropFailure():
                    // Fluttertoast.showToast(
                    //   msg: "Upload failed".tr,
                    //   backgroundColor: FTheme.of(context).colorScheme.primary,
                    // );
                    profileController.isUploading.value = false;
                }
              },
            ),
          ),
          Obx(() {
            return Container(
              padding: EdgeInsets.all(8),
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: FButton(
                      onPress: profileController.isUploading.value
                          ? null
                          : () => Navigator.of(context).pop(),
                      label: Text('Discard'),
                    ),
                  ),
                  Expanded(
                    child: FButton(
                      onPress: () => cropController.crop(),
                      label: Text(profileController.isUploading.value
                          ? 'Uploading...'
                          : 'Save'),
                    ),
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
