import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:flutter/material.dart';

Widget checkButton() {
  return const Tooltip(
    decoration: BoxDecoration(
      color: foregroundColor,
    ),
    message: "Check",
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
