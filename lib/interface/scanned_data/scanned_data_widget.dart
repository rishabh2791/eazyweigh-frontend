import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/scanned_data/list/scanned_data_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScannedDataWidget extends StatelessWidget {
  const ScannedDataWidget({Key? key}) : super(key: key);

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
                              const ScannedDataListWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "List",
                    table: "scanned_data",
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
