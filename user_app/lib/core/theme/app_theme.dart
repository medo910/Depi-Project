import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

// Extension عشان تستخدم الـ responsive styles بسهولة
extension ResponsiveTextTheme on BuildContext {
  TextStyle get displayLarge => AppStyles.styleBold30Primary(this);
  TextStyle get displayMedium => AppStyles.styleBold24Dark(this);
  TextStyle get displaySmall => AppStyles.styleSemiBold24Dark(this);

  TextStyle get headlineLarge => AppStyles.styleBold20Primary(this);
  TextStyle get headlineMedium => AppStyles.styleSemiBold20Dark(this);
  TextStyle get headlineSmall => AppStyles.styleSemiBold18Dark(this);

  TextStyle get titleLarge => AppStyles.styleMedium18Muted(this);
  TextStyle get titleMedium => AppStyles.styleMedium16Dark(this);
  TextStyle get titleSmall => AppStyles.styleMedium16Green(this);

  TextStyle get bodyLarge => AppStyles.styleMedium16Dark(this);
  TextStyle get bodyMedium => AppStyles.styleRegular16Muted(this);
  TextStyle get bodySmall => AppStyles.styleMedium14Dark(this);

  TextStyle get labelLarge => AppStyles.styleMedium14Primary(this);
  TextStyle get labelMedium => AppStyles.styleMedium12Dark(this);
  TextStyle get labelSmall => AppStyles.styleRegular12Muted(this);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFD6EFD8),
    primaryColor: const Color(0xFF80AF81),
    hintColor: const Color(0xFF508D4E),
    canvasColor: const Color(0xFF80AF81),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    cardColor: Colors.white,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF80AF81);
        }
        return const Color(0xFFCBCED4);
      }),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    fontFamily: 'Montserrat',
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    primaryColor: const Color(0xFF508D4E),
    hintColor: const Color(0xFF508D4E),
    canvasColor: const Color(0xFF2D2D2D),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2D2D2D),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF2D2D2D),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF508D4E);
        }
        return Colors.grey;
      }),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}

// استخدام الـ Dark Theme Styles
extension DarkResponsiveTextTheme on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // يرجع الـ style المناسب حسب الـ theme
  TextStyle getThemeStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color lightColor,
    required Color darkColor,
  }) {
    final isDark = isDarkMode;
    final scaledSize = AppStyles.getResponsiveFontSize(this, fontSize);

    return TextStyle(
      fontSize: scaledSize,
      fontWeight: fontWeight,
      fontFamily: 'Montserrat',
      color: isDark ? darkColor : lightColor,
    );
  }
}
