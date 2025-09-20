import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/product_mini_card.dart';
import 'package:theme_desiree/a/models/product_mini_card.dart';
import 'package:theme_desiree/currency/currency_controller.dart';

class ProductMiniCard extends StatelessWidget {
  final ProductMiniCardModel data;
  ProductMiniCard({super.key, required this.data});

  final productMiniCardController = Get.put(ProductMiniCardController());
  final currencyController = Get.find<CurrencyController>();
  final shopId = dotenv.env['SHOP_ID'];
  final baseUrl = dotenv.env['BASE_URL'];
  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    print("Navigating to /item with productId: ${data.id}");
    return FCard(
        style: FCardStyle(
          decoration: BoxDecoration(
            border: contextTheme.cardStyle.decoration.border,
            borderRadius: BorderRadius.circular(8),
          ),
          contentStyle: FCardContentStyle(
            subtitleTextStyle: TextStyle(),
            titleTextStyle: TextStyle(),
            padding: EdgeInsets.all(0),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Get.toNamed("/item", parameters: {"productId": data.id});
            print(
                "*************************************************************************");
            print("Navigating to /item with productId: ${data.id}");
          },
          child: Container(
            constraints: BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: (data.gallery.isNotEmpty)
                              ? Image.network(
                                  "$baseUrl/image/$shopId/${data.gallery[0]}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/download (1).jpg",
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/download (1).jpg",
                                ),

                          // child: Image.network(
                          //   "$baseUrl/image/$shopId/${data.gallery[0]}",
                          //   errorBuilder: (context, error, stackTrace) {
                          //     return Image.asset("assets/download (1).jpg",
                          //         fit: BoxFit.cover);
                          //   },
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black38, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Text(
                              data.title,
                              maxLines: 2,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            currencyController
                                .formatCurrency(data.compareAtPrice.toDouble()),
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontStyle: FontStyle.italic,
                                fontSize: 9,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      FBadge(
                        style: contextTheme.badgeStyles.primary.copyWith(
                          contentStyle: contextTheme
                              .badgeStyles.primary.contentStyle
                              .copyWith(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                          ),
                        ),
                        label: Obx(
                          () => Text(
                            currencyController
                                .formatCurrency(data.price.toDouble()),
                            style: TextStyle(
                              color: contextTheme.colorScheme.foreground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
