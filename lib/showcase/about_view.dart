import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key, required this.description});
  final String description;
  @override
  Widget build(BuildContext context) {
    if (description.isEmpty) {
      return SizedBox.shrink();
    } else {
      return FCard(
        child: Text(description.trim()),
      );
    }
  }
}
