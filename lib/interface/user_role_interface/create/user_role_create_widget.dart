import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class UserRoleCreateWidget extends StatefulWidget {
  const UserRoleCreateWidget({Key? key}) : super(key: key);

  @override
  State<UserRoleCreateWidget> createState() => _UserRoleCreateWidgetState();
}

class _UserRoleCreateWidgetState extends State<UserRoleCreateWidget> {
  //TODO
  bool isLoadingPage = true;

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDetails() {
    setState(() {
      isLoadingPage = false;
    });
  }

  Widget createWidget() {
    return Center(
      child: Text(
        currentUser.firstName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingPage
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: buildWidget(
              createWidget(),
              context,
              "Create User Roles",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
