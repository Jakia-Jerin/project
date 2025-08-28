import 'package:get/get.dart';

class BannerCarouselController extends GetConnect implements GetxService {
  var activeSlide = 0.obs;
  var images = <String>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;

  Future<void> fromJson(Map<String, dynamic> json) async {
    try {
      if (json['error'] == false && json['data'] is List) {
        final List<String> tempImages = List<String>.from(json['data']);
        images.assignAll(tempImages);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } 
    finally {
      isLoading.value = false;
    }
  }
}

