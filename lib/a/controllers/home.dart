
import 'package:get/get.dart';
import 'package:theme_desiree/a/models/section.dart';

class HomeController extends GetConnect implements GetxService {
  var sections = <SectionModel>[].obs;
  var hasError = false.obs;
  var isLoading = false.obs;

//   Future<void> fetchSections() async {
//     try {
//       isLoading.value = true;
//       hasError.value = false;

//       // API call to get sections or products
//       final response = await http.get(
//         Uri.parse("https://app2.apidoxy.com/api/v1/products"),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);

//         if (body['success'] == true && body['data'] is List) {
//           //
//           List<SectionModel> tempSections = [
//             // Banner carousel example
//             SectionModel(
//               type: SectionType.bannerCarousal,
//               index: 1,
//               data: {
//                 "data": [
//                   "https://picsum.photos/1024/480",
//                   "https://picsum.photos/1024/480",
//                   "https://picsum.photos/1024/480"
//                 ],
//                 "error": false
//               },
//             ),
//             // Horizontal brochure: API products
//             SectionModel(
//               type: SectionType.horizontalBrochure,
//               index: 2,
//               data: {
//                 "data": {"products": body['data']}
//               },
//             ),
//             // Collage: API  products
//             SectionModel(
//               type: SectionType.collage,
//               index: 3,
//               data: {
//                 "data": {"products": body['data']}
//               },
//             ),
//           ];

//           sections.assignAll(tempSections);
//         } else {
//           hasError.value = true;
//         }
//         print("Response status: ${response.statusCode}");
//         print("Response body: ${response.body}"); // debug
//       } else {
//         hasError.value = true;
//       }
//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching sections: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchSections();
//   }

  Future<void> fetchSections() async {
    try {
      isLoading.value = true;
      final response = await get("https://api.npoint.io/dd35eaeac9648765649d");
      if (response.statusCode == 200) {
        final data = response.body;
        if (data is Map && data.containsKey('sections')) {
          final List<SectionModel> tempData =
              (data['sections'] as List<dynamic>)
                  .map((item) => SectionModel.fromJson(item))
                  .toList();
          sections.assignAll(tempData);
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
      fetchSections();
    });
  }
}
