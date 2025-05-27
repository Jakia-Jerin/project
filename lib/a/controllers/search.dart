import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/constants.dart';

class SearchSuggestionController extends GetConnect implements GetxService {
  var hasError = false.obs;
  var isLoading = false.obs;
  var suggestions = <String>[];
  var textController = TextEditingController();

  Future<void> fetchSuggestions() async {
    try {
      isLoading.value = true;
      final response = await get("${Constants.host}bd6aabc96e2ff39531c4");
      if (response.statusCode == 200) {
        final data = response.body;
        if ((data is Map) && (data['suggestions'] is List)) {
          suggestions.assignAll(List<String>.from(data['suggestions']));
        } else {
          hasError.value = true;
        }
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
    Future.delayed(Duration.zero, () {
      fetchSuggestions();
    });
  }
}
