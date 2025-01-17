import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextDirection? textDirection;
  final bool? softWrap;
  final double? textScaleFactor;
  final InlineSpan? textSpan;
  final String? semanticsLabel;

  const CustomText(
      this.text, {
        Key? key,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.locale,
        this.strutStyle,
        this.textWidthBasis,
        this.textDirection,
        this.softWrap,
        this.textScaleFactor,
        this.textSpan,
        this.semanticsLabel,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        textStyle: style ?? const TextStyle(),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textDirection: textDirection,
      softWrap: softWrap,
      textScaleFactor: textScaleFactor,
      semanticsLabel: semanticsLabel,
    );
  }
}
