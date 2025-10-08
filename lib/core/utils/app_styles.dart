import 'package:flutter/widgets.dart';

abstract class AppStyles {
  static const String _fontFamily = 'Montserrat';

  // 12px
  static const TextStyle styleRegular12Muted = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: Color(0xFF4B5563), // muted
  );

  static const TextStyle styleMedium12Dark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: Color(0xFF1A1A1A), // foreground
  );

  static const TextStyle styleSemiBold12Red = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: Color(0xFFDC2626), // destructive
  );

  // 14px
  static const TextStyle styleRegular14Muted = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: Color(0xFF4B5563), // muted
  );

  static const TextStyle styleMedium14Dark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: Color(0xFF1A1A1A), // foreground
  );

  static const TextStyle styleMedium14Primary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: Color(0xFF80AF81), // primary
  );

  // 16px
  static const TextStyle styleMedium16Dark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: Color(0xFF1A1A1A), // foreground
  );

  static const TextStyle styleRegular16Muted = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: Color(0xFF4B5563), // muted
  );

  static const TextStyle styleMedium16Green = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: Color(0xFF16A34A), // success
  );

  // 18px
  static const TextStyle styleSemiBold18Dark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: Color(0xFF1A1A1A), // foreground
  );

  static const TextStyle styleMedium18Muted = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: Color(0xFF4B5563), // muted
  );

  // 20px
  static const TextStyle styleSemiBold20Dark = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: Color(0xFF1A1A1A), // foreground
  );

  static const TextStyle styleBold20Primary = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    color: Color(0xFF80AF81), // primary
  );

  // 24px
  static const TextStyle styleSemiBold24Dark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle styleBold24Dark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    color: Color(0xFF1A1A1A),
  );

  // 30px
  static const TextStyle styleBold30Primary = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    color: Color(0xFF80AF81),
  );
}
