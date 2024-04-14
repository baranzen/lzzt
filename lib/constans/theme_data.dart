import 'package:flutter/material.dart';
import 'package:lzzt/constans/app_helper.dart';

appThemeData() {
  return ThemeData(
    brightness: Brightness.light,
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
        fontSize: 16,
      ),
    ),
    //! ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppHelper.appColor2),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
  );
}
