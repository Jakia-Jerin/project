import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/address/address_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    final AddressController controller = Get.put(AddressController());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FButton.icon(
                onPress: () => Get.toNamed("/settings"),
                style: FButtonStyle.outline,
                child: FIcon(
                  FAssets.icons.chevronLeft,
                  size: 24,
                ),
              ),
              Text(
                'My Address'.tr.toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              FButton.icon(
                onPress: () => Get.toNamed("/settings/selectaddress"),
                style: FButtonStyle.outline,
                child: FIcon(
                  FAssets.icons.plus,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        FDivider(
          style: contextTheme.dividerStyles.verticalStyle.copyWith(
            width: 1,
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Obx(() {
            if (controller.savedAddresses.isEmpty) {
              return const Center(child: Text("No saved addresses yet."));
            }

            return ListView.builder(
              itemCount: controller.savedAddresses.length,
              itemBuilder: (context, index) {
                final addr = controller.savedAddresses[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    key: ValueKey(addr),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            Get.toNamed("/settings/editaddress",
                                arguments: addr);
                          },
                          backgroundColor: contextTheme.colorScheme.primary,
                          foregroundColor: contextTheme.typography.sm.color,
                          icon: Icons.edit,
                          label: 'Edit',
                          flex: 2,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            // controller.deleteAddress(addr);
                          },
                          backgroundColor: Colors.grey,
                          foregroundColor: contextTheme.typography.sm.color,
                          icon: Icons.delete,
                          label: 'Delete',
                          flex: 2,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        controller.selectedAddress(addr);
                        Get.toNamed("/checkout");
                      },
                      child: FCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images.jpg',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    addr.phone,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    addr.line1,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${addr.district ?? ''}, ${addr.region ?? ''}, ${addr.postcode}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  // Text(
                                  //   "${addr.district}, ${addr.region}, ${addr.postcode}",
                                  //   style: const TextStyle(fontSize: 14),
                                  // ),
                                  Text(
                                    addr.country,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            FIcon(FAssets.icons.chevronRight)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () {
              Get.toNamed('/settings/selectaddress');
            },
            child: FCard(
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '+ Add Address',
                      style: TextStyle(color: contextTheme.colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

// class AddressPage extends StatelessWidget {
//   const AddressPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final contextTheme = FTheme.of(context);
//     final AddressController controller = Get.put(AddressController());
//     final selected = controller.selectedAddress.value;

//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               FButton.icon(
//                 onPress: () => Get.toNamed("/settings"),
//                 style: FButtonStyle.outline,
//                 child: FIcon(
//                   FAssets.icons.chevronLeft,
//                   size: 24,
//                 ),
//               ),
//               Text(
//                 'My Address'.tr.toUpperCase(),
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//               ),
//               //    const SizedBox(width: 40),
//               FButton.icon(
//                 onPress: () => Get.toNamed("/settings/selectaddress"),
//                 style: FButtonStyle.outline,
//                 child: FIcon(
//                   FAssets.icons.plus,
//                   size: 24,
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Divider
//         FDivider(
//           style: contextTheme.dividerStyles.verticalStyle.copyWith(
//             width: 1,
//             padding: EdgeInsets.zero,
//           ),
//         ),
//         SizedBox(height: 10),

//         Expanded(
//           child: Obx(() {
//             if (controller.savedAddresses.isEmpty) {
//               return const Center(child: Text("No saved addresses yet."));
//             }

//             return ListView.builder(
//               itemCount: controller.savedAddresses.length,
//               itemBuilder: (context, index) {
//                 final addr = controller.savedAddresses[index];

//                 return SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Slidable(
//                       key: ValueKey(addr),
//                       // startActionPane: ActionPane(
//                       //   motion: const DrawerMotion(), // Slide motion
//                       //   children: [
//                       //     SlidableAction(
//                       //       onPressed: (context) {
//                       //         Get.toNamed("/settings/editaddress",
//                       //             arguments: addr);
//                       //         // handle edit here
//                       //         //    print("Edit tapped for: ${addr.line1}");
//                       //         // You can call a method like controller.editAddress(addr);
//                       //       },
//                       //       backgroundColor: contextTheme.colorScheme.primary,
//                       //       foregroundColor: contextTheme.typography.sm.color,
//                       //       icon: Icons.edit,
//                       //       label: 'Edit',
//                       //       flex: 2,
//                       //     ),
//                       //     SlidableAction(
//                       //       onPressed: (context) {
//                       //         controller.deleteaddress(addr);
//                       //         // handle edit here
//                       //         //    print("Edit tapped for: ${addr.line1}");
//                       //         // You can call a method like controller.editAddress(addr);
//                       //       },
//                       //       backgroundColor: Colors.grey,
//                       //       foregroundColor: contextTheme.typography.sm.color,
//                       //       icon: Icons.delete,
//                       //       label: 'Delete',
//                       //       flex: 2,
//                       //     ),
//                       //   ],
//                       // ),
//                       endActionPane: ActionPane(
//                         motion: const DrawerMotion(), // Slide motion
//                         children: [
//                           SlidableAction(
//                             onPressed: (context) {
//                               Get.toNamed("/settings/editaddress",
//                                   arguments: addr);
//                               // handle edit here
//                               //    print("Edit tapped for: ${addr.line1}");
//                               // You can call a method like controller.editAddress(addr);
//                             },
//                             backgroundColor: contextTheme.colorScheme.primary,
//                             foregroundColor: contextTheme.typography.sm.color,
//                             icon: Icons.edit,
//                             label: 'Edit',
//                             flex: 2,
//                           ),
//                           SlidableAction(
//                             onPressed: (context) {
//                               controller.deleteaddress(addr);
//                               // handle edit here
//                               //    print("Edit tapped for: ${addr.line1}");
//                               // You can call a method like controller.editAddress(addr);
//                             },
//                             backgroundColor: Colors.grey,
//                             foregroundColor: contextTheme.typography.sm.color,
//                             icon: Icons.delete,
//                             label: 'Delete',
//                             flex: 2,
//                           ),
//                         ],
//                       ),
//                       child: GestureDetector(
//                         onTap: () {
//                           controller.selectedAddress(addr);
//                           Get.toNamed("/checkout");
//                         },
//                         child: FCard(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment
//                                 .center, // Align image and text at top
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(6),
//                                 child: Image.asset(
//                                   'assets/images.jpg',
//                                   width: 30,
//                                   height: 30,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               const SizedBox(width: 15),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       addr.line1,
//                                       style: const TextStyle(fontSize: 14),
//                                     ),
//                                     // if (addr.line2 != null &&
//                                     //     addr.line2!.trim().isNotEmpty)
//                                     //   Text(
//                                     //     addr.line2!,
//                                     //     style: const TextStyle(fontSize: 14),
//                                     //   ),
//                                     Text(
//                                       "${addr.district},${addr.region},${addr.postcode}",
//                                       style: const TextStyle(fontSize: 14),
//                                     ),
//                                     Text(
//                                       "Address Category: ${addr.addressType.tr.toUpperCase()}",
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               FIcon(FAssets.icons.chevronRight)
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//         ),

//         Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: GestureDetector(
//             onTap: () {
//               Get.toNamed('/settings/selectaddress');
//             },
//             child: FCard(
//                 child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 15, horizontal: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           '+ Add Address',
//                           style: TextStyle(
//                               color: contextTheme.colorScheme.primary),
//                         ),
//                       ],
//                     ))),
//           ),
//         )
//       ],
//     );
//   }
// }
