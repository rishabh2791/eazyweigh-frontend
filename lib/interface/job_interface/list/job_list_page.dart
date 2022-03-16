import 'dart:convert';

import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/widget_stack.dart';
import 'package:eazyweigh/interface/job_interface/details/job_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({Key? key}) : super(key: key);

  @override
  State<JobListPage> createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  int currentID = 0;
  var jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scannerListener.addListener(listenToScanner);
    getAllData();
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    super.dispose();
  }

  Future<dynamic> getAllData() async {
    await Future.forEach([await getJobs()], (element) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> getJobs() async {
    //TODO modify once backend is linked
    jobs = [
      "123456",
      "234567",
      "345678",
    ];
  }

  dynamic listenToScanner(String data) {
    Map<String, dynamic> scannerData = jsonDecode(data
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "selection":
        // Selection to Navigate to Next Page
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) =>
                JobDetailsPage(jobID: scannerData["data"]["id"]),
          ),
        );
        break;
      case "navigation":
        navigate(scannerData["data"]);
        break;
      default:
    }
  }

  void navigate(Map<String, dynamic> data) {
    switch (data["type"]) {
      case "previous":
        setState(() {
          if (currentID != 0) {
            currentID--;
          }
        });
        break;
      case "next":
        setState(() {
          if (currentID != jobs.length - 1) {
            currentID++;
          }
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Container()
          : BaseWidget(
              builder: (context, sizeInformation) {
                return Center(
                  child: sizeInformation.screenType == ScreenType.mobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: widgetStack(
                            sizeInformation,
                            jobs[currentID],
                            (jobs.length == 1 || currentID == 0),
                            (currentID == jobs.length - 1),
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: widgetStack(
                            sizeInformation,
                            jobs[currentID],
                            (jobs.length == 1 || currentID == 0),
                            (currentID == jobs.length - 1),
                          ),
                        ),
                );
              },
            ),
    );
  }
}
