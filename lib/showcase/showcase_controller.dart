import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/showcase/product_model.dart';

import 'dart:convert';

class ShowcaseController extends GetxController {
  var product = Rx<ProductModel?>(null);
  var selectedOptions = <int, RxString>{}; // rowIndex -> selected option
  var selectedVariant = Rxn<VariantModel>();

  var isLoading = false.obs;
  var hasError = false.obs;

  Future<void> fetchProductByID(String productId) async {
    final shopId = dotenv.env['SHOP_ID'];
    if (shopId == null || shopId.isEmpty) {
      print("❌ Error: SHOP_ID missing");
      hasError.value = true;
      return;
    }

    print("🔎 Fetching product: $productId with shopId=$shopId");
    isLoading.value = true;
    hasError.value = false;

    try {
      final url =
          Uri.parse("https://app2.apidoxy.com/api/v1/products/$productId");

      final response = await http.get(
        url,
        headers: {
          "x-vendor-identifier": shopId,
          "Content-Type": "application/json",
        },
      );

      print("🌐 API Response code: ${response.statusCode}");
      print("🌐 API Response body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'] as Map<String, dynamic>;
          product.value = ProductModel.fromJson(data);

          print("✅ Product loaded: ${product.value!.title}");
          print("✅ Variants: ${product.value!.variants.length}");

          // Initialize selections
          selectedOptions.clear();
          for (int i = 0; i < product.value!.variants.length; i++) {
            selectedOptions[i] = ''.obs;
            print("➡️ Init selection[$i] = ''");
          }
        } else {
          print("❌ API returned success=false or data=null");
          hasError.value = true;
        }
      } else {
        print("❌ Request failed with status ${response.statusCode}");
        hasError.value = true;
      }
    } catch (e) {
      print("❌ Exception in fetchProductByID: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void setOption(int rowIndex, String option) {
    print("🖱️ setOption row=$rowIndex option=$option");
    if (selectedOptions[rowIndex] != null) {
      selectedOptions[rowIndex]!.value = option;
      print("✅ selectedOptions[$rowIndex] = $option");
    }
    _updateSelectedVariant();
  }

  void _updateSelectedVariant() {
    if (product.value == null || product.value!.variants.isEmpty) {
      selectedVariant.value = null;
      print("⚠️ No product or variants found");
      return;
    }

    for (var v in product.value!.variants) {
      print("🔍 Checking variant: ${v.id} with options=${v.options}");
      bool matches = true;
      for (var entry in selectedOptions.entries) {
        if (entry.value.value.isNotEmpty &&
            !v.options.contains(entry.value.value)) {
          matches = false;
          break;
        }
      }
      if (matches) {
        selectedVariant.value = v;
        print("🎯 Matched variant: ${v.id}");
        return;
      }
    }

    selectedVariant.value = null;
    print("⚠️ No matching variant found");
  }
}


// class ShowcaseController extends GetxController {
//   var isLoading = false.obs;
//   var hasError = false.obs;
//   var selectedVariant = Rxn<VariantModel>();
//   final Rx<ProductModel?> product = Rx<ProductModel?>(null);

//   var selectedOptions = <int, RxString>{}.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     final productId = Get.parameters['productId'] ?? '';
//     print("ShowcaseController onInit productId: $productId");
//     if (productId.isNotEmpty) fetchProductByID(productId);
//   }

//   Future<void> fetchProductByID(String productId) async {
//     print("fetchProductByID called with productId: $productId");
//     final shopId = dotenv.env['SHOP_ID'];
//     if (shopId == null || shopId.isEmpty) {
//       print("Error: SHOP_ID not found in .env");
//       hasError.value = true;
//       return;
//     }

//     isLoading.value = true;
//     hasError.value = false;

//     try {
//       final url =
//           Uri.parse("https://app2.apidoxy.com/api/v1/products/$productId");
//       print("Calling API: $url with SHOP_ID: $shopId");

//       final response = await http.get(
//         url,
//         headers: {
//           "x-vendor-identifier": shopId,
//           "Content-Type": "application/json",
//         },
//       );

//       print("Status code: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         if (body['success'] == true && body['data'] != null) {
//           final data = body['data'] as Map<String, dynamic>;
//           product.value = ProductModel.fromJson(data);

//           // Initialize selections
//           selectedOptions.clear();
//           if (product.value!.variants.isNotEmpty) {
//             final maxOptionsLength = product.value!.variants
//                 .map((v) => v.options.length)
//                 .reduce((a, b) => a > b ? a : b);
//             for (int i = 0; i < maxOptionsLength; i++) {
//               selectedOptions[i] = ''.obs;
//             }
//             selectedVariant.value = product.value!.variants.first;
//           }
//         } else {
//           print("API returned success=false or data=null");
//           hasError.value = true;
//         }
//       } else {
//         print("Request failed with status: ${response.statusCode}");
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching product: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // void setOption(int rowIndex, String option) {
//   //   selectedOptions[rowIndex]!.value =
//   //       selectedOptions[rowIndex]!.value == option ? '' : option;
//   //   _updateSelectedVariant();
//   // }
//   void setOption(int rowIndex, String option) {
//     selectedOptions[rowIndex]!.value = option;
//     _updateSelectedVariant();
//   }

//   void _updateSelectedVariant() {
//     if (product.value == null) return;

//     // প্রথম variant ধরো
//     if (product.value!.variants.isNotEmpty) {
//       selectedVariant.value = product.value!.variants.first;
//     } else {
//       selectedVariant.value = null;
//     }
//   }

