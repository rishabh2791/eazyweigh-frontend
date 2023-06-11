import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class UserDetailsWidget extends StatefulWidget {
  const UserDetailsWidget({Key? key}) : super(key: key);

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  late TextEditingController usernameController;

  @override
  void initState() {
    usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget detailsWidget() {
    return const Column();
  }

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        detailsWidget(),
        context,
        "View User Details",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
