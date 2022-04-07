import 'package:flutter/material.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';

class UnderIssueCreateWidget extends StatefulWidget {
  const UnderIssueCreateWidget({Key? key}) : super(key: key);

  @override
  State<UnderIssueCreateWidget> createState() => _UnderIssueCreateWidgetState();
}

//TODO
class _UnderIssueCreateWidgetState extends State<UnderIssueCreateWidget> {
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
