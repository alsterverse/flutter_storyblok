import 'package:example/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextATV extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextAlign? textAlign;

  TextATV.title(
    this.text, {
    super.key,
    this.overflow,
    this.softWrap = true,
    this.textAlign,
  }) : style = headingStyle;

  TextATV.hero(
    this.text, {
    super.key,
    this.overflow,
    this.softWrap,
    this.textAlign,
  }) : style = headingStyle.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        );

  TextATV.subtitle(
    this.text, {
    super.key,
    this.overflow,
    this.softWrap,
    this.textAlign,
  }) : style = headingStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        );

  TextATV.body(
    this.text, {
    super.key,
    Color color = AppColors.white,
    this.overflow,
    this.softWrap,
    this.textAlign,
  }) : style = bodyStyle.copyWith(color: color);

  TextATV.button(
    this.text, {
    super.key,
    Color color = AppColors.white,
    this.overflow,
    this.softWrap,
    this.textAlign,
  }) : style = buttonStyle.copyWith(color: color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: style,
      softWrap: softWrap,
    );
  }
}

TextStyle headingStyle = TextStyle(
    fontSize: 24,
    letterSpacing: 0.9,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    height: 1.2,
    fontFamily: GoogleFonts.montserrat().fontFamily);

TextStyle bodyStyle = TextStyle(
  fontSize: 16,
  height: 1.45,
  fontFamily: GoogleFonts.openSans().fontFamily,
);

TextStyle buttonStyle = TextStyle(
  fontFamily: GoogleFonts.montserrat().fontFamily,
  fontSize: 14,
  fontWeight: FontWeight.w900,
  color: AppColors.white,
  letterSpacing: 0.8,
  height: 1.3,
);
