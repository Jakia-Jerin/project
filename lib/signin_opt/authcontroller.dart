import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

import 'package:theme_desiree/profile/contacts.dart';
import 'package:theme_desiree/signin_opt/otp.dart';
import 'package:theme_desiree/signin_opt/profile_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:theme_desiree/signin_opt/signin_signup.dart';

class AuthController extends GetxController {
  var isLogin = true.obs;
  var hasError = false.obs;
  var isLoading = false.obs;
  var isUploading = false.obs;

  var profile = Rxn<ProfileModel>();
  var editedProfile = Rxn<ProfileModel>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  // Use FSelectGroupController for Gender instead of ValueNotifier
  final genderController = FRadioSelectGroupController(value: Gender.none);
  final otpController = TextEditingController();
  var generatedOtp = ''.obs;
  var isOtpSent = false.obs;

//OTP generation function

  void sendOtp(String phoneOrEmail) {
    // Generate random 6-digit OTP
    generatedOtp.value = (100000 + Random().nextInt(899999)).toString();

    // For testing purpose, just print it (replace with real SMS/email API)
    print('\x1b[32m this is otp \x1b[0m');
    print('Generated OTP: ${generatedOtp.value}');

    Get.snackbar('OTP Sent', 'OTP sent to $phoneOrEmail');
    isOtpSent.value = true;
  }

//OTP verification function
  bool verifyOtp(String inputOtp) {
    if (inputOtp.isEmpty) {
      Get.snackbar('', 'Please,Enter the OTP');
    }
    if (inputOtp == generatedOtp.value) {
      Get.snackbar('Wow!!', 'Signup Successful');
      Get.toNamed('/profile');
      return true;
    } else {
      //  Get.snackbar('Invalid OTP', 'The OTP you entered is incorrect');
      return false;
    }
  }

  String getContactLabel(String contact) {
    if (contact.contains('@')) {
      return 'email: $contact';
    } else {
      return 'phone number: $contact';
    }
  }

  void updateGender(Gender newGender) {
    genderController.value = {newGender};
    print('gender updated');
    if (editedProfile.value != null) {
      editedProfile.value = editedProfile.value!.copyWith(gender: newGender);
    }
  }

  void updateName(String newName) {
    if (editedProfile.value != null) {
      editedProfile.value = editedProfile.value!.copyWith(name: newName);
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

  void toggleLoginSignUp() {
    isLogin.value = !isLogin.value;
  }

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final gender = genderController.value.isNotEmpty
        ? genderController.value.first.toString()
        : '';

    if (name.isEmpty || password.isEmpty || (email.isEmpty && phone.isEmpty)) {
      Get.snackbar('Error', 'Name, Password & (Email or Phone) required');
      return;
    }

    final contact = phone.isNotEmpty ? phone : email;
    sendOtp(contact);
    Get.to(() => OtpPage(contact: contact));

    //Get.toNa('/profile');

    final box = GetStorage();
    box.write('name', name);
    box.write('email', email);
    box.write('phone', phone);
    box.write('password', password);
    box.write('gender', gender);

  //  Get.snackbar('Success', 'Sign Up Successful!');
    clearInputs();
    toggleLoginSignUp();
  }

  Future<void> login() async {
    final inputEmail = emailController.text.trim();
    final inputPhone = phoneController.text.trim();
    final inputPassword = passwordController.text.trim();

    final box = GetStorage();
    final savedEmail = box.read('email') ?? '';
    final savedPhone = box.read('phone') ?? '';
    final savedPassword = box.read('password') ?? '';

    if (inputPassword == savedPassword &&
        (inputEmail == savedEmail || inputPhone == savedPhone)) {
      Get.snackbar('Success', 'Login Successful!');
      clearInputs();
    } else {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

  void logout() {
    final box = GetStorage();
    box.erase();
    Get.offAll(() => SigninPage());
  }

  void fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await http
          .get(Uri.parse("https://api.npoint.io/8d13b7d52b63785e9ced"));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        profile.value = ProfileModel.fromJson(data);
        editedProfile.value = ProfileModel.fromJson(data);
        nameController.text = profile.value?.name ?? '';
        emailController.text = profile.value?.email.data ?? '';
        phoneController.text = profile.value?.phone.data ?? '';
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

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void clearInputs() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    genderController.value = <Gender>{};
    otpController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    genderController.dispose();
    super.onClose();
  }
}







// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';

// class AuthController extends GetxController {
//   RxBool isLogin = true.obs;
 
//     final emailcontroller = TextEditingController();
//     final passwordcontroller = TextEditingController();
//       final repeatPasswordController = TextEditingController();


//   void toggleForm() {
//     isLogin.value = !isLogin.value;

//     // Clear fields when switching
//     emailcontroller.clear();
//     passwordcontroller.clear();
//     repeatPasswordController.clear();
//   }


//    // Example: Login logic
//   void login() {
//     final email = emailcontroller.text.trim();
//     final password = passwordcontroller.text.trim();

//     // Add your login API call here
//    // Get.snackbar('Login', 'Logged in as $email');


//   }
//       // Example: Register logic
//   void register() {
//     final email = emailcontroller.text.trim();
//     final password = passwordcontroller.text.trim();
//     final repeatPassword = repeatPasswordController.text.trim();

//     if (password != repeatPassword) {
//   //    Get.snackbar('Error', 'Passwords do not match');
//       return;
//     }

//     // Add  register API call here
//   //  Get.snackbar('Register', 'Registered as $email');
//   }

//    @override
//   void onClose() {
//     emailcontroller.dispose();
//     passwordcontroller.dispose();
//     repeatPasswordController.dispose();
//     super.onClose();
//   }




// }
