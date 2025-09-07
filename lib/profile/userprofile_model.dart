import 'package:theme_desiree/profile/contacts.dart';

enum Gender { male, female, other, none }

class ProfileModel {
  final String id;
  final String avatar;
  final String name;
  final Gender? gender;
  final ContactInfo email;
  final ContactInfo phone;

  ProfileModel({
    required this.id,
    required this.avatar,
    required this.name,
    required this.gender,
    required this.email,
    required this.phone,
  });

  /// CopyWith method to create a modified copy of ProfileModel
  ProfileModel copyWith({
    String? id,
    String? avatar,
    String? name,
    Gender? gender,
    ContactInfo? email,
    ContactInfo? phone,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  /// Converts JSON to ProfileModel
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      gender: parseGender(json['gender']),
      email: ContactInfo.fromMap(json['email']),
      phone: ContactInfo.fromMap(json['phone']),
    );
  }

  /// Converts ProfileModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'name': name,
      'gender': gender.toString().split('.').last,
      'email': email.toJson(),
      'phone': phone.toJson(),
    };
  }

  /// Converts gender string from JSON to Gender enum
  static Gender parseGender(String? gender) {
    switch (gender?.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'other':
        return Gender.other;
      default:
        return Gender.none;
    }
  }
  // static Gender _parseGender(String? gender) {
  //   switch (gender?.toLowerCase()) {
  //     case 'male':
  //       return Gender.male;
  //     case 'female':
  //       return Gender.female;
  //     case 'other':
  //       return Gender.other;
  //     default:
  //       return Gender.none;
  //   }
  // }
}
