import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/user_role_access_interface/create_widget/user_role_access_create_widget.dart';
import 'package:eazyweigh/interface/user_role_access_interface/list_widget/user_role_access_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserRoleAccessWidget extends StatefulWidget {
  const UserRoleAccessWidget({Key? key}) : super(key: key);

  @override
  State<UserRoleAccessWidget> createState() => _UserRoleAccessWidgetState();
}

class _UserRoleAccessWidgetState extends State<UserRoleAccessWidget> {
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
                              const UserRoleAccessCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "user_role_accesses",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const UserRoleAccessListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "user_roles_accesses",
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
