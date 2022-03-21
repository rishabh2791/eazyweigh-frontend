import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({Key? key}) : super(key: key);

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
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
                      //TODO define navigation
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "users",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.get_app,
                    label: "Details",
                    table: "users",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "users",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.update,
                    label: "Update",
                    table: "users",
                    accessType: "update",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.update,
                    label: "Activate",
                    table: "users",
                    accessType: "update",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.update,
                    label: "Deactivate",
                    table: "users",
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