  // void _updateSelectedVariant() {
  //   if (product.value == null) return;

  //   final match = product.value!.variants.firstWhereOrNull((v) {
  //     for (int i = 0; i < selectedOptions.length; i++) {
  //       final sel = selectedOptions[i]?.value;
  //       if (sel != null && sel.isNotEmpty && sel != v.options[i]) return false;
  //     }
  //     return true;
  //   });

  //   if (match != null) {
  //     selectedVariant.value = VariantModel(
  //       id: match.id,
  //       title: match.title,
  //       options: match.options,
  //       price: {},
  //       //   compareAtPrice: 1,
  //       available: true,
  //     );
  //   } else {
  //     selectedVariant.value = null;
  //   }
  // }


// class ShowcaseController extends GetxController {
//   var isLoading = false.obs;
//   var hasError = false.obs;
//   var selectedVariant = Rxn<VariantModel>();
//   final Rx<ProductModel?> product = Rx<ProductModel?>(null);

//   // dynamic selection map (rowIndex = option type index)
//   var selectedOptions = <int, RxString>{}.obs;

//   // Fetch product by ID
//   Future<void> fetchProductByID(String productId) async {
//     print("............................................................");
//     print("SHOP_ID: ${dotenv.env['SHOP_ID']}");
//     if (productId.isEmpty) return;
//     isLoading.value = true;
//     hasError.value = false;

//     try {
//       final response = await http.get(
//         Uri.parse("https://app2.apidoxy.com/api/v1/products/$productId"),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         if (body['success'] == true && body['data'] != null) {
//           final data = body['data'] as Map<String, dynamic>;
//           product.value = ProductModel.fromJson(data);

//           // Initialize selections
//           selectedOptions.clear();
//           if (product.value!.variants.isNotEmpty) {
//             final maxOptionsLength = product.value!.variants
//                 .map((v) => v.options.length)
//                 .reduce((a, b) => a > b ? a : b);

//             for (int i = 0; i < maxOptionsLength; i++) {
//               selectedOptions[i] = ''.obs;
//             }

//             // Select default variant
//             selectedVariant.value = product.value!.variants.first;
//           }
//         } else {
//           hasError.value = true;
//         }
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching product: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Update selection dynamically
//   void setOption(int rowIndex, String option) {
//     selectedOptions[rowIndex]!.value =
//         selectedOptions[rowIndex]!.value == option ? '' : option;
//     _updateSelectedVariant();
//   }

//   void _updateSelectedVariant() {
//     if (product.value == null) return;

//     // find variant that matches all selected options
//     final match = product.value!.variants.firstWhereOrNull((v) {
//       for (int i = 0; i < selectedOptions.length; i++) {
//         final sel = selectedOptions[i]?.value;
//         if (sel != null && sel.isNotEmpty && sel != v.options[i]) return false;
//       }
//       return true;
//     });

//     if (match != null) {
//       // backend er moto structure banano
//       selectedVariant.value = VariantModel(
//         id: match.id,
//         title: match.title,
//         options: match.options, price: {}, compareAtPrice: 1,
//         available: true, // puro list
//       );
//     } else {
//       selectedVariant.value = null;
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     final productId = Get.parameters['productId'] ?? '';
//     print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
//     print("ShowcaseController onInit productId: $productId"); // <-- debug
//     if (productId.isNotEmpty) fetchProductByID(productId);
//   }

//   // void _updateSelectedVariant() {
//   //   if (product.value == null) return;

//   //   // Find first variant that matches all selected options
//   //   selectedVariant.value = product.value!.variants.firstWhereOrNull((v) {
//   //     for (int i = 0; i < v.options.length; i++) {
//   //       final sel = selectedOptions[i]?.value;
//   //       if (sel != null && sel.isNotEmpty && sel != v.options[i]) return false;
//   //     }
//   //     return true;
//   //   });
//   // }

//   // @override
//   // void onInit() {
//   //   super.onInit();
//   //   final productId = Get.parameters['productId'] ?? '';
//   //   if (productId.isNotEmpty) fetchProductByID(productId);
//   // }
// }

// class ShowcaseController extends GetxController {
//   var isLoading = false.obs;
//   var hasError = false.obs;
//   var selectedVariant = Rxn<VariantModel>();
//   final Rx<ProductModel?> product = Rx<ProductModel?>(null);

//   // dynamic selection map (rowIndex = option type index)
//   var selectedOptions = <int, RxString>{}.obs;

//   // Fetch product by ID
//   Future<void> fetchProductByID(String productId) async {
//     if (productId.isEmpty) return;
//     isLoading.value = true;
//     hasError.value = false;

//     try {
//       final response = await http.get(
//         Uri.parse("https://app2.apidoxy.com/api/v1/products/$productId"),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );
//       print(
//           "********************************************************************************");
//       print("${response.headers}");
//       print("Response body: ${response.body}"); // debug

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         if (body['success'] == true && body['data'] != null) {
//           final data = body['data'] as Map<String, dynamic>;

//           product.value = ProductModel.fromJson(data);

//           print(data);

//           // Initialize selections based on max option length
//           selectedOptions.clear();
//           if (product.value!.variants.isNotEmpty) {
//             final maxOptionsLength = product.value!.variants
//                 .map((v) => v.options.length)
//                 .reduce((a, b) => a > b ? a : b);

//             for (int i = 0; i < maxOptionsLength; i++) {
//               selectedOptions[i] = ''.obs;

//               // // Set default selection (first variant)
//               // if (i < product.value!.variants.first.options.length) {
//               //   selectedOptions[i]!.value =
//               //       product.value!.variants.first.options[i];
//               // }
//             }

//             // Select default variant
//             selectedVariant.value = product.value!.variants.first;
//           }
//         } else {
//           hasError.value = true;
//         }
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching product: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Update selection dynamically
//   void setOption(int rowIndex, String option) {
//     selectedOptions[rowIndex]!.value =
//         selectedOptions[rowIndex]!.value == option ? '' : option;
//     _updateSelectedVariant();
//   }

//   void _updateSelectedVariant() {
//     if (product.value == null) return;

//     // Find first variant that matches all selected options
//     selectedVariant.value = product.value!.variants.firstWhereOrNull((v) {
//       for (int i = 0; i < v.options.length; i++) {
//         final sel = selectedOptions[i]?.value;
//         if (sel != null && sel.isNotEmpty && sel != v.options[i]) return false;
//       }
//       return true;
//     });
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     final productId = Get.parameters['productId'] ?? '';
//     if (productId.isNotEmpty) fetchProductByID(productId);
//   }
// }

// class ShowcaseController extends GetxController {
// // var product = Rxn<ProductModel>();
//   var isLoading = false.obs;
//   var hasError = false.obs;
//   var selectedVariant = Rxn<VariantModel>();
//   final Rx<ProductModel?> product = Rx<ProductModel>();

//   var selectedOptions = <int, RxString>{}.obs; // dynamic selection map

//   // Fetch product by ID
//   // Fetch product
//   Future<void> fetchProductByID(String productId) async {
//     if (productId.isEmpty) return;
//     isLoading.value = true;
//     hasError.value = false;

//     try {
//       final response = await http.get(
//         Uri.parse("https://app2.apidoxy.com/api/v1/products/$productId"),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         if (body['success'] == true && body['data'] != null) {
//           product.value = ProductModel.fromJson(body['data']);
//           print(
//               "********************************************************************************");
//           print("Fetched product: ${product.value?.title}");
//           print("body data: ${body['data']}");

//           // Initialize dynamic selections based on max option length
//           selectedOptions.clear();
//           if (product.value!.variants.isNotEmpty) {
//             final maxOptionsLength = product.value!.variants
//                 .map((v) => v.options.length)
//                 .reduce((a, b) => a > b ? a : b);

//             for (int i = 0; i < maxOptionsLength; i++) {
//               selectedOptions[i] = ''.obs;

//               // Set default selection (first variant)
//               if (i < product.value!.variants.first.options.length) {
//                 selectedOptions[i]!.value =
//                     product.value!.variants.first.options[i];
//               }
//             }

//             // Select default variant
//             selectedVariant.value = product.value!.variants.first;
//           }
//         } else {
//           hasError.value = true;
//         }
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching product: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Update selection dynamically
//   // Select one option per row
//   void setOption(int rowIndex, String option) {
//     // toggle selection
//     selectedOptions[rowIndex]!.value =
//         selectedOptions[rowIndex]!.value == option ? '' : option;
//     _updateSelectedVariant();
//   }

//   void _updateSelectedVariant() {
//     if (product.value == null) return;

//     // Find first variant that matches all selected options
//     selectedVariant.value = product.value!.variants.firstWhereOrNull((v) {
//       for (int i = 0; i < v.options.length; i++) {
//         if (selectedOptions[i]?.value != '' &&
//             selectedOptions[i]?.value != v.options[i]) return false;
//       }
//       return true;
//     });
//   }

//   // Initialize after fetching product
//   void initSelections() {
//     if (product.value == null) return;
//     selectedOptions.clear();

//     for (int i = 0; i < product.value!.variants.length; i++) {
//       selectedOptions[i] = ''.obs; // row = variant index
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     final productId = Get.parameters['productId'] ?? '';
//     if (productId.isNotEmpty) fetchProductByID(productId);
//   }
// }


  // Future<void> fetchProductByID(String productId) async {
  //   if (productId.isEmpty) {
  //     hasError.value = true;
  //     print("Error: productId is empty");
  //     return;
  //   }

  //   isLoading.value = true;
  //   hasError.value = false;

  //   try {
  //     final response = await http.get(
  //       Uri.parse("https://app2.apidoxy.com/api/v1/products/$productId"),
  //       headers: {
  //         "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //         "Content-Type": "application/json",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final body = jsonDecode(response.body);

  //       if (body['success'] == true &&
  //           body['data'] != null &&
  //           body['data'] is Map) {
  //         final productData = body['data'];
  //         product.value = ProductModel.fromJson(productData);

  //         // Reset selections
  //         selectedColor.value = '';
  //         selectedSize.value = '';

  //         if (product.value != null && product.value!.variants.isNotEmpty) {
  //           selectedVariant.value = product.value!.variants.first;
  //         }
  //       } else {
  //         hasError.value = true;
  //       }
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     print("Error fetching product: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // var selectedColor = ''.obs;
  // var selectedSize = ''.obs;

  // // Setters for independent selection
  // void setColor(String color) {
  //   selectedColor.value = color;
  // }

  // void setSize(String size) {
  //   selectedSize.value = size;
  // }



//   Future<void> fetchProductByID(String productId) async {
//     if (productId.isEmpty) {
//       hasError.value = true;
//       print("Error: productId is empty");
//       return;
//     }

//     isLoading.value = true;
//     hasError.value = false;

//     try {
//       final response = await http.get(
//         Uri.parse("https://app2.apidoxy.com/api/v1/products/$productId"),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );
//       print("Response body: ${response.body}"); // debug

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);

//         // এখন data একটি Map
//         if (body['success'] == true &&
//             body['data'] != null &&
//             body['data'] is Map) {
//           final productData = body['data'];
//           product.value = ProductModel.fromJson(productData);
//           for (var v in product.value!.variants) {
//             print("Variant id: ${v.id}, options: ${v.options}");

//           }
//           if (product.value != null && product.value!.variants.isNotEmpty) {
//             selectedVariant.value = product.value!.variants.first;
//           }
//         } else {
//           hasError.value = true;
//           print("Error: API returned no product data");
//         }
//       } else {
//         hasError.value = true;
//         print("Error: Status code ${response.statusCode}");
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching product: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

// //  var selectedOptions = <String?>[].obs;
//   // Selected options (color, size) reactive
//   var selectedOptions = <String, String>{
//     'color': '',
//     'size': '',
//   }.obs;

  // void selectOption(int optionIndex, String optionValue) {
  //   selectedOptions[optionIndex] = optionValue;

  //   // নতুন selectedVariant নির্ধারণ
  //   final matched = product.value!.variants.firstWhere(
  //     (v) {
  //       for (int i = 0; i < selectedOptions.length; i++) {
  //         if (i >= v.options.length) return false;
  //         if (v.options[i] != selectedOptions[i]) return false;
  //       }
  //       return true;
  //     },
  //     orElse: () => product.value!.variants.first,
  //   );

  //   selectedVariant.value = matched;
  // }

 

  // Add this field

  // Future<void> fetchProductbyID(String productId) async {
  //   isLoading.value = true;
  //   hasError.value = false;

  //   try {
  //     final response = await get(
  //       "https://app2.apidoxy.com/api/v1/products/details/{productId}",
  //       headers: {
  //         "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //         //   "Content-Type": "application/json",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final body = response.body;

  //       if (body is Map<String, dynamic> &&
  //           body['success'] == true &&
  //           body['data'] != null &&
  //           body['data'] is List &&
  //           (body['data'] as List).isNotEmpty) {
  //         final firstProduct = body['data'][0]; // first element of list
  //         product.value = ProductModel.fromJson(firstProduct);
  //         //   body['success'] == true &&
  //         //   body['data'] != null) {
  //         // product.value = ProductModel.fromJson(body['data']);

  //         // প্রথম variant auto select করবে
  //         if (product.value != null && product.value!.variants.isNotEmpty) {
  //           selectedVariant.value = product.value!.variants.first;
  //         }
  //         print("status code: ${response.statusCode}");
  //       } else {
  //         hasError.value = true;
  //       }
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     print("Error fetching product: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // // Removed initState() as it's not applicable for GetxService/GetConnect.
  // // To fetch product on controller initialization, use onInit() instead:

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchProductbyID(Get.parameters['productID'] ?? "");
  // }

  // Future<void> fetchProduct(String? id) async {
  //   isLoading.value = true;
  //   hasError.value = false;

  //   try {
  //     final response = await get("https://api.npoint.io/bd71758417920fd0a243");

  //     if (response.statusCode == 200) {
  //       final data = response.body;

  //       if (data is Map<String, dynamic>) {
  //         product.value = ProductModel.fromJson(data);
  //         if (product.value != null && product.value!.variants.isNotEmpty) {
  //           selectedVariant.value = product.value!.variants.first;
  //         }
  //       } else {
  //         hasError.value = true;
  //       }
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     print("Error fetching product: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

