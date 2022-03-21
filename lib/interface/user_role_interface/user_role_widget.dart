import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:flutter/material.dart';

class UserRoleWidget extends StatefulWidget {
  const UserRoleWidget({Key? key}) : super(key: key);

  @override
  State<UserRoleWidget> createState() => _UserRoleWidgetState();
}

class _UserRoleWidgetState extends State<UserRoleWidget> {
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
                    table: "user_roles",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.get_app,
                    label: "Details",
                    table: "user_roles",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "user_roles",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.update,
                    label: "Update",
                    table: "user_roles",
                    accessType: "Update",
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
