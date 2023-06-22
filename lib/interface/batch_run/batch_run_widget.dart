import 'package:eazyweigh/interface/batch_run/create/create_widget.dart';
import 'package:eazyweigh/interface/batch_run/details/batch_run_details.dart';
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
                          builder: (BuildContext context) => const BatchRunWidget(),
                        ),
                      );
                    },
                    icon: Icons.get_app,
                    label: "Details",
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
