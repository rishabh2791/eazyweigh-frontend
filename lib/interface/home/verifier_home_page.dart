import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class VerifierHomePage extends StatefulWidget {
  const VerifierHomePage({Key? key}) : super(key: key);

  @override
  State<VerifierHomePage> createState() => _VerifierHomePageState();
}

class _VerifierHomePageState extends State<VerifierHomePage> {
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
              "Verify Job",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
