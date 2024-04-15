import 'package:flutter/material.dart';
import 'package:lzzt/constans/app_helper.dart';

appThemeDataLight() {
  return ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: AppHelper.appColor1,
    primaryColorDark: AppHelper.appColor1,
    primaryColorLight: AppHelper.appColor1,

    useMaterial3: true,
    //! inputDecorationTheme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      labelStyle: TextStyle(
        color: AppHelper.appColor1,
        fontSize: 17,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppHelper.appColor2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
    //! ElevatedButton
  );
}

appThemeDataDark() {
  return ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    //! inputDecorationTheme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      labelStyle: const TextStyle(
        fontSize: 17,
      ),
    ),
    //! ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppHelper.appColor2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  );
}
