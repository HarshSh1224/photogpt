import 'package:flutter/material.dart';

class TextDisplay extends StatelessWidget {
  const TextDisplay(
      {required this.text,
      this.textColor,
      this.fontSize,
      this.fontFamily,
      this.fontWeight,
      this.textAlign,
      this.letterSpacing,
      super.key});

  final String text;
  final Color? textColor;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
