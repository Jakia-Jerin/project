import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/orders/orders_controller.dart';

import 'package:theme_desiree/profile/contacts.dart';
import 'package:theme_desiree/signin_opt/profile_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  var isLogin = true.obs;
  var hasError = false.obs;
  var isLoading = false.obs;
  var isUploading = false.obs;
  var isLoggedIn = false.obs;
  var userEmailOrPhone = "".obs;
  var issignup = false.obs;
  var passwordValid = false.obs;

  var profile = Rxn<ProfileModel>();
  var editedProfile = Rxn<ProfileModel>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final changepasswordController = TextEditingController();
  final accountController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var resetPasswordController = TextEditingController();
  var confirmresetPasswordController = TextEditingController();
  var isresetPasswordHidden = true.obs;

  final resetController = TextEditingController();

  // Use FSelectGroupController for Gender instead of ValueNotifier
  final genderController = FRadioSelectGroupController(value: Gender.none);
  // Verification flags
  var isEmailVerified = false.obs;
  var isPhoneVerified = false.obs;
  final otpController = TextEditingController();
  var generatedOtp = ''.obs;
  var isOtpSent = false.obs;
  var isPasswordHidden = true.obs;
  var isnewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var showPasswordWarning = false.obs;

  var passwordFocusNode = FocusNode();
  var token = "".obs;
  final baseUrl = dotenv.env['BASE_URL'];

  ///password validation UI
  void validatePassword(String password) {
    // At least 8 characters, one uppercase, one lowercase, one number, one special character
    final regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    passwordValid.value = regex.hasMatch(password);
    showPasswordWarning.value = !passwordValid.value;
  }

  // Forgot password card visible?
  var isForgotPasswordVisible = false.obs;
  var selectedMethod = "".obs; // email / phone

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage();
    final savedUser = box.read("user");
    if (savedUser != null) {
      userEmailOrPhone.value =
          savedUser["email"] ?? savedUser["phone"] ?? "Unknown user";
      isLoggedIn.value = true;
      print('///////////////////////////////////////////');
      print("Restored user: ${userEmailOrPhone.value}");
    } else {
      print("No saved user found");
    }

    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        // Focus lost, validate password

        showPasswordWarning.value = false;
      }
    });
  }
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
//      Get.snackbar('Wow!!', 'Signup Successful');
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
  //............verify email.............

  // API-based Email verification
  Future<bool> verifyEmail(String email, String otp) async {
    final url = Uri.parse('$baseUrl/user/verify-email');
    final headers = {
      "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
      "Content-Type": "application/json",
    };
    final body = jsonEncode({'email': email, 'otp': otp});

    try {
      print("Sending Email Verification Request...");
      print(" Email: $email");
      print(" OTP: $otp");

      final response = await http.post(url, headers: headers, body: body);

      print(" Status Code: ${response.statusCode}");
      print(" Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        isEmailVerified.value = true;
        Get.snackbar('Success', 'Email verified successfully');
        return true;
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to verify email');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Email verification failed');
      print("❌ Exception during email verification: $e");
      return false; //
    }
  }

  Future<bool> verifyPhone(String phone, String otp) async {
    final url = Uri.parse('$baseUrl/user/verify-phone');
    final headers = {
      "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
      "Content-Type": "application/json",
    };

    // Backend expects +880 format
    String formattedPhone = phone.startsWith('+') ? phone : '+88$phone';

    final body = jsonEncode({
      "phone": formattedPhone, // Required
      "otp": otp, // Required
    });

    try {
      print("🔹 Sending Phone Verification Request...");
      print("📱 Phone: $formattedPhone");
      print("🔑 OTP: $otp");

      final response = await http.post(url, headers: headers, body: body);

      print(" Status Code: ${response.statusCode}");
      print(" Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar('Success', 'Phone number verified successfully');
        return true;
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to verify phone');
        return false;
      }
    } catch (e) {
      print(" Exception during phone verification: $e");
      Get.snackbar('Error', 'Phone verification failed');
      return false;
    }
  }

  // Future<bool> verifyEmail(String email, String otp) async {
  //   final url = Uri.parse('https://app2.apidoxy.com/api/v1/user/verify-email');
  //   final headers = {
  //     "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //     "Content-Type": "application/json",
  //   };
  //   final body = jsonEncode({'email': email, 'otp': otp});

  //   try {
  //     print("🔹 Sending Email Verification Request...");
  //     print("📧 Email: $email");
  //     print("🔑 OTP: $otp");

  //     final response = await http.post(url, headers: headers, body: body);

  //     print("📡 Status Code: ${response.statusCode}");
  //     print("📡 Response Body: ${response.body}");

  //     final data = jsonDecode(response.body);

  //     if (response.statusCode == 200 && data['success'] == true) {
  //       isEmailVerified.value = true;
  //       Get.snackbar('Success', 'Email verified successfully');
  //     } else {
  //       Get.snackbar('Error', data['message'] ?? 'Failed to verify email');
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Email verification failed');
  //     print("❌ Exception during email verification: $e");
  //   }
  // }

