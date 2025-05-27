import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_desiree/signin/signin_model.dart';

class SigninViewModel {
  tryToSign() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response =
          await GetConnect().get("https://api.npoint.io/578fbece3892e094881a");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == 0) {
          await prefs.setString('token', data['token']);
          return SigninModel(
            error: data['error'],
            message: data['message'],
            token: data['token'],
          );
        } else {
          return SigninModel(
            error: data['error'],
            message: data['message'],
            token: null,
          );
        }
      } else {
        return SigninModel(
          error: 1001,
          message: "Something went wrong",
          token: null,
        );
      }
    } catch (e) {
      return SigninModel(
        error: 1001,
        message: "Something went wrong",
        token: null,
      );
    }
  }
}
