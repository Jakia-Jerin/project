import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/address/address_controller.dart';

class AddressMethod extends StatelessWidget {
  const AddressMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    final AddressController controller = Get.put(AddressController());

    return GestureDetector(
      onTap: () {
        Get.toNamed('/settings/address');
      },
      child: Obx(() {
        final selected = controller.selectedAddress.value;

        if (selected == null) {
          return Center(
            child: Text(
              "Select your Address",
              style: TextStyle(
                color: contextTheme.colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return FTileGroup(
          children: [
            FTile(
              suffixIcon: GestureDetector(
                onTap: () => Get.toNamed("/settings/address"),
                child: Icon(LucideIcons.chevron_right),
              ),
              prefixIcon: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/images.jpg',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                maxLines: 5,
                selected.line1,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                maxLines: 5,
                "${selected.phone},${selected.district ?? ''}, ${selected.region ?? ''}, ${selected.postcode ?? ''}, ${selected.country ?? ''}",
                //  "${selected.district}, ${selected.region}, ${selected.postcode}, ${selected.country}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// class AddressMethod extends StatelessWidget {
//   const AddressMethod({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final contextTheme = FTheme.of(context);
//     final AddressController controller =
//         Get.put(AddressController()); // or use Get.put only once globally

//     return GestureDetector(
//       onTap: () {
//         Get.toNamed('/settings/address');
//       },
//       child: Obx(() {
//         final selected = controller.selectedAddress.value;
//         if (selected == null) {
//           return Center(
//               child: Text("Select your Address",
//                   style: TextStyle(
//                       color: contextTheme.colorScheme.primary,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold)));
//         }
//         // if (controller.savedAddresses.isEmpty) {
//         //   return Center(
//         //     child: Text(
//         //       "No saved addresses yet.",
//         //       style: TextStyle(color: contextTheme.typography.lg.color),
//         //     ),
//         //   );
//         // }

//         return FTileGroup(

//             //    final address = controller.savedAddresses[index];
//             //    final isSelected = controller.selectedIndex.value == index;
//             children: [
//               FTile(
//                   suffixIcon: GestureDetector(
//                       onTap: () => Get.toNamed("settings/address"),
//                       child: Icon(LucideIcons.chevron_right)),
//                   prefixIcon: ClipRRect(
//                     borderRadius: BorderRadius.circular(6),
//                     child: Image.asset(
//                       'assets/images.jpg',
//                       width: 30,
//                       height: 30,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   title: Text(
//                     maxLines: 5,
//                     selected.line1,
//                     style: const TextStyle(
//                         fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: selected.district.trim().isNotEmpty
//                       ? Text(
//                           maxLines: 5,
//                           "${selected.district}, ${selected.region}, ${selected.postcode}, ${selected.addressType.tr.toUpperCase()}",
//                           style: const TextStyle(fontSize: 14),
//                         )
//                       : Text(
//                           maxLines: 5,
//                           "${selected.district}, ${selected.region}, ${selected.postcode}, ${selected.addressType.tr.toUpperCase()}",
//                           style: const TextStyle(fontSize: 14),
//                         )
//                   // onLongPress: () {
//                   //   controller.selectedIndex.value = index;

//                   // },
//                   )
//             ]);
//       }),
//     );
//   }
// }
