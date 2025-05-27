import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderView extends StatelessWidget {
  final int size;
  const LoaderView({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: FTheme.of(context).colorScheme.primary,
        size: size.toDouble(),
      ),
    );
  }
}
