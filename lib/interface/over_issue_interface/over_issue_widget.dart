import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/over_issue_interface/create/over_issue_create_widget.dart';
import 'package:eazyweigh/interface/over_issue_interface/list/over_issue_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverIssueWidget extends StatefulWidget {
  const OverIssueWidget({Key? key}) : super(key: key);

  @override
  State<OverIssueWidget> createState() => _OverIssueWidgetState();
}

class _OverIssueWidgetState extends State<OverIssueWidget> {
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
                              const OverIssueCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "over_issues",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const OverIssueListWidget(),
                        ),
                      );
                    },
                    icon: Icons.details,
                    label: "List",
                    table: "over_issues",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const OverIssueListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "over_issues",
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
