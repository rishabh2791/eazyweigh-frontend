import 'package:flutter/material.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';

class UnderIssueDetailsWidget extends StatefulWidget {
  const UnderIssueDetailsWidget({Key? key}) : super(key: key);

  @override
  State<UnderIssueDetailsWidget> createState() =>
      _UnderIssueDetailsWidgetState();
}

//TODO
class _UnderIssueDetailsWidgetState extends State<UnderIssueDetailsWidget> {
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
