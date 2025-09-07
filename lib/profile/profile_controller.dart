import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/profile/contacts.dart';
import 'package:theme_desiree/profile/userprofile_model.dart';

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

// Fetch user session from API
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final token = GetStorage().read("accessToken");

      final url = Uri.parse('https://app2.apidoxy.com/api/v1/user/session');
      final response = await http.get(
        url,
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final userData = body['user'] ?? {};

        profile.value = ProfileModel(
          id: userData['id'] ?? '',
          avatar: userData['avatar'] ?? '',
          name: userData['name'] ?? '', // <--- make sure default ''
          email: ContactInfo(
            data: userData['email'] ?? '',
            isVerified:
                userData['isEmailVerified'] ?? userData['isVerified'] ?? false,
          ),
          phone: ContactInfo(
            data: userData['phone'] ?? '',
            isVerified:
                userData['isPhoneVerified'] ?? userData['isVerified'] ?? false,
          ),
          gender: userData['gender'] != null
              ? ProfileModel.parseGender(userData['gender'])
              : Gender.none,
        );
      } else {
        hasError.value = true;
        print("Failed to fetch profile: ${response.statusCode}");
      }
    } catch (e) {
      print("Profile fetch error: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
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
        genderController.value = {profile.value!.gender!};
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

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }
}
