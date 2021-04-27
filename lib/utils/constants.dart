import 'package:flutter/material.dart';

// Colors
const MaterialAccentColor kPrimaryColor = Colors.orangeAccent;

// App Theme
ThemeData kAppTheme = ThemeData(
  primaryColor: kPrimaryColor,
  appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme:
          TextTheme(headline6: kFont16Bold.copyWith(color: Colors.white))),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: kPrimaryColor),
  disabledColor: Colors.grey,
  buttonTheme: const ButtonThemeData(
    minWidth: double.maxFinite,
    padding: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  ),
);

// Text Styles
const TextStyle kFont14Bold =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
const TextStyle kFont16Bold =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
const TextStyle kTitleStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

// Widgets

const SizedBox kSized10H = SizedBox(height: 10);
const SizedBox kSized20H = SizedBox(height: 20);
const SizedBox kSized40H = SizedBox(height: 40);
const SizedBox kSized10W = SizedBox(width: 10);
