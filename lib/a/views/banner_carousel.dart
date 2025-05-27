import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as indicator;
import 'package:theme_desiree/a/controllers/banner_carousel.dart';

class BannerCarousel extends StatelessWidget {
  final Map<String, dynamic> data;
  const BannerCarousel({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String tag = UniqueKey().toString();
    final bannerCarouselController =
        Get.put(BannerCarouselController(), tag: tag);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bannerCarouselController.fromJson(data);
    });

    final contextTheme = FTheme.of(context);
    return GetX<BannerCarouselController>(
      tag: tag,
      builder: (controller) {
        if (controller.isLoading.value || controller.hasError.value) {
          return SizedBox.shrink();
        }

        return FCard(
          style: FCardStyle(
            decoration: contextTheme.calendarStyle.decoration,
            contentStyle: FCardContentStyle(
              titleTextStyle: TextStyle(),
              subtitleTextStyle: TextStyle(),
              padding: EdgeInsets.all(1),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1024 / 480,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    onPageChanged: (index, reason) {
                      controller.activeSlide.value = index;
                    },
                  ),
                  items: controller.images.map((image) {
                    return Image.network(
                      image,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: indicator.SmoothPageIndicator(
                        controller: PageController(
                          initialPage: controller.activeSlide.value,
                        ),
                        count: controller.images.length,
                        axisDirection: Axis.horizontal,
                        effect: indicator.ScrollingDotsEffect(
                          dotWidth: 10.0,
                          dotHeight: 10.0,
                          paintStyle: PaintingStyle.fill,
                          strokeWidth: 1.5,
                          dotColor: contextTheme.colorScheme.secondary,
                          activeDotColor: contextTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
