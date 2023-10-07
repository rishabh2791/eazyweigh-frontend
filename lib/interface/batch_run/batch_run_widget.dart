import 'package:eazyweigh/interface/batch_run/create/create_widget.dart';
import 'package:eazyweigh/interface/batch_run/by_job/batch_run_details.dart' as by_job;
import 'package:eazyweigh/interface/batch_run/by_vessel/batch_run_details.dart' as by_vessel;
import 'package:eazyweigh/interface/batch_run/by_material/batch_run_details.dart' as by_material;
import 'package:eazyweigh/interface/batch_run/by_material_overlapped/batch_run_details.dart' as by_material_overlapped;
import 'package:eazyweigh/interface/batch_run/in_interval/in_interval.dart' as in_interval;
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BatchRunWidget extends StatefulWidget {
  const BatchRunWidget({Key? key}) : super(key: key);

  @override
  State<BatchRunWidget> createState() => _BatchRunWidgetState();
}

class _BatchRunWidgetState extends State<BatchRunWidget> {
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
                          builder: (BuildContext context) => const BatchRunCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Start",
                    table: "batch_runs",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const by_job.BatchRunDetails(),
                        ),
                      );
                    },
                    icon: Icons.grid_view,
                    label: "By Job",
                    table: "batch_runs",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const by_vessel.BatchRunDetails(),
                        ),
                      );
                    },
                    icon: Icons.grid_view,
                    label: "By Vessel",
                    table: "batch_runs",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const by_material.BatchRunDetails(),
                        ),
                      );
                    },
                    icon: Icons.grid_view,
                    label: "By Material",
                    table: "batch_runs",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const by_material_overlapped.BatchRunDetails(),
                        ),
                      );
                    },
                    icon: Icons.grid_view,
                    label: "Overlapped",
                    table: "batch_runs",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const in_interval.BatchRunDetails(),
                        ),
                      );
                    },
                    icon: Icons.grid_view,
                    label: "In Interval",
                    table: "batch_runs",
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
