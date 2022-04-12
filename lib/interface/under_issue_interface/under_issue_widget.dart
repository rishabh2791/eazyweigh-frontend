import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/under_issue_interface/create/under_issue_create_widget.dart';
import 'package:eazyweigh/interface/under_issue_interface/list/under_issue_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnderIssueWidget extends StatefulWidget {
  const UnderIssueWidget({Key? key}) : super(key: key);

  @override
  State<UnderIssueWidget> createState() => _UnderIssueWidgetState();
}

class _UnderIssueWidgetState extends State<UnderIssueWidget> {
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
                              const UnderIssueCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "under_issues",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const UnderIssueListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "under_issues",
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
