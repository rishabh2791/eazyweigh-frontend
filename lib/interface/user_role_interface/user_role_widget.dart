import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/user_role_interface/create/user_role_create_widget.dart';
import 'package:eazyweigh/interface/user_role_interface/list/user_role_list_widget.dart';
import 'package:flutter/cupertino.dart';
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
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const UserRoleCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "user_roles",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const UserRoleListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "user_roles",
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
