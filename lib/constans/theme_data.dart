import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lzzt/constans/app_helper.dart';

appThemeDataLight() {
  return ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppHelper.appColor1,
      secondary: AppHelper.appColor1,
    ),
    //! inputDecorationTheme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        gapPadding: 5,
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppHelper.appColor1,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        gapPadding: 5,
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: HexColor('#F3F5F7'),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        gapPadding: 5,
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppHelper.appColor1,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        gapPadding: 5,
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppHelper.appColor1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  );
}

ThemeData appThemeDataDark() {
  return ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppHelper.appColor1,
      secondary: AppHelper.appColor1,
    ),
    //! inputDecorationTheme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppHelper.appColor1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  );
}
