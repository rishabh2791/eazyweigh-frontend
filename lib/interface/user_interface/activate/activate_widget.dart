import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class UserActivateWidget extends StatefulWidget {
  const UserActivateWidget({Key? key}) : super(key: key);

  @override
  State<UserActivateWidget> createState() => _UserActivateWidgetState();
}

class _UserActivateWidgetState extends State<UserActivateWidget> {
  //TODO complete this
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Get Materials List",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
