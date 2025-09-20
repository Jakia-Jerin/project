import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/home.dart';
import 'package:theme_desiree/a/models/section.dart';
import 'package:theme_desiree/a/views/banner_carousel.dart';
import 'package:theme_desiree/a/views/faq.dart';
import 'package:theme_desiree/a/views/horizontal_brochure.dart';
import 'package:theme_desiree/a/views/product_collage.dart';
import 'package:theme_desiree/currency/currency_controller.dart';
import 'package:theme_desiree/a/ui/error_view.dart';
import 'package:theme_desiree/a/ui/loader_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final CurrencyController currencyController = Get.find<CurrencyController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: contextTheme.colorScheme.background,
      ),
      child: Column(
        children: [
          TopBar(),
          Expanded(
            child: GetX<HomeController>(builder: (controller) {
              if (controller.isLoading.value) {
                return Center(child: const LoaderView());
              }
              if (controller.hasError.value) {
                return ErrorView(
                  body: "Failed to load store",
                  solution: "Refresh again",
                  retry: controller.fetchSections,
                );
              }
              return ListView.separated(
                itemCount: controller.sections.length,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final sortedSections =
                      List<SectionModel>.from(controller.sections)
                        ..sort((a, b) => a.index.compareTo(b.index));

                  final section = sortedSections[index];
                  switch (section.type) {
                    // case SectionType.bannerCarousal:
                    //   return BannerCarousel(data: section.data);
                    case SectionType.horizontalBrochure:
                      return HorizontalBrochure();
                    //   return HorizontalBrochure(data: section.data);
                    case SectionType.collage:
                      return ProductCollage(data: section.data);
                    // case SectionType.faq:
                    //   return FaqView(data: section.data);
                    default:
                      return SizedBox.shrink();
                  }
                },
              );
            }),
          ),
          //   SizedBox(height: 10),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: FTextField(
              hint: 'Search for products or categories'.tr,
              keyboardType: TextInputType.text,
              maxLines: 1,
              onTap: () => Get.toNamed("/search"),
              onSubmit: (value) {
                if (value.trim().isNotEmpty) {
                  Get.toNamed("/search");
                }
              },
              prefixBuilder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FIcon(FAssets.icons.search),
                );
              },
            ),
          ),
          FButton.icon(
            onPress: () => Get.toNamed('/settings/notification'),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: FIcon(
                FAssets.icons.bellDot,
                size: 22,
              ),
            ),
          )
        ],
      ),
    );
  }
}
