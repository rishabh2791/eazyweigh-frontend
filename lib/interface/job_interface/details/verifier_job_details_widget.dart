import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/infrastructure/printing_service.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/home/operator_home_page.dart';
import 'package:eazyweigh/interface/job_interface/details/job_items_list_widget.dart';
import 'package:eazyweigh/interface/job_interface/list/job_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifierJobDetailsWidget extends StatefulWidget {
  final String jobCode;
  const VerifierJobDetailsWidget({
    Key? key,
    required this.jobCode,
  }) : super(key: key);

  @override
  State<VerifierJobDetailsWidget> createState() =>
      _VerifierJobDetailsWidgetState();
}

class _VerifierJobDetailsWidgetState extends State<VerifierJobDetailsWidget> {
  bool isLoadingData = true;
  List<JobItem> jobItems = [];
  late Job job;
  @override
  void initState() {
    getJobData();
    scannerListener.addListener(listenToScanner);
    super.initState();
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    super.dispose();
  }

  Future<dynamic> getJobData() async {
    await appStore.jobApp.get(widget.jobCode).then((value) async {
      if (value.containsKey("status")) {
        if (value["status"]) {
          job = Job.fromJSON(value["payload"]);
          await appStore.jobItemApp.get(job.id, {}).then((response) async {
            if (response.containsKey("status")) {
              if (response["status"]) {
                for (var item in response["payload"]) {
                  JobItem jobItem = JobItem.fromJSON(item);
                  jobItems.add(jobItem);
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
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(
                message: value["message"],
                title: "Error",
              );
            },
          );
        }
      }
    });
  }

  void updateJobItems(String jobItemID) {
    for (var jobItem in jobItems) {
      if (jobItemID.replaceAll("_", "-") == jobItem.id) {
        jobItem.verified = true;
      }
    }
    setState(() {});
  }

  bool checkAllItemsVerified() {
    bool allVerified = true;
    for (var jobItem in jobItems) {
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
      if (scannerData.containsKey("job_item_id")) {
        await appStore.jobItemApp.update(
            scannerData["job_item_id"].toString().replaceAll("_", "-"),
            {"verified": true}).then((response) async {
          updateJobItems(scannerData["job_item_id"]);
          if (checkAllItemsVerified()) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  message: "All Items Verified. Printing Job Sheet.",
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

  void printJobSheet() {
    Map<String, dynamic> jobSheet = {
      "job_id": job.id,
      "job_code": job.jobCode,
      "job_items": jobItems,
    };
    printingService.printJobSheet(jobSheet);
    navigationService.pushReplacement(
      CupertinoPageRoute(
        builder: (BuildContext context) => const OperatorHomePage(),
      ),
    );
  }

  int getVerifiedItems() {
    int verified = 0;
    for (var jobItem in jobItems) {
      if (jobItem.verified) {
        verified++;
      }
    }
    return verified;
  }

  Widget jobListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getVerifiedItems().toString() +
              " item(s) of " +
              jobItems.length.toString() +
              " Items for Job Code: " +
              widget.jobCode +
              " Verified.",
          style: const TextStyle(
            color: formHintTextColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        jobItems.isEmpty
            ? const Center(
                child: Text(
                  "No Job Items Found",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : JobItemsListWidget(
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
              jobListWidget(),
              context,
              "Verify Job Items",
              () {
                navigationService.pushReplacement(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => const JobListWidget(),
                  ),
                );
              },
            ),
          );
  }
}
