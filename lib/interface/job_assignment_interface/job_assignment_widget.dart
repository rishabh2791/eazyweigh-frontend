import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/job_assignment_interface/create/create_widget.dart';
import 'package:eazyweigh/interface/job_assignment_interface/details/details_widget.dart';
import 'package:eazyweigh/interface/job_assignment_interface/list/list_widget.dart';
import 'package:eazyweigh/interface/job_assignment_interface/update/update_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobAssignmentWidget extends StatefulWidget {
  const JobAssignmentWidget({Key? key}) : super(key: key);

  @override
  State<JobAssignmentWidget> createState() => _JobAssignmentWidgetState();
}

class _JobAssignmentWidgetState extends State<JobAssignmentWidget> {
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
                              const JobAssignmentCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "job_item_assignments",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const JobAssignmentDetailsWidget(),
                        ),
                      );
                    },
                    icon: Icons.get_app,
                    label: "Details",
                    table: "job_item_assignments",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const JobAssignmentListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "job_item_assignments",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const JobAssignmentUpdateWidget(),
                        ),
                      );
                    },
                    icon: Icons.update,
                    label: "Update",
                    table: "job_item_assignments",
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
