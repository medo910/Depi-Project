import 'package:flutter/widgets.dart';

abstract class AppStyles {
  static const String _fontFamily = 'Montserrat';

  // Helper method للحصول على scale factor بناءً على عرض الشاشة
  static double getResponsiveScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    // Base width للمقارنة (375 للموبايل)
    const baseWidth = 375.0;
    
    // احسب النسبة
    double scale = width / baseWidth;
    
    // حدد الـ scale في نطاق معقول
    if (scale < 0.8) scale = 0.8;
    if (scale > 1.3) scale = 1.3;
    
    return scale;
  }

  // Helper method للحصول على font size responsive
  static double getResponsiveFontSize(BuildContext context, double fontSize) {
    return fontSize * getResponsiveScale(context);
  }

  // 12px - Responsive
  static TextStyle styleRegular12Muted(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 12),
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: const Color(0xFF4B5563),
  );

  static TextStyle styleMedium12Dark(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 12),
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleSemiBold12Red(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 12),
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: const Color(0xFFDC2626),
  );

  // 14px - Responsive
  static TextStyle styleRegular14Muted(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: const Color(0xFF4B5563),
  );

  static TextStyle styleMedium14Dark(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleMedium14Primary(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF80AF81),
  );

  // 16px - Responsive
  static TextStyle styleMedium16Dark(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 16),
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleRegular16Muted(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 16),
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: const Color(0xFF4B5563),
  );

  static TextStyle styleMedium16Green(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 16),
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF16A34A),
  );

  // 18px - Responsive
  static TextStyle styleSemiBold18Dark(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 18),
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleMedium18Muted(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 18),
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF4B5563),
  );

  // 20px - Responsive
  static TextStyle styleSemiBold20Dark(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 20),
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleBold20Primary(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 20),
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    color: const Color(0xFF80AF81),
  );

  // 24px - Responsive
  static TextStyle styleSemiBold24Dark(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 24),
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleBold24Dark(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 24),
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  // 30px - Responsive
  static TextStyle styleBold30Primary(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 30),
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    color: const Color(0xFF80AF81),
  );
}