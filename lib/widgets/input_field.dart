import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatefulWidget {
  final String? labelText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final Function(String?) onChanged;
  final bool? obscureText;
  final TextEditingController? controller;
  final String? Function(String? value)? validatorFunction;
  final bool buildFloatingInput;
  final int? maxLines;
  final double? borderRadius;
  final bool? alignLabelWithHint;
  final String? hintText;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? textInputFormatters;
  final bool? enabled;
  final int? maxLength;
  final bool? isSmallInputField;
  final double? width;
  final AutovalidateMode? autovalidateMode;
  final Widget? suffixIcon;
  final bool? autofocus;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final bool? removeErrorMessage;
  final Color? fillColor;
  final bool? filled;
  final bool? hideCounter;
  final bool? floatingLabelTextHidden;

  const InputField({
    Key? key,
    this.labelText,
    this.initialValue,
    this.keyboardType,
    required this.onChanged,
    this.obscureText,
    this.controller,
    this.validatorFunction,
    this.buildFloatingInput = true,
    this.maxLines = 1,
    this.borderRadius = 50.0,
    this.alignLabelWithHint = false,
    this.hintText,
    this.textAlign,
    this.textInputFormatters,
    this.maxLength,
    this.enabled,
    this.isSmallInputField = false,
    this.width,
    this.autovalidateMode,
    this.suffixIcon,
    this.autofocus = false,
    this.focusNode,
    this.onFieldSubmitted,
    this.removeErrorMessage = false,
    this.filled,
    this.fillColor,
    this.hideCounter = false,
    this.floatingLabelTextHidden = false,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;
  late bool showCounter;
  late int textLength;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    showCounter = widget.maxLength != null && !widget.hideCounter!;
    textLength = widget.controller?.text.length ?? 0;
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget customCounterWidget = showCounter
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CustomText(
                '$textLength/${widget.maxLength}',
                style: TextStyle(fontSize: 12, height: 1, color: Colors.black.withOpacity(0.5)),
              ),
            ],
          )
        : const SizedBox.shrink();

    if (widget.isSmallInputField!) {
      return buildSmallInputField(context, customCounterWidget);
    } else {
      return buildLargeInputField(context);
    }
  }

  SizedBox buildLargeInputField(BuildContext context) {
    return SizedBox(
      width: widget.width ?? null,
      child: TextFormField(
        onTap: _requestFocus,
        focusNode: _focusNode,
        autofocus: widget.autofocus!,
        maxLength: widget.maxLength,
        enabled: widget.enabled,
        textAlign: (widget.textAlign != null) ? widget.textAlign! : TextAlign.start,
        style: GoogleFonts.outfit(),
        controller: widget.controller,
        initialValue: widget.initialValue,
        autovalidateMode: widget.autovalidateMode,
        onChanged: (String? value) {
          widget.onChanged(value);
        },
        inputFormatters: widget.textInputFormatters,
        decoration: widget.buildFloatingInput ? buildFloatingInputDecoration(context) : buildInputDecoration(context),
        onSaved: (String? v) => <void>{},
        keyboardType: widget.keyboardType ?? TextInputType.text,
        validator: widget.validatorFunction != null
            ? widget.validatorFunction
            : (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please input value';
                }
                return null;
              },
        obscureText: widget.obscureText ?? false,
        maxLines: widget.maxLines,
      ),
    );
  }

  SizedBox buildSmallInputField(BuildContext context, Widget counterWidget) {
    return SizedBox(
      width: widget.width ?? 350,
      child: Theme(
        data: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: MyColors.onPrimaryColor,
                onSurface: Colors.black,
              ),
          canvasColor: Colors.white,
        ),
        child: TextFormField(
          inputFormatters: widget.textInputFormatters,
          controller: widget.controller,
          initialValue: widget.initialValue,
          style: GoogleFonts.outfit(),
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          autovalidateMode: widget.autovalidateMode,
          autofocus: widget.autofocus!,
          enabled: widget.enabled,
          decoration: buildSmallInputFloatingDecoration(widget.buildFloatingInput, counterWidget),
          onChanged: (String? value) {
            widget.onChanged(value);
          },
          onFieldSubmitted: (String text) {
            if (widget.onFieldSubmitted != null) {
              widget.onFieldSubmitted!(text);
            } else {
              if (text.isNotEmpty) {
                FocusScope.of(context).requestFocus(_focusNode);
              }
            }
          },
          obscureText: widget.obscureText ?? false,
          validator: widget.validatorFunction != null
              ? widget.validatorFunction
              : (String? value) {
                  if (value == null || value.isEmpty) {
                    return widget.removeErrorMessage == true ? '' : 'Please input value';
                  }
                  return null;
                },
        ),
      ),
    );
  }

  InputDecoration buildSmallInputFloatingDecoration(bool isFloating, Widget counterWidget) {
    return InputDecoration(
        fillColor: widget.fillColor,
        filled: widget.filled,
        hintText: widget.hintText,
        counterStyle: GoogleFonts.outfit(),
        suffixStyle: GoogleFonts.outfit(),
        helperStyle: GoogleFonts.outfit(),
        prefixStyle: GoogleFonts.outfit(),
        hintStyle: GoogleFonts.outfit(),
        contentPadding: widget.alignLabelWithHint!
            ? const EdgeInsets.symmetric(horizontal: 26, vertical: 18)
            : const EdgeInsets.fromLTRB(16, 8, 16, 8),
        labelText: (widget.floatingLabelTextHidden!)
            ? (_focusNode.hasFocus || (widget.controller != null && widget.controller!.text.isNotEmpty)
                ? null
                : widget.labelText)
            : widget.labelText,
        floatingLabelStyle: GoogleFonts.outfit(),
        labelStyle: GoogleFonts.outfit(),
        floatingLabelBehavior:
            (widget.floatingLabelTextHidden!) ? FloatingLabelBehavior.never : FloatingLabelBehavior.auto,
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: widget.removeErrorMessage == true ? const TextStyle(fontSize: 0, height: 0) : null,
        counter: counterWidget);
  }

  InputDecoration buildFloatingInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: GoogleFonts.outfit(),
      counterStyle: GoogleFonts.outfit(),
      suffixStyle: GoogleFonts.outfit(),
      helperStyle: GoogleFonts.outfit(),
      prefixStyle: GoogleFonts.outfit(),
      alignLabelWithHint: widget.alignLabelWithHint,
      labelText: widget.labelText,
      errorStyle: GoogleFonts.outfit(),
      labelStyle: GoogleFonts.outfit(
        textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: _focusNode.hasFocus ? Colors.black : Colors.black.withOpacity(0.5), fontWeight: FontWeight.w400),
      ),
      floatingLabelStyle: GoogleFonts.outfit(),
      filled: true,
      isDense: true,
      suffixIcon: widget.suffixIcon,
      fillColor: widget.enabled != null && widget.enabled == false ? Colors.grey.withOpacity(0.2) : Colors.white,
      border: buildFloatingInputBorder(),
      enabledBorder: buildFloatingInputBorder(),
      focusedBorder: buildFloatingInputBorder(),
      disabledBorder: buildFloatingInputBorder(),
      contentPadding: const EdgeInsets.fromLTRB(26, 18, 26, 18),
    );
  }

  OutlineInputBorder buildFloatingInputBorder() {
    return OutlineInputBorder(
        borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(this.widget.borderRadius!));
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      labelStyle: GoogleFonts.outfit(
        textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: _focusNode.hasFocus ? Colors.black : Colors.black.withOpacity(0.5), fontWeight: FontWeight.w500),
      ),
      hintText: widget.hintText,
      labelText: widget.labelText,
      hintStyle: GoogleFonts.outfit(),
      counterStyle: GoogleFonts.outfit(),
      suffixStyle: GoogleFonts.outfit(),
      helperStyle: GoogleFonts.outfit(),
      prefixStyle: GoogleFonts.outfit(),
      floatingLabelStyle: GoogleFonts.outfit(),
      errorStyle: GoogleFonts.outfit(),
      filled: true,
      isDense: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: buildUnderlineInputBorder(),
      focusedBorder: buildUnderlineInputBorder(),
      contentPadding: const EdgeInsets.fromLTRB(26, 8, 26, 8),
    );
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  UnderlineInputBorder buildUnderlineInputBorder() {
    return UnderlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ));
  }
}
