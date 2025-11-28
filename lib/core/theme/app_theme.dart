import 'package:flutter/material.dart';

import '../utils/app_styles.dart';

const String _fontFamily= 'Montserrat';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFD6EFD8),
    primaryColor: const Color(0xFF80AF81), // selected(dark) buttons, green text , user profile no photo
    hintColor:  Color(0xFF508D4E),
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
    textTheme: const  TextTheme(
    // Display (الأكبر في الشاشة)
    displayLarge: AppStyles.styleBold30Primary,   // 30px، رئيسي
    displayMedium: AppStyles.styleBold24Dark,     // 24px، عناوين كبيرة
    displaySmall: AppStyles.styleSemiBold24Dark,  // 24px، نسخة أخف

    // Headline (عناوين فرعية)
    headlineLarge: AppStyles.styleBold20Primary,  // 20px، رئيسي
    headlineMedium: AppStyles.styleSemiBold20Dark, // 20px، أسود
    headlineSmall: AppStyles.styleSemiBold18Dark, // 18px

    // Title (عناوين أصغر)
    titleLarge: AppStyles.styleMedium18Muted,     // 18px، رمادي
    titleMedium: AppStyles.styleMedium16Dark,     // 16px
    titleSmall: AppStyles.styleMedium16Green,     // 16px أخضر

    // Body (النصوص العادية)
    bodyLarge: AppStyles.styleMedium16Dark,       // 16px
    bodyMedium: AppStyles.styleRegular16Muted,    // 16px رمادي
    bodySmall: AppStyles.styleMedium14Dark,       // 14px

    // Label (التسميات الصغيرة، أزرار ...)
    labelLarge: AppStyles.styleMedium14Primary,   // 14px أخضر
    labelMedium: AppStyles.styleMedium12Dark,     // 12px
    labelSmall: AppStyles.styleRegular12Muted,    // 12px رمادي
  ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: Color(0xFF1E1E1E),
    primaryColor: Color(0xFF508D4E),
    hintColor:  Color(0xFF508D4E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2D2D2D),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    // cardColor: Colors.white12 ,
    cardColor: Color(0xFF2D2D2D),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Color(0xFF508D4E);
        }
        return Colors.grey;
      }),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(

      // Display (الأكبر في الشاشة)
      displayLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        fontFamily: _fontFamily,
        color: Color(0xFFFFFFFF), // أبيض على دارك
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        fontFamily: _fontFamily,
        color: Color(0xFFFFFFFF),
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: _fontFamily,
        color: Color(0xFFE5E5E5), // أبيض فاتح شوي
      ),

      // Headline (عناوين فرعية)
      headlineLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontFamily: _fontFamily,
        color: Color(0xFF80AF81), // أخضر ثابت
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: _fontFamily,
        color: Color(0xFFFFFFFF),
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: _fontFamily,
        color: Color(0xFFE5E5E5),
      ),

      // Title (عناوين أصغر)
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        fontFamily: _fontFamily,
        color: Color(0xFFD1D5DB), // رمادي فاتح
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: _fontFamily,
        color: Color(0xFFFFFFFF),
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: _fontFamily,
        color: Color(0xFF16A34A), // أخضر ثابت
      ),

      // Body (النصوص العادية)
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: _fontFamily,
        color: Color(0xFFFFFFFF),
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: _fontFamily,
        color: Color(0xFFD1D5DB),
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: _fontFamily,
        color: Color(0xFFFFFFFF),
      ),

      // Label (التسميات الصغيرة، أزرار ...)
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: _fontFamily,
        color: Color(0xFF80AF81), // أخضر
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: _fontFamily,
        color: Color(0xFFFFFFFF),
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: _fontFamily,
        color: Color(0xFFD1D5DB),
      ),
    ),
  );
}
