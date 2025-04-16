import 'package:flutter/material.dart';
import 'package:flutter_app/infrastructure/constants/app_colors.dart';
import 'package:flutter_app/infrastructure/constants/constants.dart';

class Themes {
  //light theme
  static final light = ThemeData.light().copyWith(
    primaryColor: AppColors.main,
    primaryColorLight: Colors.yellow[400],
    primaryColorDark: Colors.yellow[700],
    iconTheme: const IconThemeData(color: Colors.black54),
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
      color: AppColors.main,
      fontSize: 18,
      fontFamily: Constants.fontFamily,
      fontWeight: FontWeight.w700,
    )),
    bannerTheme: MaterialBannerThemeData(
      backgroundColor: Colors.amber.shade500,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.yellow),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        elevation: 0,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: Constants.fontFamily,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    splashColor: Colors.white,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        color: Color(0xFF4F7296),
        fontSize: 14,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w400,
        height: 0.11,
      ),
      headlineMedium: TextStyle(
        fontFamily: Constants.fontFamily,
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: 15,
        color: AppColors.main,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        color: AppColors.main,
        fontSize: 20,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: AppColors.main,
        fontSize: 16,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: AppColors.main,
        fontSize: 14,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: AppColors.main,
        fontSize: 14,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppColors.main,
        fontSize: 12,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: AppColors.main,
        fontSize: 10,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  //dark theme
  static final dark = ThemeData.dark().copyWith(
    primaryColor: AppColors.main,
    primaryColorDark: Colors.yellow[700],
    secondaryHeaderColor: AppColors.yellow,
    iconTheme: const IconThemeData(color: Colors.white),
    bannerTheme: MaterialBannerThemeData(
      backgroundColor: Colors.amber.shade900.withAlpha(200),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.grey[900],
    ),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[800],
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontFamily: Constants.fontFamily,
          fontWeight: FontWeight.w700,
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        elevation: 0,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: Constants.fontFamily,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.yellow),
    scaffoldBackgroundColor: Colors.grey[800],
    splashColor: Colors.grey[900],
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w400,
        height: 0.11,
      ),
      headlineMedium: TextStyle(
        fontFamily: Constants.fontFamily,
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
