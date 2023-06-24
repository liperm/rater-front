// this class is responsible for resizing pixels based on device size, used for spacing and fonts

import "package:flutter/material.dart";
import "package:get/get.dart";

class AppSize {
  BuildContext? context;
  final double height;

  AppSize({
    this.context,
    this.height = 844,
  }) {
    if (!Get.testMode) {
      context = Get.context;
    }
  }

  Size getScreenSize() {
    if (context != null) {
      return MediaQuery.of(context!).size;
    } else {
      return Size(0, height);
    }
  }

  // default screenHeight from figma and Iphone 13
  static double defaultHeight = 844;

  double getHeight(double pixel) {
    final Size screenHeight = getScreenSize();
    final double screenFactor = screenHeight.height / defaultHeight;
    return screenFactor * pixel;
  }
}
