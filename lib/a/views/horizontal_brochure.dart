import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/horizontal_brochure.dart';
import 'package:theme_desiree/a/views/product_mini_card.dart';

class HorizontalBrochure extends StatelessWidget {
  final Map<String, dynamic> data;
  const HorizontalBrochure({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String tag = UniqueKey().toString();
    final horizontalBrochureController =
        Get.put(HorizontalBrochureController(), tag: tag);

    horizontalBrochureController.fromJson(data);

    final contextTheme = FTheme.of(context);

    return GetX<HorizontalBrochureController>(
      tag: tag,
      builder: (controller) {
        if (controller.isLoading.value || controller.hasError.value) {
          return SizedBox.shrink();
        }

        final brochure = controller.brochure.value;
        if (brochure == null) {
          return SizedBox.shrink();
        }

        return FCard.raw(
          style: contextTheme.cardStyle.copyWith(
            contentStyle: contextTheme.cardStyle.contentStyle.copyWith(
              padding: EdgeInsets.all(1),
            ),
          ),
          child: Column(
            children: [
              if (brochure.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Image.network(brochure.image!, fit: BoxFit.cover),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 8,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            brochure.title,
                            style: contextTheme.typography.base,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            brochure.subtitle,
                            style: contextTheme.typography.sm,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    FButton(
                      style: contextTheme.buttonStyles.primary.copyWith(
                        contentStyle: contextTheme
                            .buttonStyles.primary.contentStyle
                            .copyWith(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      onPress: () => Get.toNamed(brochure.handle),
                      label: Text(
                        "View more",
                        style: contextTheme.typography.sm.copyWith(
                            color: contextTheme.colorScheme.foreground),
                      ),
                      suffix: FIcon(
                        FAssets.icons.chevronRight,
                        size: 18,
                        color: contextTheme.colorScheme.foreground,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  physics: BouncingScrollPhysics(),
                  itemCount: brochure.products.length,
                  itemBuilder: (context, index) {
                    final id = brochure.products[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 172,
                        child: ProductMiniCard(data: id),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
