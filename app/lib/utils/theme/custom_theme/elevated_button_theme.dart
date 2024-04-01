import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(15)), // Sets border radius
        ),
        foregroundColor: Colors.white,
        backgroundColor: TColors.appPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(15)), // Sets border radius
        ),
        foregroundColor: Colors.white,
        backgroundColor: TColors.appPrimaryColor,
        side: const BorderSide(color: TColors.grey),
        padding: const EdgeInsets.symmetric(vertical: 5),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
  );
}
