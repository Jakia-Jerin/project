import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/faq.dart';

class FaqView extends StatelessWidget {
  final Map<String, dynamic> data;
  const FaqView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tag = UniqueKey().toString();
    final faqController = Get.put(FaqController(), tag: tag);
    final contextTheme = FTheme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      faqController.fromJson(data);
    });

    return GetX<FaqController>(
      tag: tag,
      builder: (controller) {
        if (controller.isLoading.value || controller.hasError.value) {
          return SizedBox.shrink();
        }

        return FCard(
          style: contextTheme.cardStyle.copyWith(
            contentStyle: contextTheme.cardStyle.contentStyle.copyWith(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
          ),
          child: FAccordion(
            items: controller.faqs
                .map(
                  (detail) => FAccordionItem(
                    title: Text(detail.question),
                    child: Text(detail.answer),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
