import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.validator,
    this.onSaved,
    this.controller,
    this.isObscure = false,
    required this.fontSize,
    required this.fontColor,
    this.hintTextSize = 12,
    this.hintText = '',
    this.fillColor = Colors.black12,
    required this.height,
    required this.width,
    this.keyboardType = TextInputType.text,
    this.maxLength = 200,
    this.showToggleIcon = false,
    this.onToggle,
    this.borderColor = RED_ACCENT,
  });

  final String? Function(String?) validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final bool isObscure;
  final double fontSize;
  final Color fontColor;
  final double height, width;
  final double hintTextSize;
  final String hintText;
  final Color fillColor;
  final TextInputType keyboardType;
  final int maxLength;

  final bool showToggleIcon;
  final VoidCallback? onToggle;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      style: TextStyle(fontSize: fontSize, color: fontColor),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(width, height, width, height),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: Colors.black12,
          fontSize: hintTextSize,
          fontFamily: 'Frutiger',
        ),
        hintText: hintText,
        fillColor: fillColor,

        // 🔥 PASSWORD TOGGLE
        suffixIcon: showToggleIcon
            ? IconButton(
                onPressed: onToggle,
                icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
              )
            : null,
      ),
    );
  }
}
