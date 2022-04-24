import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/shift_interface/create/create_widget.dart';
import 'package:eazyweigh/interface/shift_interface/list/list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShiftWidget extends StatefulWidget {
  const ShiftWidget({Key? key}) : super(key: key);

  @override
  State<ShiftWidget> createState() => _ShiftWidgetState();
}

class _ShiftWidgetState extends State<ShiftWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: BaseWidget(
        builder: (context, sizeInformation) {
          return SizedBox(
            height: sizeInformation.screenSize.height,
            width: sizeInformation.screenSize.width,
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const ShiftCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "shifts",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const ShiftListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "shifts",
                    accessType: "view",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
