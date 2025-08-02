import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/address/address_controller.dart';

class SelectAddress extends StatelessWidget {
  SelectAddress({super.key});

  final AddressController controller = Get.put(AddressController());

  final TextEditingController districtController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController line1Controller = TextEditingController();
  final TextEditingController line2Controller = TextEditingController();
  final TextEditingController addressTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //  String? selectedAddressType;
    final contextTheme = FTheme.of(context);
    return Scaffold(
      backgroundColor: contextTheme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: contextTheme.colorScheme.background,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FButton.icon(
            style: FButtonStyle.outline,
            child: FIcon(
              FAssets.icons.chevronLeft,
              size: 24,
            ),
            onPress: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Add Address'.tr.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: contextTheme.typography.lg.color),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // FTextField(
              //   label: const Text("Address Type *"),
              //   controller: addressTypeController,
              //   hint: 'Home / Office',
              // ),
              const SizedBox(height: 10),
              FTextField(
                label: const Text("District *"),
                controller: districtController,
                hint: 'Please input District',
              ),
              const SizedBox(height: 10),
              FTextField(
                label: const Text("Region *"),
                controller: regionController,
                hint: 'Please input Region (ex. Chattogram Sadar)',
              ),
              const SizedBox(height: 10),
              FTextField(
                label: const Text("Post Code *"),
                controller: postcodeController,
                hint: 'Please input Post Code (ex. 4000)',
              ),
              const SizedBox(height: 10),
              FTextField(
                label: const Text("Line 1 *"),
                controller: line1Controller,
                hint: 'ex. House 12, Road 7, Nasirabad Housing Society',
              ),
              const SizedBox(height: 10),
              FTextField(
                label: const Text("Line 2 (Optional)"),
                controller: line2Controller,
                hint: 'ex. Near GEC Circle',
              ),
              const SizedBox(height: 10),

              // DropdownButtonFormField<String>(
              //   decoration: InputDecoration(
              //     labelText: "Address Type *",
              //     border:OutlineInputBorder(),
              //   ),
              //   value: selectedAddressType,
              //   items: ['Home', 'Office', 'Others'].map((type) {
              //     return DropdownMenuItem(
              //       value: type,
              //       child: Text(type),
              //     );
              //   }).toList(),
              //   onChanged: (value) {
              //     selectedAddressType = value;
              //     addressTypeController.text = value ?? '';
              //   },
              // ),

              FTextField(
                label: const Text("Address Type *"),
                controller: addressTypeController,
                hint: 'ex. Home/Office/others',
              ),
              const SizedBox(height: 15),

              // Obx(() => Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Address Category',
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 14,
              //               color: contextTheme.colorScheme.primary),
              //         ),
              //         SizedBox(width: 20),
              //         Row(
              //           children: [
              //             Radio(
              //                 value: 'home',
              //                 groupValue: controller.addressType.value,
              //                 onChanged: (value) {
              //                   controller.addressType.value = value!;
              //                 }),
              //             Text('Home'),
              //             SizedBox(width: 20),
              //             Radio(
              //                 value: 'Office',
              //                 groupValue: controller.addressType.value,
              //                 onChanged: (value) {
              //                   controller.addressType.value = value!;
              //                 }),
              //             Text('Office'),
              //           ],
              //         )
              //       ],
              //     )),
              SizedBox(height: 40),

              FButton(
                style: contextTheme.buttonStyles.primary.copyWith(
                  contentStyle:
                      contextTheme.buttonStyles.primary.contentStyle.copyWith(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                label: Text(
                  "Save Address",
                  style: contextTheme.typography.sm.copyWith(
                    color: contextTheme.typography.sm.color,
                  ),
                ),
                onPress: () {
                  controller.addressType.value = addressTypeController.text;
                  controller.district.value = districtController.text;
                  controller.region.value = regionController.text;
                  controller.postcode.value = postcodeController.text;
                  controller.line1.value = line1Controller.text;
                  controller.line2.value = line2Controller.text;
                  controller.saveAddress();
                },
              ),
              const SizedBox(height: 10),
              // FButton(
              //   label: Text("View Saved Addresses"),
              //   onPress: () {
              //     Get.toNamed("/settings/address");
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
