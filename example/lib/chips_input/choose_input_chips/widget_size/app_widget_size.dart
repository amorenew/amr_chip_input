import 'package:example/chips_input/choose_input_chips/widget_size/widget_size_controller.dart';
import 'package:flutter/material.dart';

class AppWidgetSize extends StatelessWidget {
  const AppWidgetSize({
    required this.child,
    required this.widgetSizeController,
    super.key,
  });

  final Widget child;
  final WidgetSizeController widgetSizeController;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        widgetSizeController.updateSize(
          (context.findRenderObject()! as RenderBox).size,
        );
      },
    );
    return child;
  }
}
