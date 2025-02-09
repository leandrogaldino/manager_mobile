import "package:flutter/material.dart";

class AppTheme {
  final TextTheme textTheme;

  const AppTheme(this.textTheme);

  static OutlineInputBorder getBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color),
    );
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        inputDecorationTheme: InputDecorationTheme(
          disabledBorder: getBorder(colorScheme.outline),
          filled: true,
          labelStyle: textTheme.labelLarge,
          floatingLabelStyle: textTheme.labelLarge,
          enabledBorder: getBorder(colorScheme.outline),
          focusedBorder: getBorder(colorScheme.primary),
          errorBorder: getBorder(colorScheme.error),
          focusedErrorBorder: getBorder(colorScheme.error),
          contentPadding: EdgeInsets.all(12.0),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: SegmentedButton.styleFrom(
            foregroundColor: colorScheme.onSurface,
            backgroundColor: colorScheme.surface,
            side: const BorderSide(style: BorderStyle.none),
            selectedForegroundColor: colorScheme.primary,
            textStyle: textTheme.titleMedium,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: colorScheme.onPrimary,
            backgroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.primary,
            side: BorderSide(color: colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      );

  static ColorScheme lightScheme() {
    return ColorScheme(
      brightness: Brightness.light,
      primary: const Color.fromARGB(255, 250, 165, 55),
      secondary: const Color.fromARGB(255, 255, 180, 80),
      surface: const Color.fromARGB(255, 255, 255, 255),
      error: const Color.fromARGB(255, 244, 65, 55),
      onPrimary: const Color.fromARGB(255, 255, 255, 255),
      onSecondary: const Color.fromRGBO(33, 150, 243, 1),
      onSurface: const Color.fromRGBO(33, 150, 243, 1),
      onError: const Color.fromARGB(255, 255, 255, 255),
      primaryContainer: const Color.fromARGB(255, 250, 250, 255),
      secondaryContainer: const Color.fromARGB(255, 255, 240, 215),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: const Color.fromARGB(255, 255, 170, 65),
      secondary: const Color.fromARGB(255, 255, 210, 130),
      surface: const Color.fromARGB(255, 25, 25, 25),
      error: const Color.fromARGB(255, 255, 110, 0),
      onPrimary: const Color.fromARGB(255, 35, 35, 35),
      onSecondary: const Color.fromARGB(255, 35, 35, 35),
      onSurface: const Color.fromARGB(255, 255, 255, 255),
      onError: const Color.fromARGB(255, 255, 210, 130),
      primaryContainer: const Color.fromARGB(255, 245, 245, 245),
      secondaryContainer: const Color.fromARGB(255, 40, 40, 4),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static const TextTheme appTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w900,
      fontSize: 57.0,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w900,
      fontSize: 45.0,
      letterSpacing: 0.0,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w700,
      fontSize: 36.0,
      letterSpacing: 0.25,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w700,
      fontSize: 32.0,
      letterSpacing: 0.0,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w600,
      fontSize: 28.0,
      letterSpacing: 0.0,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w600,
      fontSize: 24.0,
      letterSpacing: 0.0,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w600,
      fontSize: 22.0,
      letterSpacing: 0.0,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
      letterSpacing: 0.0,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w500,
      fontSize: 18.0,
      letterSpacing: 0.0,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w400,
      fontSize: 12.0,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w500,
      fontSize: 12.0,
      letterSpacing: 0.1,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w500,
      fontSize: 10.0,
      letterSpacing: 0.1,
    ),
  );
}
