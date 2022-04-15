import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/under_issue.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/under_issue_interface/details/under_issue_items_list_widget.dart';
import 'package:eazyweigh/interface/under_issue_interface/list/under_issue_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifierUnderIssueDetailsWidget extends StatefulWidget {
  final String jobID;
  const VerifierUnderIssueDetailsWidget({
    Key? key,
    required this.jobID,
  }) : super(key: key);

  @override
  State<VerifierUnderIssueDetailsWidget> createState() =>
      _VerifierUnderIssueDetailsWidgetState();
}

class _VerifierUnderIssueDetailsWidgetState
    extends State<VerifierUnderIssueDetailsWidget> {
  bool isLoadingData = false;
  List<UnderIssue> underIssueItems = [];
  Map<String, JobItem> jobItems = {};

  @override
  void initState() {
    getUnderIssueItems();
    scannerListener.addListener(listenToScanner);
    super.initState();
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    super.dispose();
  }

  Future<void> getUnderIssueItems() async {
    await appStore.underIssueApp.list(widget.jobID).then((response) async {
      if (response.containsKey("status")) {
        if (response["status"]) {
          for (var item in response["payload"]) {
            UnderIssue underIssue = UnderIssue.fromJSON(item);
            Map<String, dynamic> condition = {
              "EQUAL": {
                "Field": "job_item",
                "Value": underIssue.jobItem,
              },
            };
            await appStore.jobItemApp
                .get(widget.jobID, condition)
                .then((value) {
              if (value.containsKey("status")) {
                if (value["status"]) {
                  JobItem jobItem = JobItem.fromJSON(value["payload"][0]);
                  jobItems[underIssue.id] = jobItem;
                }
              }
            }).then((value) {
              underIssueItems.add(underIssue);
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

  void updateUnderIssueItems(String jobItemID) {
    for (var jobItem in underIssueItems) {
      if (jobItemID.replaceAll("_", "-") == jobItem.id) {
        jobItem.verified = true;
      }
    }
    setState(() {});
  }

  bool checkAllItemsVerified() {
    bool allVerified = true;
    for (var jobItem in underIssueItems) {
      allVerified = allVerified && jobItem.verified;
    }
    return allVerified;
  }

  dynamic listenToScanner(String data) async {
    Map<String, dynamic> scannerData = jsonDecode(data
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));
    if (scannerData.containsKey("action")) {
      switch (scannerData["action"]) {
        case "logout":
          logout(context);
          break;
        default:
      }
    } else {
      if (scannerData.containsKey("under_issue_id")) {
        await appStore.underIssueApp.update(
            scannerData["under_issue_id"].toString().replaceAll("_", "-"),
            {"verified": true}).then((response) async {
          updateUnderIssueItems(scannerData["under_issue_id"]);
          if (checkAllItemsVerified()) {
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
    for (var underIssueItem in underIssueItems) {
      if (underIssueItem.verified) {
        verified++;
      }
    }
    return verified;
  }

  Widget underIssueListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getVerifiedItems().toString() +
              " item(s) of " +
              underIssueItems.length.toString() +
              " Items Verified.",
          style: const TextStyle(
            color: formHintTextColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        underIssueItems.isEmpty
            ? const Center(
                child: Text(
                  "No Under Issue Items Found",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : UnderIssueItemsListWidget(
                underIssues: underIssueItems,
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
              underIssueListWidget(),
              context,
              "Verify Under Issued Items",
              () {
                navigationService.pushReplacement(
                  CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        const UnderIssueListWidget(),
                  ),
                );
              },
            ),
          );
  }
}
