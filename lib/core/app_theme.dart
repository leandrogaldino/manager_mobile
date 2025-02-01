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
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFAB40), // Laranja vibrante no tema escuro
      surfaceTint: Color(0xFFFFAB40),
      onPrimary: Color(0xFF4E342E), // Marrom para contraste
      primaryContainer: Color(0xFF4E342E), // Fundo marrom escuro
      onPrimaryContainer: Color(0xFFFFD180),
      secondary: Color(0xFFFFCC80),
      onSecondary: Color(0xFF4E342E),
      secondaryContainer: Color(0xFF5D4037),
      onSecondaryContainer: Color(0xFFFFAB40),
      tertiary: Color(0xFFFFD180),
      onTertiary: Color(0xFF4E342E),
      tertiaryContainer: Color(0xFF5D4037),
      onTertiaryContainer: Color(0xFFFFCC80),
      error: Color(0xFFFF6F00),
      onError: Color(0xFFFFD180),
      errorContainer: Color(0xFF5D4037),
      onErrorContainer: Color(0xFFFFCC80),
      surface: Color(0xFF121212),
      onSurface: Color(0xFFFFAB91),
      onSurfaceVariant: Color(0xFFFFCC80),
      outline: Color(0xFFFFAB91),
      outlineVariant: Color(0xFFFFD180),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFFFAB40),
      inversePrimary: Color(0xFF4E342E),
      primaryFixed: Color(0xFF5D4037),
      onPrimaryFixed: Color(0xFFFFD180),
      primaryFixedDim: Color(0xFFFFAB40),
      onPrimaryFixedVariant: Color(0xFFFFCC80),
      secondaryFixed: Color(0xFF4E342E),
      onSecondaryFixed: Color(0xFFFFCC80),
      secondaryFixedDim: Color(0xFFFFAB40),
      onSecondaryFixedVariant: Color(0xFFFFD180),
      tertiaryFixed: Color(0xFF5D4037),
      onTertiaryFixed: Color(0xFFFFD180),
      tertiaryFixedDim: Color(0xFFFFAB40),
      onTertiaryFixedVariant: Color(0xFFFFCC80),
      surfaceDim: Color(0xFF4E342E),
      surfaceBright: Color(0xFF121212),
      surfaceContainerLowest: Color(0xFF1E1E1E),
      surfaceContainerLow: Color(0xFF2C2C2C),
      surfaceContainer: Color(0xFF3A3A3A),
      surfaceContainerHigh: Color(0xFF4E4E4E),
      surfaceContainerHighest: Color(0xFF5D5D5D),
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
