import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:flutter/material.dart';

class BOMWidget extends StatefulWidget {
  const BOMWidget({Key? key}) : super(key: key);

  @override
  State<BOMWidget> createState() => _BOMWidgetState();
}

class _BOMWidgetState extends State<BOMWidget> {
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
                    table: "boms",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.get_app,
                    label: "Details",
                    table: "boms",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "boms",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      //TODO define navigation
                    },
                    icon: Icons.update,
                    label: "Update",
                    table: "boms",
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
