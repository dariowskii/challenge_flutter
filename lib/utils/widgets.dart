import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final Color? textColor;
  final Color? backgroundColor;

  const CustomButton({
    Key? key,
    this.onPressed,
    required this.text,
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final curentThemeData = Theme.of(context);
    return MaterialButton(
      onPressed: onPressed,
      minWidth: curentThemeData.buttonTheme.minWidth,
      elevation: 0,
      color: backgroundColor,
      disabledColor: curentThemeData.disabledColor,
      child: Text(
        text,
        style: kFont16Bold.copyWith(color: textColor),
      ),
    );
  }
}
