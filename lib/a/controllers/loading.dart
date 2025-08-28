// import 'package:flutter/material.dart';
// import 'package:forui/forui.dart';
// import 'package:get/get.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// class LoadingController extends GetxController {
//   void showLoadingAndNavigate(BuildContext context, String routeName) {
//     final contextTheme = FTheme.of(context);
//     // Loading dialog দেখাও
//     Get.dialog(
//       Center(
//         child: Container(
//           child: LoadingAnimationWidget.staggeredDotsWave(
//             color: contextTheme.colorScheme.primary,
//             size: 200,
//           ),
//         ),
//       ),
  
//     );

//     Future.delayed(Duration(seconds: 3), () {
//       Get.back();
//       Get.toNamed(); 
//     });
//   }
// }