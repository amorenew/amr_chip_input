import 'package:example/chips_input/choose_input_chips/widget_size/widget_size_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const double defaultSheetMaximumHeight = .8;

extension ScrollControllerExtension on ScrollController {
  void scrollToBottomSheetEnd({
    required BuildContext context,
    WidgetSizeController? widgetSizeController,
  }) {
    final bool isBottomSheetMaxHeightReached = widgetSizeController == null ||
        widgetSizeController.getSize.height >=
            defaultSheetMaximumHeight * MediaQuery.sizeOf(context).height;

    if (isBottomSheetMaxHeightReached) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        animateTo(
          position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      });
    }
  }
}
