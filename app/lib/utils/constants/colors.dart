import 'package:flutter/material.dart';

class MyColors {
  MyColors._();
  static const Color appPrimaryColor = Color(0xFF5F728D);
  static const Color appSecondaryColor = Color(0xFF638981);
  static const Color containerColor = Color(0xFF12302E);

  static const Gradient customGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [appPrimaryColor, appSecondaryColor],
    stops: [0.0, 6.0],
  );

  static const Color primaryBtnColor = Color(0xFF5F728D);

  // Text Colors

  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF003F5F);

  // Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF00B453);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);
  static const Color grey = Color(0xFFE0E0E0);
}
