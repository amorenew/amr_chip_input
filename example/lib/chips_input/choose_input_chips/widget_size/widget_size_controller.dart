import 'package:flutter/material.dart';

class WidgetSizeController extends ValueNotifier<Size> {
  WidgetSizeController() : super(Size.zero);

  bool isDisposed = false;

  void updateSize(Size size) {
    if (isDisposed) {
      return;
    }
    value = size;
    notifyListeners();
  }

  void reset() {
    if (isDisposed) {
      return;
    }

    value = Size.zero;
    notifyListeners();
  }

  Size get getSize => value;

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
