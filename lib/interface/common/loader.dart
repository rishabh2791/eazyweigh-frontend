import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:flutter/material.dart';

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
