import 'package:flutter/material.dart';
import 'package:flutter_app/infrastructure/constants/constants.dart';

class AppTextStyles {
  static TextStyle changeColor(TextStyle textStyle, Color color) {
    return TextStyle(
      fontFamily: textStyle.fontFamily,
      color: color,
      fontSize: textStyle.fontSize,
      fontWeight: textStyle.fontWeight,
      letterSpacing: textStyle.letterSpacing,
    );
  }

  static const TextStyle appBarStyle = TextStyle(
    color: Color(0xFF0C141C),
    fontSize: 18,
    fontFamily: Constants.fontFamily,
    fontWeight: FontWeight.w700,
    height: 0.07,
  );

  static const TextStyle anotationStyle = TextStyle(
    color: Color(0xFF0C141C),
    fontSize: 14,
    fontFamily: Constants.fontFamily,
    fontWeight: FontWeight.w400,
    height: 0.09,
  );

  static const TextStyle titleStyle = TextStyle(
  color: Color(0xFF0C141C),
  fontSize: 20,
  fontFamily: Constants.fontFamily,
  fontWeight: FontWeight.w700,
  height: 0.06,
  );
}