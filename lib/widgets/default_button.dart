import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/theme_helper.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonComponent extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final FocusNode? focusNode;
  final bool isOutlined;
  final bool isDisabled;
  final bool isGrey;
  final Widget? textWidget;
  final Color? buttonColor;
  final bool isLoading;

  const ButtonComponent({
    Key? key,
    this.text,
    this.iconData,
    this.onPressed,
    this.width = 200,
    this.height = 48,
    this.focusNode,
    this.isOutlined = false,
    this.isDisabled = false,
    this.isGrey = false,
    this.textWidget,
    this.buttonColor,
    this.isLoading = false,
  }) : super(key: key);

  ButtonComponent.smallButton({
    Key? key,
    String? text,
    IconData? iconData,
    VoidCallback? onPressed,
    double? width = 200,
    FocusNode? focusNode,
    bool? isDisabled = false,
    bool? isGrey = false,
    Widget? textWidget,
    Color? buttonColor,
    bool isLoading = false,
  }) : this(
    key: key,
    text: text,
    iconData: iconData,
    onPressed: onPressed,
    width: width,
    height: 32,
    focusNode: focusNode,
    isDisabled: isDisabled!,
    textWidget: textWidget,
    isGrey: isGrey!,
    buttonColor: buttonColor,
    isLoading: isLoading,
  );

  ButtonComponent.outlinedButton({
    Key? key,
    String? text,
    IconData? iconData,
    VoidCallback? onPressed,
    double? width = 200,
    double? height = 48,
    FocusNode? focusNode,
    bool? isDisabled = false,
    Widget? textWidget,
    bool? isGrey = false,
    Color? buttonColor,
    bool isLoading = false,
  }) : this(
    key: key,
    text: text,
    iconData: iconData,
    onPressed: onPressed,
    width: width,
    height: height,
    focusNode: focusNode,
    isOutlined: true,
    isDisabled: isDisabled!,
    textWidget: textWidget,
    isGrey: isGrey!,
    buttonColor: buttonColor,
    isLoading: isLoading,
  );

  ButtonComponent.outlinedButtonSmall({
    Key? key,
    String? text,
    IconData? iconData,
    VoidCallback? onPressed,
    double? width = 200,
    FocusNode? focusNode,
    bool isDisabled = false,
    bool? isGrey = false,
    Widget? textWidget,
    Color? buttonColor,
    bool isLoading = false,
  }) : this(
    key: key,
    text: text,
    iconData: iconData,
    onPressed: onPressed,
    width: width,
    height: 32,
    focusNode: focusNode,
    isOutlined: true,
    isDisabled: isDisabled,
    textWidget: textWidget,
    isGrey: isGrey!,
    buttonColor: buttonColor,
    isLoading: isLoading,
  );

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = buttonColor ?? MyColors.primaryColor;

    final ButtonStyle buttonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(GoogleFonts.outfit()),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kInputBorderRadius),
        ),
      ),
      side: isOutlined
          ? MaterialStateProperty.all(BorderSide(color: effectiveColor, width: 1.0))
          : null,
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 6)),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return MyColors.disabledButtonBckColor;
          }
          if (isOutlined) {
            return Colors.transparent;
          }
          if (isGrey) {
            return MyColors.greyButtonBckColor;
          }
          return effectiveColor;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return MyColors.disabledButtonForegroundColor;
          }
          if (isOutlined) {
            return effectiveColor;
          }
          return Colors.white;
        },
      ),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    );

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: SizedBox(
        height: height,
        width: width,
        child: isOutlined
            ? OutlinedButton(
          focusNode: focusNode,
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: buttonStyle,
          child: buildButtonChild(effectiveColor),
        )
            : ElevatedButton(
          focusNode: focusNode,
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: buttonStyle,
          child: buildButtonChild(Colors.white),
        ),
      ),
    );
  }

  Widget buildButtonChild(Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (iconData != null) Icon(iconData, size: 16, color: textColor),
        if (iconData != null && text != null) const HorizontalSpacer(8),
        if (text != null && textWidget == null)
          CustomText(
            text!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor),
          ),
        if (textWidget != null) textWidget!,
      ],
    );
  }
}