//............Sign Up Function............

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final gender = genderController.value.isNotEmpty
        ? genderController.value.first.name
        : '';

    if (name.isEmpty || password.isEmpty || (email.isEmpty && phone.isEmpty)) {
      Get.snackbar('Error', 'Name, Password & (Email or Phone) required');
      return;
    }

    //  final contact = phone.isNotEmpty ? phone : email;
    // sendOtp(contact);
    // Get.to(() => OtpPage(contact: contact));

    try {
      isUploading.value = true;

      final Map<String, dynamic> requestBody = {
        "name": name,
        "gender": gender,
        "password": password,
        if (email.isNotEmpty) "email": email,
        if (phone.isNotEmpty) "phone": phone,
      };

      final response = await http.post(
        Uri.parse("$baseUrl/user/register"),
        headers: {
          "x-vendor-identifier":
              dotenv.env['SHOP_ID'] ?? "", //"cmdodf60l000028vh5otnn9fg",
          //    "x-vendor-identifier": "cmdodf60l000028vh5otnn9fg",
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
        // body: jsonEncode({
        //   "name": name,
        //   "email": email.isNotEmpty ? email : null,
        //   "phone": phone.isNotEmpty ? phone : null,
        //   "gender": gender,
        //   "password": password,
        // }),
      );

      print("Request Body: ${jsonEncode(requestBody)}");
      // print("Request Body: ${jsonEncode({
      //       "name": name,
      //       "email": email.isNotEmpty ? email : null,
      //       "phone": phone.isNotEmpty ? phone : null,
      //       "gender": gender,
      //       "password": password,
      //     })}");

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        Get.snackbar(
            'Success', data['message'] ?? 'User registered successfully');

        print('\x1b[32m this is information of signup \x1b[0m');

        print('User Signup successfully: $data');
        // clearInputs();
        // toggleLoginSignUp();
        //  Get.to('/profile');
        // // Save to local storage if needed
        // final box = GetStorage();
        // box.write('name', name);
        // box.write('email', email);
        // box.write('phone', phone);
        // box.write('password', password);
        // box.write('gender', gender);

        clearInputs();
        toggleLoginSignUp();
        Get.toNamed("settings/OtpPage");
        // Save to local storage if needed
        final box = GetStorage();
        box.write('name', name);
        box.write('email', email);
        box.write('phone', phone);
        box.write('password', password);
        box.write('gender', gender);
      } else {
        Get.snackbar('Error', "Failed: ${response.body}");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isUploading.value = false;
    }
  }

