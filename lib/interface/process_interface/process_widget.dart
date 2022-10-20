import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/process_interface/create/process_create_widget.dart';
import 'package:eazyweigh/interface/process_interface/details/process_details_widget.dart';
import 'package:eazyweigh/interface/process_interface/update/process_update_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProcessWidget extends StatefulWidget {
  const ProcessWidget({Key? key}) : super(key: key);

  @override
  State<ProcessWidget> createState() => _ProcessWidgetState();
}

class _ProcessWidgetState extends State<ProcessWidget> {
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
                              const ProcessCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "processes",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const ProcessDetailsWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "Details",
                    table: "processes",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const ProcessUpdateWidget(),
                        ),
                      );
                    },
                    icon: Icons.update,
                    label: "Update",
                    table: "processes",
                    accessType: "update",
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
