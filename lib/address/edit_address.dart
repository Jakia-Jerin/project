import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/address/address_controller.dart';
import 'package:theme_desiree/address/address_model.dart';

class EditAddress extends StatefulWidget {
  final FullAddress address;

  const EditAddress({super.key, required this.address});

//  const EditAddress({super.key, required this.address});

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final AddressController controller = Get.put(AddressController());

  late TextEditingController typeCtrl;
  late TextEditingController line1Ctrl;
  late TextEditingController line2Ctrl;
  late TextEditingController regionCtrl;
  late TextEditingController districtCtrl;
  late TextEditingController postcodeCtrl;

  @override
  void initState() {
    super.initState();

    typeCtrl = TextEditingController(text: widget.address.addressType);
    line1Ctrl = TextEditingController(text: widget.address.line1);
    line2Ctrl = TextEditingController(text: widget.address.line2 ?? '');
    regionCtrl = TextEditingController(text: widget.address.region);
    districtCtrl = TextEditingController(text: widget.address.district);
    postcodeCtrl = TextEditingController(text: widget.address.postcode);
  }

  @override
  void dispose() {
    typeCtrl.dispose();
    line1Ctrl.dispose();
    line2Ctrl.dispose();
    regionCtrl.dispose();
    districtCtrl.dispose();
    postcodeCtrl.dispose();
    super.dispose();
  }

  void updateAddress() {
    final updated = FullAddress(
      addressType: typeCtrl.text,
      line1: line1Ctrl.text,
      line2: line2Ctrl.text,
      region: regionCtrl.text,
      district: districtCtrl.text,
      postcode: postcodeCtrl.text,
    );

    // update logic
    int index = controller.savedAddresses.indexWhere(
      (addr) => addr == widget.address,
    );

    if (index != -1) {
      controller.savedAddresses[index] = updated;

      List newList = controller.savedAddresses.map((e) => e.toJson()).toList();
      controller.storage.write('savedAddresses', newList);
      controller.savedAddresses.refresh();

      Get.snackbar('Success', 'Address updated');
      Get.toNamed("settings/address");
    } else {
      Get.snackbar('Error', 'Failed to update address');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Edit My Address'.tr.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      // Divider

      //   appBar: AppBar(title: const Text("Edit My Address")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FTextField(
              label: const Text("District *"),
              controller: districtCtrl,
              hint: 'Please input District',
            ),
            const SizedBox(height: 10),
            FTextField(
              label: const Text("Region *"),
              controller: regionCtrl,
              hint: 'Please input Region (ex. Chattogram Sadar)',
            ),
            const SizedBox(height: 10),
            FTextField(
              label: const Text("Post Code *"),
              controller: postcodeCtrl,
              hint: 'Please input Post Code (ex. 4000)',
            ),
            FTextField(
              label: const Text("Line 1 *"),
              controller: line1Ctrl,
              hint: 'ex. House 12, Road 7, Nasirabad Housing Society',
            ),
            const SizedBox(height: 10),
            FTextField(
              label: const Text("Line 2 (Optional)"),
              controller: line2Ctrl,
              hint: 'ex. Near GEC Circle',
            ),
            const SizedBox(height: 10),
            FTextField(
              label: const Text("Address Type *"),
              controller: typeCtrl,
              hint: 'Please input Post Code (ex. 4000)',
            ),
            const SizedBox(height: 30),
            FButton(
              onPress: updateAddress,
              label: const Text('Update Address'),
            ),
          ],
        ),
      ),
    );
  }
}
