import 'package:flutter/material.dart';
import 'custom_theme/text_field_theme.dart';
import 'custom_theme/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );
}
