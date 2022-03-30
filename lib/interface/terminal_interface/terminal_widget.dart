import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/terminal_interface/assign.dart';
import 'package:eazyweigh/interface/terminal_interface/create/create_widget.dart';
import 'package:eazyweigh/interface/terminal_interface/details/details_widget.dart';
import 'package:eazyweigh/interface/terminal_interface/list/list_widget.dart';
import 'package:eazyweigh/interface/terminal_interface/update/update_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TerminalWidget extends StatefulWidget {
  const TerminalWidget({Key? key}) : super(key: key);

  @override
  State<TerminalWidget> createState() => _TerminalWidgetState();
}

class _TerminalWidgetState extends State<TerminalWidget> {
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
                              const TerminalCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "terminals",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const TerminalDetailsWidget(),
                        ),
                      );
                    },
                    icon: Icons.get_app,
                    label: "Details",
                    table: "terminals",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const TerminalListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "terminals",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const TerminalUpdateWidget(),
                        ),
                      );
                    },
                    icon: Icons.update,
                    label: "Update",
                    table: "terminals",
                    accessType: "Update",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const AssignAsTerminal(),
                        ),
                      );
                    },
                    icon: Icons.update,
                    label: "Assign",
                    table: "terminals",
                    accessType: "Assign",
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
