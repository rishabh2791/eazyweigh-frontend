import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:flutter/material.dart';

Widget genericButton(IconData icon, String msg) {
  return Tooltip(
    decoration: const BoxDecoration(
      color: foregroundColor,
    ),
    textStyle: const TextStyle(
      fontSize: 16.0,
    ),
    message: msg,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Icon(
        icon,
        color: backgroundColor,
        size: 30.0,
      ),
    ),
  );
}

Widget checkButton() {
  return genericButton(Icons.check, "OK");
}

Widget clearButton() {
  return genericButton(Icons.clear_all, "Clear");
}

Widget crossButton() {
  return genericButton(Icons.cancel_presentation, "Close");
}

Widget scanButton() {
  return genericButton(Icons.qr_code_scanner, "Scan");
}
