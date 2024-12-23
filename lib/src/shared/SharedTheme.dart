import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/shared/SharedAppBarTheme.dart';
import 'package:racoon_tech_panel/src/shared/SharedIconTheme.dart';

class SharedTheme {
  static Color primaryColor = const Color.fromRGBO(67, 67, 67, 1);
  static Color secondaryColor = const Color.fromRGBO(243, 131, 13, 1);
  static Color thirdColor = const Color.fromRGBO(197, 197, 197, 1);

  static ThemeData? main() {
    return ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
        textTheme: TextTheme(
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        ),
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
                  animationDuration: const Duration(milliseconds: 70))),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              elevation: WidgetStatePropertyAll(0),
              padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
              backgroundColor: WidgetStatePropertyAll(secondaryColor),
            ),
          ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.all(4)),
            ),
          ),

          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
               side: BorderSide(
                  width: 1.2, // Set the thickness of the border
                  color: secondaryColor
                ),
              foregroundColor: (secondaryColor),
              backgroundColor: (Color.fromRGBO(252, 247, 240, 1 ))
            ),
          ),

          checkboxTheme: CheckboxThemeData(
            checkColor: WidgetStatePropertyAll(Colors.white),
            fillColor: WidgetStatePropertyAll(secondaryColor),
            overlayColor: WidgetStatePropertyAll(Colors.white),
          )
        );
  }

  static Color increaseBrightness(Color color, double amount) {
    // Convert the color to HSL for easier brightness adjustment
    final hsl = HSLColor.fromColor(color);
    final brighterHSL =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return brighterHSL.toColor();
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800;
  }

}
