import 'dart:ui';

import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title, message;
  const CustomDialog({Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      elevation: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            top: 10,
            right: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width / 4),
            child: BaseWidget(
              builder: (context, sizeInfo) {
                return SizedBox(
                  width: sizeInfo.localWidgetSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        alignment: Alignment.center,
                        child: Text(
                          widget.message,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        child: const Text(
                          "Close",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: primaryColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
