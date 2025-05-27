import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class DeviceType {
  final String name;
  const DeviceType._(this.name);

  static const DeviceType mobile = DeviceType._("mobile");
  static const DeviceType tablet = DeviceType._("tablet");
  static const DeviceType laptop = DeviceType._("laptop");
  static const DeviceType desktop = DeviceType._("desktop");
  static const DeviceType tv = DeviceType._("tv");

  bool get isMobile => this == mobile;
  bool get isTablet => this == tablet;
  bool get isLaptop => this == laptop;
  bool get isDesktop => this == desktop;
  bool get isTv => this == tv;

  @override
  String toString() => name;
}

class Constants {
  static String host = "https://api.npoint.io/";
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static DeviceType device(BuildContext context) {
    double width = screenWidth(context);

    if (width <= 480) return DeviceType.mobile;
    if (width <= 768) return DeviceType.tablet;
    if (width <= 1024) return DeviceType.laptop;
    if (width <= 1200) return DeviceType.desktop;
    return DeviceType.tv;
  }

  static String appTitle = "Wardiere";
  static List<FThemeData> appLightColorSchemes = [
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
  ];
  static List<FThemeData> appDarkColorSchemes = [
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
    FThemes.zinc.light,
  ];
}
