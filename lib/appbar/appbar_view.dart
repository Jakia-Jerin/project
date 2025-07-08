import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:theme_desiree/appbar/appbar_view_model.dart';
import 'package:theme_desiree/constants.dart';

class AppbarView extends StatelessWidget {
  const AppbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppbarViewModel()..fetchAppbar(),
      child: Consumer<AppbarViewModel>(
        builder: (context, viewModel, child) {
          List<SvgAsset> symbols = [
            FAssets.icons.zap,
            FAssets.icons.tag,
            FAssets.icons.badgePercent,
            FAssets.icons.tags,
            FAssets.icons.gift,
            FAssets.icons.package2
          ];

          if (viewModel.isLoading) {
            return SizedBox(height: 62);
          }
          if (viewModel.hasError) {
            return SizedBox(height: 62);
          }

          return Container(
            padding: EdgeInsets.all(8),
            child: Flex(
              direction: Axis.horizontal,
              spacing: 8,
              children: [
                SizedBox(
                  height: 30,
                  child: Image.asset(
                    "logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: FTextField(
                    hint: "Search products or categories",
                    suffixBuilder: (context, style, child) =>
                        FIcon(FAssets.icons.search),
                    keyboardType: TextInputType.text,
                    onSubmit: (value) {
                      final query = value.toLowerCase().trim();
                      if (query.isNotEmpty) {
                        Get.toNamed('/search?query=$query');
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: viewModel.appbar.offers.isNotEmpty &&
                      Constants.screenWidth(context) > 960,
                  replacement: SizedBox.shrink(),
                  child: Row(
                    spacing: 12,
                    children: viewModel.appbar.offers.map(
                      (item) {
                        return InkWell(
                          onTap: () => Get.toNamed("/offers/${item.handle}"),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              spacing: 6,
                              children: [
                                FIcon(
                                  (symbols..shuffle()).first,
                                  size: 24,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 0,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        item.longTitle,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          height: 0.9,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        item.shortTitle,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.italic,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                FButton(
                  onPress: () => Get.toNamed("/cart"),
                  prefix: FIcon(FAssets.icons.shoppingCart),
                  label: Text("Cart"),
                ),
                FButton(
                  onPress: () => Get.toNamed("/settings"),
                  prefix: FIcon(FAssets.icons.userRound),
                  label: Text("Account"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
