import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/job_interface/create/job_create_widget.dart';
import 'package:eazyweigh/interface/job_interface/details/job_details.dart';
import 'package:eazyweigh/interface/job_interface/list/job_list_widget.dart';
import 'package:eazyweigh/interface/job_interface/update/job_update_widget.dart';
import 'package:eazyweigh/interface/job_interface/weighing/batch_details.dart';
import 'package:eazyweigh/interface/job_interface/weighing/job_weighing_widget.dart';
import 'package:eazyweigh/interface/job_interface/weighing/material_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobWidget extends StatefulWidget {
  const JobWidget({Key? key}) : super(key: key);

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
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
                          builder: (BuildContext context) => const JobCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "jobs",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const FullJobDetailsWidget(),
                        ),
                      );
                    },
                    icon: Icons.details,
                    label: "Details",
                    table: "jobs",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const JobUpdateWidget(),
                        ),
                      );
                    },
                    icon: Icons.update,
                    label: "Update",
                    table: "jobs",
                    accessType: "update",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const JobListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "jobs",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const JobWeighingWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "Weighing",
                    table: "jobs",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const WeighingBatchDetailsWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "Batch",
                    table: "jobs",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const MaterialWeighingDetailsWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "Material",
                    table: "jobs",
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
