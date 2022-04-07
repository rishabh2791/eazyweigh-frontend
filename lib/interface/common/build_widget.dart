import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

Widget buildWidget(
    Widget child, BuildContext context, String title, VoidCallback callback) {
  return BaseWidget(
    builder: (context, sizeInfo) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        width: sizeInfo.screenSize.width,
        height: sizeInfo.screenSize.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: callback,
                    child: const Icon(
                      Icons.arrow_back,
                      color: formHintTextColor,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10, color: Colors.black, spreadRadius: 5)
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(baseURL + currentUser.profilePic),
                    radius: 40,
                  ),
                ),
                const VerticalDivider(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30.0,
                    color: formHintTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: BaseWidget(
                builder: (context, sizeInformation) {
                  return SizedBox(
                    height: sizeInformation.localWidgetSize.height,
                    child: SingleChildScrollView(
                      child: child,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 80.0,
            ),
          ],
        ),
      );
    },
  );
}
