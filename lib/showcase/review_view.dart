import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:theme_desiree/showcase/product_model.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({super.key, required this.reviews});
  final List<ReviewModel> reviews;

  @override
  Widget build(BuildContext context) {
    return FTileGroup(
      divider: FTileDivider.full,
      children: reviews
          .map((item) => FTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    children: List.generate(
                      item.star ?? 0,
                      (index) => FIcon(
                        FAssets.icons.star,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  if (item.image != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          item.image!,
                          width: 45,
                          height: 45,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      item.body ?? '',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )))
          .toList(),
    );
  }
}
