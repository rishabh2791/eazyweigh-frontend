import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:flutter/material.dart';

Widget checkButton() {
  return const Tooltip(
    decoration: BoxDecoration(
      color: foregroundColor,
    ),
    message: "Check",
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Icon(
        Icons.clear_all,
        color: backgroundColor,
        size: 30.0,
      ),
    ),
  );
}

Widget addButton() {
  return const Tooltip(
    decoration: BoxDecoration(
      color: foregroundColor,
    ),
    message: "Add",
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Icon(
        Icons.add,
        color: backgroundColor,
        size: 30.0,
      ),
    ),
  );
}

Widget deleteButton() {
  return const Tooltip(
    message: "Delete",
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Icon(
        Icons.delete,
        color: backgroundColor,
        size: 30.0,
      ),
    ),
  );
}

Widget loader(BuildContext context) {
  return Container(
    color: Colors.transparent,
    height: MediaQuery.of(context).size.height - 66.0,
    child: const Center(
      child: CircularProgressIndicator(
        color: formHintTextColor,
      ),
    ),
  );
}
