import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/profile/contacts.dart';
import 'package:theme_desiree/profile/profile_model.dart';

class ProfileController extends GetConnect implements GetxService {
  var profile = Rxn<ProfileModel>();
  var editedProfile = Rxn<ProfileModel>();
  var hasError = false.obs;
  var isLoading = false.obs;
  var isUploading = false.obs;

  TextEditingController nameController = TextEditingController();
  final genderController = FRadioSelectGroupController(value: Gender.none);

  void updateName(String newName) {
    if (editedProfile.value != null) {
      editedProfile.value = editedProfile.value!.copyWith(name: newName);
    }
  }

  void updateEmail(String newEmail) {
    if (editedProfile.value != null) {
      editedProfile.value = editedProfile.value!.copyWith(
        email: ContactInfo(
          data: newEmail,
          isVerified: newEmail == profile.value?.email.data
              ? profile.value!.email.isVerified
              : false,
        ),
      );
    }
  }

  void updateGender(Gender newGender) {
    genderController.value = {newGender};
    print('gender updated');
    if (editedProfile.value != null) {
      editedProfile.value = editedProfile.value!.copyWith(gender: newGender);
    }
  }

  void updatePhone(String newPhone) {
    if (editedProfile.value != null) {
      editedProfile.value = editedProfile.value!.copyWith(
        phone: ContactInfo(
          data: newPhone,
          isVerified: newPhone == profile.value?.phone.data
              ? profile.value!.phone.isVerified
              : false,
        ),
      );
    }
  }

  Future<bool> updateAvatar(croppedImage) async {
    final String imageToUpload = base64Encode(croppedImage);
    try {
      final response = await get("https://api.npoint.io/69212505674068a9c82c");
      // final response = await post(
      //     "https://api.imgbb.com/1/upload?key=bcb5852aaa66f6444c41c7c2ee9a921d",
      //     FormData({"image": imageToUpload}),
      //     contentType: "multipart/form-data");

      if (response.statusCode == 200) {
        final data = response.body;
        if (data is Map) {
          final String avatarUrl = data['data']['url'];
          profile.value = profile.value!.copyWith(avatar: avatarUrl);
        }
        isUploading.value = false;
        return true;
      } else {
        isUploading.value = false;
        return false;
      }
    } catch (e) {
      isUploading.value = false;
      return false;
    }
  }

  void updateProfile() async {
    // Implement API call to update profile on the server
  }

  void fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await get("https://api.npoint.io/8d13b7d52b63785e9ced");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.body;
        profile.value = ProfileModel.fromJson(data);
        editedProfile.value = ProfileModel.fromJson(data);
        genderController.value = {profile.value!.gender};
        hasError.value = false;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
