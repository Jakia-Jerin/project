import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/showcase/action_view.dart';
import 'package:theme_desiree/showcase/about_view.dart';
import 'package:theme_desiree/showcase/image_slider.dart';
import 'package:theme_desiree/showcase/product_label.dart';
import 'package:theme_desiree/showcase/review_view.dart';
import 'package:theme_desiree/showcase/showcase_controller.dart';
import 'package:theme_desiree/showcase/details_view.dart';

class ShowcaseView extends StatelessWidget {
  ShowcaseView({super.key});

  final ShowcaseController showcaseController = Get.put(ShowcaseController());

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'];
    return GetX<ShowcaseController>(
      init: showcaseController..fetchProduct(id),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.hasError.value) {
          return Center(child: Text("Error loading product"));
        } else if (controller.product.value == null) {
          return Center(child: Text("No product available"));
        }
        final product = controller.product.value;

        if (product == null) {
          return Center(child: Text("No product available"));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              ImageSlider(images: product.images),
              Transform.translate(
                offset: Offset(0, -20),
                child: FCard(
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductLabel(
                        title: product.title,
                        badges: product.tags,
                      ),
                      ActionView(
                        available: product.available,
                        variants: product.variants,
                        options: product.options,
                        price: product.price,
                        compareAtPrice: product.compareAtPrice,
                      ),
                      FTabs(
                        initialIndex: 0,
                        tabs: [
                          FTabEntry(
                            label: Text('About'),
                            content: AboutView(
                              description: product.description,
                            ),
                          ),
                          FTabEntry(
                            label: Text('Details'),
                            content: DetailsView(
                              specifications: product.details,
                            ),
                          ),
                          FTabEntry(
                            label: Text('Reviews'),
                            content: ReviewView(
                              reviews: product.reviews,
                            ),
                          ),
                        ],
                        onPress: (index) {},
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
