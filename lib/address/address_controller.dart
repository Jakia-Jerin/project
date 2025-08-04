import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:theme_desiree/address/address_model.dart';

class AddressController extends GetConnect implements GetxService {
  final storage = GetStorage();

  // Form fields
  var addressType = ''.obs;
  var line1 = ''.obs;
  var line2 = ''.obs;
  var region = ''.obs;
  var district = ''.obs;
  var postcode = ''.obs;

  // Saved addresses list
  var savedAddresses = <FullAddress>[].obs;
  Rx<FullAddress?> selectedAddress = Rx<FullAddress?>(null);

  void selectAddress(FullAddress address) {
    selectedAddress.value = address;
    print(storage.read('selectedAddress'));
    storage.write('selectedAddress', address.toJson());
  }

  void deleteaddress(FullAddress address) {
    savedAddresses.remove(address);
    // Update storage as well
    List savedList = savedAddresses.map((e) => e.toJson()).toList();
    storage.write('savedAddresses', savedList);

    // optional if you're using GetBuilder or Getx
    Get.snackbar('Deleted', 'Address removed successfully');

    if (selectedAddress.value == address) {
      selectedAddress.value = null;
      storage.remove('selectedAddress');
    }
  }

  var selectedIndex = RxnInt();

  void saveAddress() {
    if (addressType.value.isEmpty ||
        line1.value.isEmpty ||
        region.value.isEmpty ||
        district.value.isEmpty ||
        postcode.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    final newAddress = FullAddress(
      addressType: addressType.value,
      line1: line1.value,
      line2: line2.value.isNotEmpty ? line2.value : null,
      region: region.value,
      district: district.value,
      postcode: postcode.value,
    );

    List savedList = storage.read('savedAddresses') ?? [];
    savedList.insert(0, newAddress.toJson());
    storage.write('savedAddresses', savedList);

    savedAddresses
        .assignAll(savedList.map((e) => FullAddress.fromJson(e)).toList());

    // Clear inputs after saving
    addressType.value = '';
    line1.value = '';
    line2.value = '';
    region.value = '';
    district.value = '';
    postcode.value = '';

    Get.snackbar('Success', 'Address saved successfully');
    Get.toNamed("settings/address");
  }

  late TextEditingController typeCtrl;
  late TextEditingController line1Ctrl;
  late TextEditingController line2Ctrl;
  late TextEditingController regionCtrl;
  late TextEditingController districtCtrl;
  late TextEditingController postcodeCtrl;

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

  void loadAddresses() {
    List savedList = storage.read('savedAddresses') ?? [];
    savedAddresses
        .assignAll(savedList.map((e) => FullAddress.fromJson(e)).toList());

    Map<String, dynamic>? selectedData = storage.read('selectedAddress');
    selectedAddress.value = FullAddress.fromJson(selectedData!);
    print("Loaded saved selected address: ${selectedAddress.value}");
    }

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  // Load selected address from storage
}
