import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({super.key, required this.specifications});
  final Map<String, String> specifications;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FTileGroup(
          divider: FTileDivider.full,
          children: specifications.entries.map((entry) {
            return FTile(
              title: Text(
                entry.key,
                overflow: TextOverflow.visible,
              ),
              suffixIcon: SizedBox(
                width: constraints.maxWidth * 0.5,
                child: Text(
                  entry.value,
                  textAlign: TextAlign.right,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
