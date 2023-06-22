import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/over_issue.dart';
import 'package:eazyweigh/infrastructure/printing_service.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/over_issue_interface/details/over_issue_items_list_widget.dart';
import 'package:eazyweigh/interface/over_issue_interface/list/over_issue_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifierOverIssueDetailsWidget extends StatefulWidget {
  final String jobID;
  final Job job;
  const VerifierOverIssueDetailsWidget({
    Key? key,
    required this.jobID,
    required this.job,
  }) : super(key: key);

  @override
  State<VerifierOverIssueDetailsWidget> createState() => _VerifierOverIssueDetailsWidgetState();
}

class _VerifierOverIssueDetailsWidgetState extends State<VerifierOverIssueDetailsWidget> {
  bool isLoadingData = false;
  List<OverIssue> overIssueItems = [];
  Map<String, JobItem> jobItems = {};

  @override
  void initState() {
    getOverIssueItems();
    scannerListener.addListener(listenToScanner);
    printingService.addListener(listenToPrintingService);
    super.initState();
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    printingService.removeListener(listenToPrintingService);
    super.dispose();
  }

  void listenToPrintingService(String message) {
    Map<String, dynamic> scannerData = jsonDecode(message);
    if (!(scannerData.containsKey("status") && scannerData["status"] == "done")) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomDialog(
            message: "Unable to Print.",
            title: "Error",
          );
        },
      );
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.of(context).pop();
      });
    }
    printingService.close();
  }

  Future<void> getOverIssueItems() async {
    await appStore.overIssueApp.list(widget.jobID).then((response) async {
      if (response.containsKey("status")) {
        if (response["status"]) {
          for (var item in response["payload"]) {
            OverIssue overIssue = OverIssue.fromJSON(item);
            Map<String, dynamic> condition = {
              "EQUAL": {
                "Field": "job_item",
                "Value": overIssue.jobItem,
              },
            };
            await appStore.jobItemApp.get(widget.jobID, condition).then((value) {
              if (value.containsKey("status")) {
                if (value["status"]) {
                  JobItem jobItem = JobItem.fromJSON(value["payload"][0]);
                  jobItems[overIssue.id] = jobItem;
                }
              }
            }).then((value) {
              overIssueItems.add(overIssue);
            });
          }
          setState(() {
            isLoadingData = false;
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
    });
  }

  void updateOverIssueItems(String jobItemID) {
    for (var jobItem in overIssueItems) {
      if (jobItemID.replaceAll("_", "-") == jobItem.id) {
        jobItem.verified = true;
      }
    }
    setState(() {});
  }

  bool checkAllItemsVerified() {
    bool allVerified = true;
    for (var jobItem in overIssueItems) {
      allVerified = allVerified && jobItem.verified;
    }
    return allVerified;
  }

  dynamic listenToScanner(String data) async {
    Map<String, dynamic> scannerData = jsonDecode(data.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
    if (scannerData.containsKey("action")) {
      switch (scannerData["action"]) {
        case "logout":
          logout();
          break;
        default:
      }
    } else {
      if (scannerData.containsKey("over_issue_id")) {
        await appStore.overIssueApp.update(scannerData["over_issue_id"].toString().replaceAll("_", "-"), {"verified": true}).then((response) async {
          updateOverIssueItems(scannerData["over_issue_id"]);
          if (checkAllItemsVerified()) {
            Map<String, dynamic> printingData = {
              "job_code": widget.job.jobCode,
              "job_id": widget.jobID,
              "verifier": currentUser.firstName + " " + currentUser.lastName,
              "material_code": widget.job.material.code,
              "material_description": widget.job.material.description,
            };
            printingService.printVerificationLabel(printingData);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  message: "All Items Verified.",
                  title: "Info",
                );
              },
            );
            Future.delayed(const Duration(seconds: 3)).then((value) {
              Navigator.of(context).pop();
            });
          }
        });
      }
    }
  }

  int getVerifiedItems() {
    int verified = 0;
    for (var overIssueItem in overIssueItems) {
      if (overIssueItem.verified) {
        verified++;
      }
    }
    return verified;
  }

  Widget overIssueListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getVerifiedItems().toString() + " item(s) of " + overIssueItems.length.toString() + " Items Verified.",
          style: const TextStyle(
            color: formHintTextColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        overIssueItems.isEmpty
            ? const Center(
                child: Text(
                  "No Over Issue Items Found",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : OverIssueItemsListWidget(
                overIssues: overIssueItems,
                jobItems: jobItems,
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingData
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: buildWidget(
              overIssueListWidget(),
              context,
              "Verify Over Issued Items",
              () {
                navigationService.pushReplacement(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => const OverIssueListWidget(),
                  ),
                );
              },
            ),
          );
  }
}
