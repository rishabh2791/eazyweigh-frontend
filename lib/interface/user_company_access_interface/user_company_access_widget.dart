import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:flutter/material.dart';

class UserCompanyAccessWidget extends StatefulWidget {
  const UserCompanyAccessWidget({Key? key}) : super(key: key);

  @override
  State<UserCompanyAccessWidget> createState() =>
      _UserCompanyAccessWidgetState();
}

class _UserCompanyAccessWidgetState extends State<UserCompanyAccessWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: loader(context),
    );
  }
}
