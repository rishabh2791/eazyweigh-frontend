import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/vessel_interface/create/vessel_create_widget.dart';
import 'package:eazyweigh/interface/vessel_interface/details/vessel_details_widget.dart';
import 'package:eazyweigh/interface/vessel_interface/list/vessel_list_widget.dart';
import 'package:eazyweigh/interface/vessel_interface/update/vessel_update_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VesselWidget extends StatefulWidget {
  const VesselWidget({Key? key}) : super(key: key);

  @override
  State<VesselWidget> createState() => _VesselWidgetState();
}

class _VesselWidgetState extends State<VesselWidget> {
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
                          builder: (BuildContext context) => const VesselCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "vessels",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const VesselDetailsWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "Details",
                    table: "vessels",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const VesselListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "vessels",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const VesselUpdateWidget(),
                        ),
                      );
                    },
                    icon: Icons.update,
                    label: "Update",
                    table: "vessels",
                    accessType: "update",
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
