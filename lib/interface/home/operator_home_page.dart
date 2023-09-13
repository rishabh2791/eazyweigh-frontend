import 'dart:convert';

import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/job_interface/list/job_list_widget.dart';
import 'package:eazyweigh/interface/over_issue_interface/list/over_issue_list_widget.dart';
import 'package:eazyweigh/interface/under_issue_interface/list/under_issue_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OperatorHomePage extends StatefulWidget {
  const OperatorHomePage({Key? key}) : super(key: key);

  @override
  State<OperatorHomePage> createState() => _OperatorHomePageState();
}

class _OperatorHomePageState extends State<OperatorHomePage> {
  bool isLoadingPage = true;
  String weighing = "{'action':'weighing'}";
  String overIssue = "{'action':'over_issue'}";
  String underIssue = "{'action':'under_issue'}";

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

  void listenToScanner(String data) async {
    Map<String, dynamic> scannerData = jsonDecode(data.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "weighing":
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => const JobListWidget(),
          ),
        );
        break;
      case "over_issue":
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => const OverIssueListWidget(),
          ),
        );
        break;
      case "under_issue":
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => const UnderIssueListWidget(),
          ),
        );
        break;
      case "logout":
        logout();
        break;
      default:
    }
  }

  Widget homeWidget() {
    String timeOfDay = "Good Morning";
    int hour = DateTime.now().hour;
    if (hour >= 12 && hour < 16) {
      timeOfDay = "Good Afternoon";
    }
    if (hour >= 16) {
      timeOfDay = "Good Evening";
    }
    return BaseWidget(builder: (context, sizeInformation) {
      return SizedBox(
        width: sizeInformation.screenSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: Text(
                      timeOfDay + " " + currentUser.firstName + " " + currentUser.lastName,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: sizeInformation.screenSize.width / 1920,
                  child: SizedBox(
                    width: sizeInformation.screenSize.width / 3 - 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              navigationService.pushReplacement(
                                CupertinoPageRoute(
                                  builder: (BuildContext context) => const UnderIssueListWidget(),
                                ),
                              );
                            },
                            child: QrImageView(
                              size: 250,
                              data: underIssue,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Under Issue",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.scale(
                  scale: sizeInformation.screenSize.width / 1920,
                  child: SizedBox(
                    width: sizeInformation.screenSize.width / 3 - 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              navigationService.pushReplacement(
                                CupertinoPageRoute(
                                  builder: (BuildContext context) => const JobListWidget(),
                                ),
                              );
                            },
                            child: QrImageView(
                              size: 250,
                              data: weighing,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Job Weighing",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.scale(
                  scale: sizeInformation.screenSize.width / 1920,
                  child: SizedBox(
                    width: sizeInformation.screenSize.width / 3 - 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              navigationService.pushReplacement(
                                CupertinoPageRoute(
                                  builder: (BuildContext context) => const OverIssueListWidget(),
                                ),
                              );
                            },
                            child: QrImageView(
                              size: 250,
                              data: overIssue,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Over Issue",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
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
