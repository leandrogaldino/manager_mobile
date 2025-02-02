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
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: textTheme.bodyMedium),
        ),
      );

  static ColorScheme lightScheme() {
    return ColorScheme(
      brightness: Brightness.light,
      primary: Colors.orange,
      secondary: Colors.orangeAccent,
      surface: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.blue,
      onSurface: Colors.blue,
      onError: Colors.white,
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFFFAB40), // Laranja bem claro
      secondary: const Color(0xFFFFCC80), // Laranja suave
      surface: const Color(0xFF1A1A1A), // Cinza bem escuro
      error: const Color(0xFFFF6F00), // Laranja escuro para erros
      onPrimary: const Color(0xFF212121), // Escuro, para contraste com o laranja claro
      onSecondary: const Color(0xFF212121), // Escuro, para contraste com o laranja suave
      onSurface: const Color(0xFFE0E0E0), // Texto branco suave no fundo escuro
      onError: const Color(0xFFFFD180), // Laranja claro para textos de erro
      outline: const Color(0xFFBDBDBD), // Contornos de uma cor suave
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
