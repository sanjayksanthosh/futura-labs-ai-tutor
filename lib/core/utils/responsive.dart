import 'package:flutter/material.dart';

class Responsive {
  static double _screenWidth = 0;
  static double _screenHeight = 0;

  static void init(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
  }

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;

  static bool get isMobile => _screenWidth < 600;
  static bool get isTablet => _screenWidth >= 600 && _screenWidth < 1024;
  static bool get isDesktop => _screenWidth >= 1024;

  static double width(double percentage) => _screenWidth * percentage;
  static double height(double percentage) => _screenHeight * percentage;

  static double fontScale(double size) {
    if (isMobile) return size;
    if (isTablet) return size * 1.2;
    return size * 1.4;
  }

  static double padding(double value) {
    if (isMobile) return value;
    if (isTablet) return value * 1.5;
    return value * 2;
  }

  static double gridChildAspectRatio(bool isTabletDevice) {
    return isTabletDevice ? 1.2 : 0.85;
  }

  static int gridCrossAxisCount(bool isTabletDevice) {
    return isTabletDevice ? 3 : 2;
  }
}