//................Login Function............

  Future<void> login() async {
    final inputEmail = emailController.text.trim();
    final inputPhone = phoneController.text.trim();
    final inputPassword = passwordController.text.trim();
    final ordersController = Get.put(OrdersController());

    if (inputPassword.isEmpty || (inputEmail.isEmpty && inputPhone.isEmpty)) {
      Get.snackbar("Error", "Please enter email/phone and password");
      return;
    }

    final identifier = inputEmail.isNotEmpty ? inputEmail : inputPhone;

    final url = Uri.parse("$baseUrl/user/login"); //
    final headers = {
      "x-vendor-identifier":
          dotenv.env['SHOP_ID'] ?? " ", //"cmdodf60l000028vh5otnn9fg"
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "identifier": identifier,
      "password": inputPassword,
      "timezone": "Asia/Dhaka",
      "fingerprint": "a1b2c3d4e5f67890123456789abcdef0"
    });

    try {
      isLoading.value = true;

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        //  Access & Refresh token save
        // final box = GetStorage();
        // box.write("accessToken", data["accessToken"]);
        // box.write("refreshToken", data["refreshToken"]);
        // box.write("user", data["user"]);

        Get.snackbar('Success', data['message'] ?? 'login successful');
        print("Headers: $headers");
        print("Request Body: $body");
        print("Response Body: ${response.body}");
        print("Status Code: ${response.statusCode}");

        //    Get.snackbar("Success", "Login Successful");
        // Get.toNamed('/settings');
        //  ordersController.fetchOrders();
        //  Access & Refresh token save
        final box = GetStorage();
        final user = data["user"];
        box.write("user", user);
        box.write("accessToken", data["accessToken"]);
        box.write("refreshToken", data["refreshToken"]);
        //    box.write("user", data["user"]);
        //   final user = data["user"];
        userEmailOrPhone.value =
            user["email"] ?? user["phone"] ?? "Unknown user";
        isLoggedIn.value = true;
        print('...................................................');
        print("Assigned Email/Phone: ${userEmailOrPhone.value}");
        print("User info: $user");
        //  box.write("user", user);

        clearInputs();
        Get.toNamed('/settings');
        //   Get.toNamed('/');

        // Profile page
        //   Get.offAllNamed("/profile");
      } else {
        final errorMsg = jsonDecode(response.body)["message"] ?? "Login Failed";
        print("Request URL: $url");
        print("Headers: $headers");
        print("Request Body: $body");
        print("Response Body: ${response.body}");
        print("Status Code: ${response.statusCode}");
        Get.snackbar("Error", errorMsg);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //................Logout Function............

  Future<void> logout() async {
    final box = GetStorage();

    // token read
    final accessToken = box.read("accessToken");
    final refreshToken = box.read("refreshToken");
    final ordersController = Get.put(OrdersController());

    if (accessToken == null || refreshToken == null) {
      print("No token found, already logged out");
      return;
    }

    final url = Uri.parse("$baseUrl/user/logout");

    try {
      final response = await http.post(
        url,
        headers: {
          "x-vendor-identifier":
              dotenv.env['SHOP_ID'] ?? " ", //"cmdodf60l000028vh5otnn9fg"
          //  "x-vendor-identifier": "cmdodf60l000028vh5otnn9fg", // vendor id
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Logout Success: ${data['message']}");
        Get.snackbar("Success", "Logout Successful");
        //Get.toNamed("/accounts");
        Get.toNamed("/settings");
        // local storage clear
        box.remove("accessToken");
        box.remove("refreshToken");
        box.remove("user");
        //  ordersController.orders.clear();

        isLoggedIn.value = false;
        userEmailOrPhone.value = "";
        print("User logged out, local storage cleared");
      } else {
        print(" Logout Failed: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  //.....................change password function............

  Future<void> savePassword() async {
    String current = changepasswordController.text.trim();
    String newPass = newPasswordController.text.trim();
    String confirm = confirmPasswordController.text.trim();
    final box = GetStorage();
    final accessToken = box.read("accessToken");

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    if (newPass != confirm) {
      Get.snackbar('Error', 'New Password and Confirm Password do not match');
      return;
    }

    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await http.post(
        Uri.parse("$baseUrl/user/change-password"),
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? " ",
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "currentPassword": current,
          "newPassword": newPass,
          "confirmPassword": confirm, // Assuming API expects "c" for confirm
        }),
      );

      Get.back(); // Close loading dialog

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Get.back(); // Close bottom sheet
          Get.snackbar(
              'Success', data['message'] ?? 'Password changed successfully');
          print("password changed successfully: $data");
          // Clear fields
          changepasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
        } else {
          Get.snackbar('Error', data['message'] ?? 'Failed to change password');
          print("Failed to change password: $data");
          print("Current Password: $current");
          print("New Password: $newPass");
          print("Confirm Password: $confirm");
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
        print("Server error: ${response.statusCode}");
        print("Response Body: ${response.body}");
        print("Current Password: $current");
        print("New Password: $newPass");
        print("Confirm Password: $confirm");
      }
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar('Error', 'Something went wrong: $e');
      print("Exception: $e");
      print("Current Password: $current");
      print("New Password: $newPass");
      print("Confirm Password: $confirm");
    }
  }

  void toggleForgotPassword() {
    isForgotPasswordVisible.value = !isForgotPasswordVisible.value;
  }

  // Send OTP or reset email
  void sendOtpOrEmail(String account, String method) {
    selectedMethod.value = method;
    if (method == "email") {
      print("Send reset link to $account");
      Get.snackbar("Success", "Reset link sent to your email");
    } else {
      print("Send OTP to phone: $account");
      Get.snackbar("Success", "OTP sent to your phone");
      isOtpSent.value = true;
      Get.toNamed("settings/OtpPage");
      //   Get.to(() => OtpPage(account: account));
    }
  }

//.............Forget Password Function............
  Future<void> forgotPassword(String account) async {
    final url = Uri.parse('$baseUrl/user/forget-password');

    Map<String, dynamic> body = {};

    // Check if account is email or phone
    if (account.contains('@')) {
      body['email'] = account;
    } else {
      body['phone'] = account;
    }
    print("URL: $url");
    print("Body: $body");
    try {
      final response = await http.post(
        url,
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? " ",
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      print("Request Body: ${jsonEncode(body)}");
      print("Response Status: ${response.statusCode}");
      print("header: ${response.headers}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar('Success', data['message']);
        print("Forgot password request successful: $data");
        //  Get.toNamed("settings/verify");
        // navigate to OTPPage or Verification page
      } else {
        Get.snackbar('Error', 'Something went wrong');
        print("Forgot password request failed: $data");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("Exception during forgot password request: $e");
    }
  }

  Future<Map<String, dynamic>?> verifyForgotToken(String token) async {
    final url = Uri.parse('$baseUrl/user/verify-forget-token');
    final headers = {
      "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "token": token,
    });

    try {
      print("🔹 Verifying Forgot Password Token...");
      print("🔑 Token: $token");

      final response = await http.post(url, headers: headers, body: body);
      final data = jsonDecode(response.body);

      print("📡 Status Code: ${response.statusCode}");
      print("📡 Response Body: ${response.body}");

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar('Success', 'Token verified successfully');
        // Return token info (email/phone and reset token)
        return data;
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to verify token');
        return null;
      }
    } catch (e) {
      print("❌ Exception during token verification: $e");
      Get.snackbar('Error', 'Token verification failed');
      return null;
    }
  }

  Future<bool> resetPassword({
    required String contact,
    required String token,
    required String newPassword,
  }) async {
    final isEmail = contact.contains('@');
    final url = Uri.parse('$baseUrl/user/reset-password');
    final headers = {
      "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
      "Content-Type": "application/json",
    };

    final body = isEmail
        ? jsonEncode({
            "email": contact,
            "token": token,
            "newPassword": newPassword,
          })
        : jsonEncode({
            "phone": contact,
            "token": token,
            "newPassword": newPassword,
          });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        print("status code: ${response.statusCode}");
        print("response body: $data");
        return true;
      } else {
        print("❌ Reset password failed: ${data['message']}");
        return false;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return false;
    }
  }

////for get user mail or phone
  // final box = GetStorage();

  //   isLoggedIn => box.hasData("user");

  // Map<String, dynamic>? get currentUser {
  //   return isLoggedIn ? box.read("user") : null;
  // }

  // String? get userEmailOrPhone {
  //   if (!isLoggedIn) return null;
  //   final user = box.read("user");
  //   if (user["email"] != null && user["email"].toString().isNotEmpty) {
  //     return user["email"];
  //   } else if (user["phone"] != null && user["phone"].toString().isNotEmpty) {
  //     return user["phone"];
  //   }
  //   return null;
  // }

//  void islogin() {
//     isLoggedIn.value = true;
//   }

//   void islogout() {
//     isLoggedIn.value = false;
//   }
  //   // Forgot password request
  // void resetPasswordRequest() {
  //   String value = resetController.text.trim();

  //   if (value.isEmpty) {
  //     Get.snackbar("Error", "Please enter your email or phone");
  //     return;
  //   }

  //   if (value.contains("@")) {
  //     // Email reset
  //     print("Send reset email to $value");
  //     Get.snackbar("Success", "Password reset email sent!");
  //     isForgotPasswordVisible.value = false; // Close card
  //   } else {
  //     // Phone reset → send OTP + go to OTP Page
  //     print("Send OTP to phone: $value");
  //     Get.snackbar("OTP Sent", "We have sent an OTP to your phone.");
  //     isForgotPasswordVisible.value = false;

  //     // Navigate to OTP page with phone number
  //     Get.toNamed("/otp", arguments: {"phone": value});
  //   }
  // }
  // Future<void> signUp() async {
  //   final name = nameController.text.trim();
  //   final email = emailController.text.trim();
  //   final phone = phoneController.text.trim();
  //   final password = passwordController.text.trim();
  //   final gender = genderController.value.isNotEmpty
  //       ? genderController.value.first.toString()
  //       : '';

  //   if (name.isEmpty || password.isEmpty || (email.isEmpty && phone.isEmpty)) {
  //     Get.snackbar('Error', 'Name, Password & (Email or Phone) required');
  //     return;
  //   }

  //   final contact = phone.isNotEmpty ? phone : email;
  //   sendOtp(contact);
  //   Get.to(() => OtpPage(contact: contact));

  //   //Get.toNa('/profile');

  //   final box = GetStorage();
  //   box.write('name', name);
  //   box.write('email', email);
  //   box.write('phone', phone);
  //   box.write('password', password);
  //   box.write('gender', gender);

  // //  Get.snackbar('Success', 'Sign Up Successful!');
  //   clearInputs();
  //   toggleLoginSignUp();
  // }

  // Future<void> login() async {
  //   final inputEmail = emailController.text.trim();
  //   final inputPhone = phoneController.text.trim();
  //   final inputPassword = passwordController.text.trim();

  //   final box = GetStorage();
  //   final savedEmail = box.read('email') ?? '';
  //   final savedPhone = box.read('phone') ?? '';
  //   final savedPassword = box.read('password') ?? '';

  //   if (inputPassword == savedPassword &&
  //       (inputEmail == savedEmail || inputPhone == savedPhone)) {
  //     Get.snackbar('Success', 'Login Successful!');
  //     clearInputs();
  //   } else {
  //     Get.snackbar('Error', 'Invalid credentials');
  //   }
  // }

  // void logout() {
  //   final box = GetStorage();
  //   box.erase();
  //   Get.offAll(() => SigninPage());
  // }

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

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchProfile();
  // }

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
