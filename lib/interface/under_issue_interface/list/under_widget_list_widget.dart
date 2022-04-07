import 'dart:convert';

import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class UnderIssueListWidget extends StatefulWidget {
  const UnderIssueListWidget({Key? key}) : super(key: key);

  @override
  State<UnderIssueListWidget> createState() => _UnderIssueListWidgetState();
}

//TODO
class _UnderIssueListWidgetState extends State<UnderIssueListWidget> {
  bool isLoadingPage = true;

  @override
  void initState() {
    scannerListener.addListener(listenToScanner);
    getDetails();
    super.initState();
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    super.dispose();
  }

  void getDetails() {
    setState(() {
      isLoadingPage = false;
    });
  }

  dynamic listenToScanner(String data) {
    Map<String, dynamic> scannerData = jsonDecode(data
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "logout":
        logout(context);
        break;
      default:
    }
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
