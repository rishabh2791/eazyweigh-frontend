import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class UserRoleListWidget extends StatefulWidget {
  const UserRoleListWidget({Key? key}) : super(key: key);

  @override
  State<UserRoleListWidget> createState() => _UserRoleListWidgetState();
}

class _UserRoleListWidgetState extends State<UserRoleListWidget> {
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

  Widget homeWidget() {
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
            childWidget: homeWidget(),
          );
  }
}
