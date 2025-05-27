import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as indicator;

class ImageSlider extends StatefulWidget {
  final List<String> images;
  const ImageSlider({super.key, required this.images});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _activeSlide = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return SizedBox.shrink();
    } else {
      return FCard(
        style: FCardStyle(
          decoration: FTheme.of(context).calendarStyle.decoration,
          contentStyle: FCardContentStyle(
            titleTextStyle: TextStyle(),
            subtitleTextStyle: TextStyle(),
            padding: EdgeInsets.all(0),
          ),
        ),
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 1 / 1,
                enlargeCenterPage: false,
                viewportFraction: 1,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                onPageChanged: (index, reason) {
                  setState(() {
                    _activeSlide = index;
                  });
                },
              ),
              items: widget.images.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(
                      image,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    );
                  },
                );
              }).toList(),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: FButton.icon(
                onPress: () {
                  Get.toNamed("/search");
                },
                style: FButtonStyle.secondary,
                child: FIcon(
                  FAssets.icons.chevronLeft,
                  size: 22,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: indicator.SmoothPageIndicator(
                    controller: PageController(initialPage: _activeSlide),
                    count: widget.images.length,
                    axisDirection: Axis.horizontal,
                    effect: indicator.ScrollingDotsEffect(
                      dotWidth: 10.0,
                      dotHeight: 10.0,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 1.5,
                      dotColor: FTheme.of(context).colorScheme.secondary,
                      activeDotColor: FTheme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
