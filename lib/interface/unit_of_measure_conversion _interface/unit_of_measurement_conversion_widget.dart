import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/unit_of_measure_conversion%20_interface/create/create_widget.dart';
import 'package:eazyweigh/interface/unit_of_measure_conversion%20_interface/details/details_widget.dart';
import 'package:eazyweigh/interface/unit_of_measure_conversion%20_interface/list/list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnitOfMeasurementConversionWidget extends StatefulWidget {
  const UnitOfMeasurementConversionWidget({Key? key}) : super(key: key);

  @override
  State<UnitOfMeasurementConversionWidget> createState() =>
      _UnitOfMeasurementConversionWidgetState();
}

class _UnitOfMeasurementConversionWidgetState
    extends State<UnitOfMeasurementConversionWidget> {
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
                              const UOMConversionCreateWidget(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "unit_of_measure_conversions",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const UOMConversionDetailsWidget(),
                        ),
                      );
                    },
                    icon: Icons.get_app,
                    label: "Details",
                    table: "unit_of_measure_conversions",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const UOMConversionListWidget(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "unit_of_measure_conversions",
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
