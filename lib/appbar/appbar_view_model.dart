import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/appbar/appbar_model.dart';
import 'package:theme_desiree/offers/offers_model.dart';

class AppbarViewModel extends ChangeNotifier {
  late AppbarModel _appbar;
  AppbarModel get appbar => _appbar;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  Future<void> fetchAppbar() async {
    final url = Uri.parse("https://api.npoint.io/9e6b6075c4e9c00af7b1");
    _isLoading = true;
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _appbar = AppbarModel.fromJson(data);
        _hasError = false;
      } else {
        _hasError = true;
      }
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
