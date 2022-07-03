import 'package:flutter/material.dart';

class AppColors {

  const AppColors();


  static const Color appBarTitle = const Color(0xff000000);
  static const Color appBarIconColor = const Color(0xFFFFFFFF);
  static const Color appBackground = const Color(0xFFFFFFFF);
  static const Color appBarGradientStart = const Color(0xFF3383FC);
  static const Color appBarGradientEnd = const Color(0xFF00C6FF);

  static const Color validValueColor = Colors.green;
  static const Color errorValueColor = Colors.red;
  static const Color accentColor = Color(0xff53B553);
  static const Color iconColor = Color(0xFFEFF1F7);
  static const Color secondaryTextColor = Color(0xff818391);

}

class Dimens {
  const Dimens();

  static const planetWidth = 100.0;
  static const planetHeight = 100.0;
}

class TextStyles {

  const TextStyles();

  static const TextStyle appBarTitle = const TextStyle(
      color: AppColors.appBarTitle,
      fontFamily: 'Poppins',

  );



}