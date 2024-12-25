import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

class SharedAppBarTheme {
  static AppBarTheme main() {
    return AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 87, 87, 87),
      elevation: 0,
      titleTextStyle: TextStyle(
          color: SharedTheme.secondaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold),
    );
  }
}
