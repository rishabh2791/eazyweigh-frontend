import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

Widget textField(bool obscureText, TextEditingController controller,
    String label, bool disabled) {
  return BaseWidget(
    builder: (context, size) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 400, minWidth: 300),
        width: size.screenType == ScreenType.mobile
            ? size.screenSize.width * 0.8
            : size.screenSize.width * 0.3,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 5,
                color: shadowColor,
              ),
            ],
          ),
          child: TextFormField(
            obscureText: obscureText,
            controller: controller,
            style: const TextStyle(
              color: formLabelTextColor,
            ),
            readOnly: disabled,
            decoration: InputDecoration(
              fillColor: primaryColor,
              labelText: label,
              hintText: label,
              labelStyle: const TextStyle(
                color: formLabelTextColor,
              ),
              hintStyle: const TextStyle(
                color: formHintTextColor,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: secondaryColor,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
