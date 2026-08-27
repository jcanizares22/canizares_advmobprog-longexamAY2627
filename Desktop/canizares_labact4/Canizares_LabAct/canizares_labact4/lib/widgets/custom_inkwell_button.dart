import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/custom_font.dart';

// ignore: must_be_immutable
class CustomInkwellButton extends StatelessWidget {
  final VoidCallback onTap;
  final double height;
  final double width;
  final double fontSize;
  final String buttonName;
  final Icon? icon;
  final FontWeight fontWeight;
  final Color bgColor;
  final Color fontColor;

  const CustomInkwellButton({
    super.key,
    required this.onTap,
    required this.height,
    required this.width,
    this.buttonName = '',
    this.bgColor = RED_ACCENT,
    this.fontColor = Colors.white,
    this.fontSize = 14,
    this.icon,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: FB_SECONDARY,
        child: SizedBox(
          height: height,
          width: width,
          child: Center(
            child: buttonName.isEmpty
                ? (icon ?? const SizedBox())
                : CustomFont(
                    text: buttonName,
                    fontSize: fontSize,
                    color: fontColor,
                    fontWeight: fontWeight,
                  ),
          ),
        ),
      ),
    );
  }
}
