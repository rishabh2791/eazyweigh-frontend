import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/device_interface/create/device_create_widget.dart';
import 'package:eazyweigh/interface/device_interface/list/device_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeviceWidget extends StatefulWidget {
  const DeviceWidget({Key? key}) : super(key: key);

  @override
  State<DeviceWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
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
                          builder: (BuildContext context) => const DeviceCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "devices",
                    accessType: "create",
                  ),
                  // UserActionButton(
                  //   callback: () {
                  //     Navigator.of(context).pushReplacement(
                  //       CupertinoPageRoute(
                  //         builder: (BuildContext context) => const DeviceDetailsWidget(),
                  //       ),
                  //     );
                  //   },
                  //   icon: Icons.list,
                  //   label: "Details",
                  //   table: "devices",
                  //   accessType: "view",
                  // ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const DeviceListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "devices",
                    accessType: "view",
                  ),
                  // UserActionButton(
                  //   callback: () {
                  //     Navigator.of(context).pushReplacement(
                  //       CupertinoPageRoute(
                  //         builder: (BuildContext context) => const DeviceUpdateWidget(),
                  //       ),
                  //     );
                  //   },
                  //   icon: Icons.update,
                  //   label: "Update",
                  //   table: "devices",
                  //   accessType: "update",
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
