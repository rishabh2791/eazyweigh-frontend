import 'package:eazyweigh/application/user_company_access_app.dart';
import 'package:eazyweigh/application/user_terminal_access_app.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/user_company_access_interface/user_company_access_widget.dart';
import 'package:eazyweigh/interface/user_factory_access_interface/user_factory_access_widget.dart';
import 'package:eazyweigh/interface/user_role_access_interface/user_role_access_widget.dart';
import 'package:eazyweigh/interface/user_terminal_access_interface/user_terminal_access_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAccessWidget extends StatelessWidget {
  const UserAccessWidget({Key? key}) : super(key: key);

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
                              const UserRoleAccessWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Role Access",
                    table: "user_role_access",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const UserFactoryAccessWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Factory Access",
                    table: "user_factory_accesses",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const UserTerminalAccessWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Terminal Access",
                    table: "user_terminal_accesses",
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
