import 'package:flutter/material.dart';
import 'package:frontend/Utils/dimentions.dart';
import 'package:frontend/Widgets/Small_texts.dart';

class IconAndText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  const IconAndText(
      {super.key,
      required this.icon,
      required this.text,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: Dimensions.height10,
        ),
        SizedBox(
          width: Dimensions.height5,
        ),
        SmallText(
          text: text,
        )
      ],
    );
  }
}
