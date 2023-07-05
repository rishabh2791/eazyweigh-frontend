import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:flutter/material.dart';

Widget checkButton() {
  return const Tooltip(
    decoration: BoxDecoration(
      color: foregroundColor,
    ),
    textStyle: TextStyle(
      fontSize: 16.0,
    ),
    message: "OK",
    child: Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Icon(
        Icons.check,
        color: backgroundColor,
        size: 30.0,
      ),
    ),
  );
}

Widget clearButton() {
  return const Tooltip(
    decoration: BoxDecoration(
      color: foregroundColor,
    ),
    textStyle: TextStyle(
      fontSize: 16.0,
    ),
    message: "Clear",
    child: Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Icon(
        Icons.clear_all,
        color: backgroundColor,
        size: 30.0,
      ),
    ),
  );
}

Widget crossButton() {
  return const Tooltip(
    decoration: BoxDecoration(
      color: foregroundColor,
    ),
    textStyle: TextStyle(
      fontSize: 16.0,
    ),
    message: "Clear",
    child: Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Icon(
        Icons.cancel_presentation,
        color: backgroundColor,
        size: 30.0,
      ),
    ),
  );
}

Widget scanButton() {
  return const Tooltip(
    decoration: BoxDecoration(
      color: foregroundColor,
    ),
    textStyle: TextStyle(
      fontSize: 16.0,
    ),
    message: "Clear",
    child: Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Icon(
        Icons.qr_code_scanner,
        color: backgroundColor,
        size: 30.0,
      ),
    ),
  );
}
