import 'dart:ui';
import 'package:flutter/material.dart';

@immutable
class CustomLoveTheme extends ThemeExtension<CustomLoveTheme> {
  const CustomLoveTheme({
    this.primaryColor = const Color(0xFFE91E63), // Pink 500
    this.tertiaryColor = const Color(0xFFF06292), // Pink 200
    this.neutralColor = const Color(0xFFFFC0CB), // Pink 100
    this.grayscale1 = const Color(0xffbdbdbd),
    this.grayscale2 = const Color(0xff757575),
    this.whiteColor = Colors.white,
    this.textColor = const Color(0xFF000000), // Black
    this.neutralBackgroundColor = const Color(0xFFFFFFFF),
    this.inputWidth = 327,
    this.inputHeight = 56,
    this.textFieldDecoration,
    this.buttonStyle,
    this.defaultButtonTextStyle = const TextStyle(fontSize: 18),
  });


  final Color primaryColor, tertiaryColor, neutralColor, grayscale1, grayscale2, whiteColor, textColor, neutralBackgroundColor;
  final double inputWidth, inputHeight;
  final InputDecoration? textFieldDecoration;
  final ButtonStyle? buttonStyle;
  final TextStyle defaultButtonTextStyle;
  final double universalPadding = 8;

  ThemeData toThemeData() {
    return ThemeData(useMaterial3: true);
  }

  @override
  CustomLoveTheme copyWith({
    Color? primaryColor,
    Color? tertiaryColor,
    Color? neutralColor,
    Color? grayscale1,
    Color? grayscale2,
    Color? whiteColor,
    Color? textColor,
    Color? neutralBackgroundColor,
    double? inputWidth,
    double? inputHeight,
    InputDecoration? textFieldDecoration,
    ButtonStyle? buttonStyle,
    TextStyle? defaultButtonTextStyle,
  }) =>
      CustomLoveTheme(
        primaryColor: primaryColor ?? this.primaryColor,
        tertiaryColor: tertiaryColor ?? this.tertiaryColor,
        neutralColor: neutralColor ?? this.neutralColor,
        grayscale1: grayscale1 ?? this.grayscale1,
        grayscale2: grayscale2 ?? this.grayscale2,
        whiteColor: whiteColor ?? this.whiteColor,
        textColor: textColor ?? this.textColor,
        neutralBackgroundColor: neutralBackgroundColor ?? this.neutralBackgroundColor,
        inputWidth: inputWidth ?? this.inputWidth,
        inputHeight: inputHeight ?? this.inputHeight,
        textFieldDecoration: textFieldDecoration ?? this.textFieldDecoration,
        buttonStyle: buttonStyle ?? this.buttonStyle,
        defaultButtonTextStyle:
            defaultButtonTextStyle ?? this.defaultButtonTextStyle,
      );

  @override
  CustomLoveTheme lerp(
      covariant ThemeExtension<CustomLoveTheme>? other, double t) {
    if (other is! CustomLoveTheme) return this;
    return CustomLoveTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
      neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!,
      grayscale1: Color.lerp(grayscale1, other.grayscale1, t)!,
      grayscale2: Color.lerp(grayscale2, other.grayscale2, t)!,
      whiteColor: Color.lerp(whiteColor, other.whiteColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      neutralBackgroundColor: Color.lerp(neutralBackgroundColor, other.neutralBackgroundColor, t)!,
      inputWidth: lerpDouble(inputWidth, other.inputWidth, t)!,
      inputHeight: lerpDouble(inputHeight, other.inputHeight, t)!,
      textFieldDecoration: other.textFieldDecoration ?? textFieldDecoration,
      buttonStyle: ButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
      defaultButtonTextStyle: TextStyle.lerp(
              defaultButtonTextStyle, other.defaultButtonTextStyle, t) ??
          defaultButtonTextStyle,
    );
  }
}
