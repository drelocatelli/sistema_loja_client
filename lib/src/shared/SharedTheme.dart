import 'package:flutter/material.dart';
import 'package:sistema_loja/src/shared/SharedAppBarTheme.dart';
import 'package:sistema_loja/src/shared/SharedIconTheme.dart';

class SharedTheme {
  static Color primaryColor = const Color.fromRGBO(67, 67, 67, 1);
  static Color secondaryColor = const Color.fromRGBO(243, 131, 13, 1);

  static ThemeData? main() {
    return ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
        appBarTheme: SharedAppBarTheme.main(),
        iconTheme: SharedIconTheme.main(),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    foregroundColor: SharedTheme.secondaryColor,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: Colors.transparent)
                .copyWith(
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return increaseBrightness(
                            SharedTheme.secondaryColor, 0.1);
                      }
                      return SharedTheme.secondaryColor;
                    }),
                    animationDuration: const Duration(milliseconds: 70))));
  }

  static Color increaseBrightness(Color color, double amount) {
    // Convert the color to HSL for easier brightness adjustment
    final hsl = HSLColor.fromColor(color);
    final brighterHSL =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return brighterHSL.toColor();
  }
}
