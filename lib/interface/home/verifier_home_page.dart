import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class VerifierHomePage extends StatefulWidget {
  const VerifierHomePage({Key? key}) : super(key: key);

  @override
  State<VerifierHomePage> createState() => _VerifierHomePageState();
}

class _VerifierHomePageState extends State<VerifierHomePage> {
  bool isJobSelected = false;
  bool isLoadingPage = true;
  late Job job;

  @override
  void initState() {
    getDetails();
    scannerListener.addListener(listenToScanner);
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
        if (scannerData.containsKey("job_id")) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return loader(context);
            },
          );
          var jobID = scannerData["job_id"];
          await appStore.jobApp.get(jobID).then((response) async {
            if (response.containsKey("status")) {
              if (response["status"]) {
                Job j = Job.fromJSON(response["payload"]);
                job = j;
                setState(() {
                  isJobSelected = true;
                });
              } else {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      message: response["message"],
                      title: "Error",
                    );
                  },
                );
              }
            } else {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const CustomDialog(
                    message: "Unable to Connect.",
                    title: "Error",
                  );
                },
              );
            }
            setState(() {
              isJobSelected = true;
            });
          });
        }
        if (scannerData.containsKey("job_item_id")) {
          //TODO
        }
        if (scannerData.containsKey("over_issue_id")) {
          //TODO
        }
        if (scannerData.containsKey("under_issue_id")) {
          //TODO
        }
    }
  }

  Widget jobSelected() {
    return Center(
      child: Text(
        currentUser.firstName,
      ),
    );
  }

  Widget jobUnselected() {
    return const Center(
      child: Text(
        "Scan Job Card to Begin Verification.",
        style: TextStyle(
          color: foregroundColor,
          fontSize: 60,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        isJobSelected ? jobSelected() : jobUnselected(),
        context,
        "Verify Jobs",
        () {},
      ),
    );
  }
}
