// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ResetView extends StatelessWidget {
//   const ResetView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         AppBar(
//           elevation: 2,
//           title: Text(
//             "Reset password",
//             style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           leading: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: ShadButton.outline(
//               onPressed: () => Get.toNamed("/settings"),
//               icon: Icon(
//                 LucideIcons.chevronLeft,
//                 size: 22,
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ShadCard(
//                 padding: EdgeInsets.all(0),
//                 child: Container(),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }