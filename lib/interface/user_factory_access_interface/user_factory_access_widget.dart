import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:flutter/material.dart';

class UserFactoryAccessWidget extends StatefulWidget {
  const UserFactoryAccessWidget({Key? key}) : super(key: key);

  @override
  State<UserFactoryAccessWidget> createState() =>
      _UserFactoryAccessWidgetState();
}

class _UserFactoryAccessWidgetState extends State<UserFactoryAccessWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: loader(context),
    );
  }
}
