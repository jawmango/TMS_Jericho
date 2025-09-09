import 'package:flutter/material.dart';

abstract class AppStyles {
  //global colors
  static const MaterialColor primaryColor = Colors.grey;
  static const MaterialColor secondaryColor = Colors.blue;
  static const MaterialColor errorColor = Colors.red;

  static const double largeFontSize = 18.0;

  //text style for rows in transaction table
  static TextStyle dataRowTextStyle = TextStyle(
    color: AppStyles.primaryColor.shade800,
    fontSize: 13,
  );

  //text style for form submit and cancel buttons
  static TextStyle formButtonsStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const BorderRadius defaultBorderRadius = BorderRadius.all(
    Radius.circular(8),
  );

  //style for input decoration
  static InputDecoration inputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: AppStyles.primaryColor.shade400),
      prefixIcon: Icon(prefixIcon, color: AppStyles.primaryColor.shade500, size: 20),
      border: OutlineInputBorder(
        borderRadius: AppStyles.defaultBorderRadius,
        borderSide: BorderSide(color: AppStyles.primaryColor.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppStyles.defaultBorderRadius,
        borderSide: BorderSide(color: AppStyles.primaryColor.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppStyles.defaultBorderRadius,
        borderSide: BorderSide(color: AppStyles.secondaryColor.shade600, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppStyles.defaultBorderRadius,
        borderSide: BorderSide(color: AppStyles.errorColor.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppStyles.defaultBorderRadius,
        borderSide: BorderSide(color: AppStyles.errorColor.shade400, width: 2),
      ),
      filled: true,
      fillColor: AppStyles.primaryColor.shade50,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

}

