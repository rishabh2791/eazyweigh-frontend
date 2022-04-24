import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/shift_schedule_interface/create/create_widget.dart';
import 'package:eazyweigh/interface/shift_schedule_interface/list/list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShiftScheduleWidget extends StatefulWidget {
  const ShiftScheduleWidget({Key? key}) : super(key: key);

  @override
  State<ShiftScheduleWidget> createState() => _ShiftScheduleWidgetState();
}

class _ShiftScheduleWidgetState extends State<ShiftScheduleWidget> {
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
                              const ShiftScheduleCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "shift_schedules",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const ShiftScheduleListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "shift_schedules",
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
