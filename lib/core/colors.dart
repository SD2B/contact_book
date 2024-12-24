import 'package:flutter/material.dart';

class ColorList {
  final Color? primary;
  final Color? secondary;
  final Color? middlePrimary;
  final Color? middleSecondary;
  final Color? labelColor;
  final Color? success;
  final Color? error;
  final Color? borderColor;
  final Color? ratingColor;
  final Color? customTextColor;
  final Color? bgColor;

  ColorList({this.primary, this.secondary, this.middlePrimary, this.middleSecondary, this.labelColor, this.success, this.error, this.borderColor, this.ratingColor, this.customTextColor, this.bgColor});

  factory ColorList.light() {
    return ColorList(
      primary: const Color(0xFF090c9b),
      secondary: const Color(0xFFfbfff1),
      middlePrimary: const Color(0xFF3066be),
      middleSecondary: const Color(0xFFb4c5e4),
      labelColor: const Color(0xFF6C7584),
      borderColor: const Color(0xFFE5E8EC),
      success: const Color(0xFF007C5A),
      error: Colors.red[900],
      ratingColor: const Color(0xFFF0A500),
      customTextColor: const Color(0xFF1D2F47),
      bgColor: const Color(0xFFbae5f5),
    );
  }

  factory ColorList.dark() {
    return ColorList(
      primary: const Color(0xFFbae5f5),
      secondary: const Color(0xFFE83D3D),
      middlePrimary: const Color(0xFF3066be),
      middleSecondary: const Color(0xFFb4c5e4),
      labelColor: const Color(0xFF6C7584),
      borderColor: const Color(0xFFE5E8EC),
      success: const Color(0xFF007C5A),
      error: Colors.red[900],
      ratingColor: const Color(0xFFF0A500),
      customTextColor: const Color(0xFF1D2F47),
      bgColor: const Color(0xFFbae5f5),
    );
  }
}

class ColorCode {
  static ColorList colorList(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? ColorList.light() : ColorList.dark();
  }
}
