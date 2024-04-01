import 'package:flutter/material.dart';

class TTextTheme {
  TTextTheme._();

  /// Customize Light Text Theme
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Montserrat'),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: 'Montserrat'),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: 'Montserrat'),
    titleLarge: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        fontFamily: 'Montserrat'),
    titleMedium: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
        fontFamily: 'Montserrat'),
    titleSmall: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
        fontFamily: 'Montserrat'),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontFamily: 'Montserrat'),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: 'Montserrat'),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(0.5),
        fontFamily: 'Montserrat'),
    labelLarge: const TextStyle().copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: 'Montserrat'),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: Colors.black.withOpacity(0.5),
        fontFamily: 'Montserrat'),
  );
}
