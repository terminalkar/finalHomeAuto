import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockWidth = 0;
  static double blockHeight = 0;
  static int grp = 0;
  static double textMultiplier=0;
  static double imageSizeMultiplier=0;
  static double heightMultiplier=0;
  static double widthMultiplier=0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      screenWidth = constraints.maxHeight;
      screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
    textMultiplier = blockHeight;

    if (screenHeight >= 400 && screenHeight < 500) {
      grp = 1;
    } else if (screenHeight >= 500 && screenHeight < 600) {
      grp = 2;
    } else if (screenHeight >= 600 && screenHeight < 700) {
      grp = 3;
    } else if (screenHeight >= 700 && screenHeight < 750) {
      grp = 4;
    } else {
      grp = 5;
    }
    imageSizeMultiplier = blockWidth;
    heightMultiplier = blockHeight;
    widthMultiplier = blockWidth;
    print(blockHeight);
    print(blockWidth);
    print("Hii");
  }
}
