import 'package:flutter/material.dart';

@immutable
class CustomLoveTheme extends ThemeExtension<CustomLoveTheme> {
  const CustomLoveTheme({
    this.primaryColor = const Color(0xFFE91E63), // Pink 500
    this.tertiaryColor = const Color(0xFFF06292), // Pink 200
    this.neutralColor = const Color(0xFFFFC0CB), // Pink 100
  });

  final Color primaryColor, tertiaryColor, neutralColor;

  ThemeData toThemeData() {
    return ThemeData(useMaterial3: true);
  }

  @override
  CustomLoveTheme copyWith({
    Color? primaryColor,
    Color? tertiaryColor,
    Color? neutralColor,
  }) =>
      CustomLoveTheme(
          primaryColor: primaryColor ?? this.primaryColor,
          tertiaryColor: tertiaryColor ?? this.tertiaryColor,
          neutralColor: neutralColor ?? this.neutralColor);

  @override
  CustomLoveTheme lerp(
      covariant ThemeExtension<CustomLoveTheme>? other, double t) {
    if (other is! CustomLoveTheme) return this;
    return CustomLoveTheme(
        primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
        tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
        neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!);
  }
}
