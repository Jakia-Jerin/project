import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ProductLabel extends StatelessWidget {
  const ProductLabel({
    super.key,
    required this.title,
    required this.badges,
  });

  final String title;
  final List<String> badges;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (badges.isNotEmpty)
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: badges
                .map(
                  (badge) => FBadge(
                    label: Text(badge),
                  ),
                )
                .toList(),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            style: FTheme.of(context).typography.lg.copyWith(height: 1.2),
          ),
        ),
      ],
    );
  }
}
