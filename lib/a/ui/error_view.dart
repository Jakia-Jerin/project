import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class ErrorView extends StatelessWidget {
  final String? body;
  final String? solution;
  final Function()? retry;
  const ErrorView({
    super.key,
    this.body,
    this.solution,
    this.retry,
  });

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            if (retry != null)
              FButton.icon(
                onPress: () => retry?.call(),
                child: FIcon(
                  FAssets.icons.rotateCcw,
                ),
              ),
            if (body != null)
              Text(
                body ?? "Something went wrong!",
                style: contextTheme.typography.sm,
              ),
            if (solution != null)
              Text(
                solution ?? "Try restarting the app",
                style: contextTheme.typography.sm,
              ),
          ],
        ),
      ),
    );
  }
}
