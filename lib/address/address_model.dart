class FullAddress {
  final String addressType; // New field
  final String line1;
  final String? line2;
  final String region;
  final String district;
  final String postcode;

  FullAddress({
    required this.addressType,
    required this.line1,
    this.line2,
    required this.region,
    required this.district,
    required this.postcode,
  });

  factory FullAddress.fromJson(Map<String, dynamic> json) {
    return FullAddress(
      addressType: json['addressType'],
      line1: json['line1'],
      line2: json['line2'],
      region: json['region'],
      district: json['district'],
      postcode: json['postcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressType': addressType,
      'line1': line1,
      'line2': line2,
      'region': region,
      'district': district,
      'postcode': postcode,
    };
  }
}
















// class AddressModel {
//   final String name;
//   final String phoneNumber;
//   final String addressType;
//   final String district;
//   final List<CityModel> cities;

//   AddressModel({required this.name,
//     required this.phoneNumber,
//     required this.addressType,required this.district, required this.cities});

//   factory AddressModel.fromJson(Map<String, dynamic> json) {
//     return AddressModel(
//       district: json['district'],
//       cities: (json['cities'] as List)
//           .map((e) => CityModel.fromJson(e))
//           .toList(),
//             name: json['name'],
//       phoneNumber: json['phoneNumber'],
//       addressType: json['addressType'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'district': district,
//         'cities': cities.map((e) => e.toJson()).toList(),
//          'name': name,
//       'phoneNumber': phoneNumber,
//       'addressType': addressType,
//       };
// }

// class CityModel {
//   final String city;
//   final List<String> areas;

//   CityModel({required this.city, required this.areas});

//   factory CityModel.fromJson(Map<String, dynamic> json) {
//     return CityModel(
//       city: json['city'],
//       areas: List<String>.from(json['areas']),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'city': city,
//         'areas': areas,
        
      
//       };
// }
