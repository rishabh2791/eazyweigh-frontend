import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/job_item_weighing.dart';
import 'package:eazyweigh/domain/entity/over_issue.dart';
import 'package:eazyweigh/domain/entity/under_issue.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/job_interface/details/over_issue_list.dart';
import 'package:eazyweigh/interface/job_interface/details/under_issue_list.dart';
import 'package:eazyweigh/interface/job_interface/details/weighing_list.dart';
import 'package:eazyweigh/interface/job_interface/job_widget.dart';
import 'package:eazyweigh/interface/over_issue_interface/list/hybrid_over_issue.dart';
import 'package:eazyweigh/interface/under_issue_interface/list/hybrid_under_issue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullJobDetailsWidget extends StatefulWidget {
  const FullJobDetailsWidget({Key? key}) : super(key: key);

  @override
  State<FullJobDetailsWidget> createState() => _FullJobDetailsWidgetState();
}

class _FullJobDetailsWidgetState extends State<FullJobDetailsWidget> {
  bool isLoadingData = true;
  bool isDataLoaded = false;
  List<Factory> factories = [];
  List<JobItem> jobItems = [];
  late Job job;
  int timeTaken = 0, totalTimeTaken = 0;
  DateTime firstStartTime = DateTime(2099, 1, 1).toLocal(), lastEndTime = DateTime(1900, 1, 1).toLocal();
  Map<String, List<JobItemWeighing>> jobWeighings = {};
  Map<String, List<HybridOverIssue>> overIssues = {};
  Map<String, List<HybridUnderIssue>> underIssues = {};
  Map<String, dynamic> wrongScans = {};
  List<String> jobItemIDs = [];
  late ScrollController scrollController;
  late TextEditingController jobCodeController, factoryController;

  @override
  void initState() {
    jobCodeController = TextEditingController();
    factoryController = TextEditingController();
    scrollController = ScrollController();
    getFactories();
    super.initState();
  }

  Future<dynamic> getJobItemWeighings() async {
    for (var jobItemID in jobItemIDs) {
      await appStore.jobWeighingApp.list(jobItemID).then((response) async {
        if (response.containsKey("status") && response["status"]) {
          await Future.forEach(response["payload"], (dynamic item) async {
            JobItemWeighing jobItemWeighing = await JobItemWeighing.fromServer(Map<String, dynamic>.from(item));
            if (jobItemWeighing.startTime.toLocal().difference(firstStartTime.toLocal()).inSeconds < 0) {
              firstStartTime = jobItemWeighing.startTime.toLocal();
            }
            if (jobItemWeighing.endTime.toLocal().difference(lastEndTime.toLocal()).inSeconds > 0) {
              lastEndTime = jobItemWeighing.endTime.toLocal();
            }
            timeTaken += jobItemWeighing.endTime.difference(jobItemWeighing.startTime).inSeconds;
            if (jobWeighings.containsKey(jobItemID)) {
              jobWeighings[jobItemID]!.add(jobItemWeighing);
            } else {
              jobWeighings[jobItemID] = [jobItemWeighing];
            }
          });
        }
      });
    }
  }

  Future<dynamic> getJobItemOverIssues() async {
    String jobID = jobItems.first.jobID;
    await appStore.overIssueApp.list(jobID).then((response) async {
      if (response.containsKey("status") && response["status"]) {
        await Future.forEach(response["payload"], (dynamic item) async {
          await Future.value(await OverIssue.fromServer(Map<String, dynamic>.from(item))).then((OverIssue overIssue) async {
            Map<String, dynamic> jsonObject = {
              "job_id": jobID,
              "over_issue_id": overIssue.id,
            };
            await Future.value(await HybridOverIssue.fromServer(jsonObject)).then((HybridOverIssue hybridOverIssue) {
              if (overIssues.containsKey(overIssue.jobItem.id)) {
                overIssues[overIssue.jobItem.id]!.add(hybridOverIssue);
              } else {
                overIssues[overIssue.jobItem.id] = [hybridOverIssue];
              }
            });
          });
        });
      }
    });
  }

  Future<dynamic> getJobItemUnderIssues() async {
    String jobID = jobItems.first.jobID;
    await appStore.underIssueApp.list(jobID).then((response) async {
      if (response.containsKey("status") && response["status"]) {
        await Future.forEach(response["payload"], (dynamic item) async {
          await Future.value(await UnderIssue.fromServer(Map<String, dynamic>.from(item))).then((UnderIssue underIssue) async {
            Map<String, dynamic> jsonObject = {
              "job_id": jobID,
              "under_issue_id": underIssue.id,
            };
            await Future.value(await HybridUnderIssue.fromServer(jsonObject)).then((HybridUnderIssue hybridUnderIssue) {
              if (underIssues.containsKey(underIssue.jobItem.id)) {
                underIssues[underIssue.jobItem.id]!.add(hybridUnderIssue);
              } else {
                underIssues[underIssue.jobItem.id] = [hybridUnderIssue];
              }
            });
          });
        });
      }
    });
  }

  Future<dynamic> getFactories() async {
    factories = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "company_id",
        "Value": companyID,
      }
    };
    await appStore.factoryApp.list(conditions).then((response) async {
      if (response["status"]) {
        await Future.forEach(response["payload"], (dynamic item) async {
          Factory factory = await Factory.fromServer(Map<String, dynamic>.from(item));
          factories.add(factory);
        }).then((value) {
          setState(() {
            isLoadingData = false;
          });
        });
      } else {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              message: response["message"],
              title: "Errors",
            );
          },
        );
      }
    });
  }

  List<Widget> jobItemsWidget() {
    totalTimeTaken = lastEndTime.toLocal().difference(firstStartTime.toLocal()).inSeconds;
    var hr = (timeTaken / 3600).floor();
    var min = ((timeTaken - hr * 3600) / 60).floor();
    var sec = timeTaken - hr * 3600 - min * 60;
    var totalhr = 0;
    var totalmin = 0;
    var totalsec = 0;
    if (jobWeighings.isNotEmpty) {
      totalhr = (totalTimeTaken / 3600).floor();
      totalmin = ((totalTimeTaken - totalhr * 3600) / 60).floor();
      totalsec = totalTimeTaken - totalhr * 3600 - totalmin * 60;
    }
    List<Widget> widgets = [
      Text(
        "Details for Job Code: " + jobCodeController.text,
        style: TextStyle(
          color: themeChanged.value ? foregroundColor : backgroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        ),
      ),
      const Divider(color: Colors.transparent),
      Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 3 - 40,
              height: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Color(0xFFF1DDBF),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 5,
                    color: shadowColor,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: jobWeighings.length.toString(),
                          style: TextStyle(
                            fontSize: 100.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const TextSpan(
                          text: " of ",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: jobItems.length.toString(),
                          style: TextStyle(
                            fontSize: 100.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Items Weighed",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: formHintTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 3 - 40,
              height: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Color(0xFFF1DDBF),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 5,
                    color: shadowColor,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    underIssues.length.toString(),
                    style: TextStyle(
                      fontSize: 100.0,
                      color: formHintTextColor,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(10, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Under Issued Items",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: formHintTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 3 - 40,
              height: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Color(0xFFF1DDBF),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 5,
                    color: shadowColor,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    overIssues.length.toString(),
                    style: TextStyle(
                      fontSize: 100.0,
                      color: formHintTextColor,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(10, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Over Issues Items",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: formHintTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 3 - 40,
              height: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Color(0xFFF1DDBF),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 5,
                    color: shadowColor,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: hr.toString(),
                          style: TextStyle(
                            fontSize: 100.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const TextSpan(
                          text: " hr ",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: min.toString(),
                          style: TextStyle(
                            fontSize: 100.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const TextSpan(
                          text: " min ",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: sec.toString(),
                          style: TextStyle(
                            fontSize: 100.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const TextSpan(
                          text: " s",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Weighing Time Spent",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: formHintTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 3 - 40,
              height: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Color(0xFFF1DDBF),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 5,
                    color: shadowColor,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: totalhr.toString(),
                          style: TextStyle(
                            fontSize: 100.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const TextSpan(
                          text: " hr ",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: totalmin.toString(),
                          style: TextStyle(
                            fontSize: 100.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const TextSpan(
                          text: " min ",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: totalsec.toString(),
                          style: TextStyle(
                            fontSize: 100.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const TextSpan(
                          text: " s",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Total Time Spent",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: formHintTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      const Divider(
        color: Colors.transparent,
        height: 30.0,
      ),
    ];
    for (var jobItem in jobItems) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          child: Text(
            jobItem.material.code + " " + jobItem.material.description,
            style: const TextStyle(
              color: formHintTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      );
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
          child: Text(
            "Weighings: ",
            style: TextStyle(
              fontSize: 18.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: (jobWeighings.containsKey(jobItem.id))
              ? JobWeighingList(jobWeighings: jobWeighings[jobItem.id]!)
              : Text(
                  "No Weighings Found.",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: themeChanged.value ? foregroundColor : backgroundColor,
                  ),
                ),
        ),
      );
      widgets.add(
        const Divider(
          color: Colors.transparent,
          height: 15.0,
        ),
      );
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
          child: Text(
            "Over Issued Items: ",
            style: TextStyle(
              fontSize: 18.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: (overIssues.containsKey(jobItem.id))
              ? OverIssueList(overIssues: overIssues[jobItem.id]!)
              : Text(
                  "No Over Issues Found.",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: themeChanged.value ? foregroundColor : backgroundColor,
                  ),
                ),
        ),
      );
      widgets.add(
        const Divider(
          color: Colors.transparent,
          height: 15.0,
        ),
      );
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
          child: Text(
            "Under Issued Items: ",
            style: TextStyle(
              fontSize: 18.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: (underIssues.containsKey(jobItem.id))
              ? UnderIssueList(underIssues: underIssues[jobItem.id]!)
              : Text(
                  "No Under Issues Found.",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: themeChanged.value ? foregroundColor : backgroundColor,
                  ),
                ),
        ),
      );
    }
    return widgets;
  }

  Widget detailsWidget() {
    return ValueListenableBuilder(
      valueListenable: themeChanged,
      builder: (_, theme, child) {
        return isDataLoaded
            ? jobItems.isEmpty
                ? Text(
                    "No Job Details Found",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: themeChanged.value ? backgroundColor : foregroundColor,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: jobItemsWidget(),
                  )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get Job Details:",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: themeChanged.value ? backgroundColor : foregroundColor,
                    ),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      DropDownWidget(
                        disabled: false,
                        hint: "Select Factory",
                        controller: factoryController,
                        itemList: factories,
                      ),
                      textField(
                        false,
                        jobCodeController,
                        "Job Code",
                        false,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                          elevation: MaterialStateProperty.all<double>(5.0),
                        ),
                        onPressed: () async {
                          String errors = "";
                          jobItemIDs = [];
                          jobItems = [];
                          var factoryID = factoryController.text;
                          var jobCode = jobCodeController.text;

                          if (factoryID.isEmpty || factoryID == "") {
                            errors += "Factory Required\n";
                          }

                          if (jobCode == "" || jobCode.isEmpty) {
                            errors += "Job Code Required.\n";
                          }

                          if (errors.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  message: errors,
                                  title: "Error",
                                );
                              },
                            );
                          } else {
                            setState(() {
                              isLoadingData = true;
                            });
                            Map<String, dynamic> conditions = {
                              "AND": [
                                {
                                  "EQUALS": {
                                    "Field": "job_code",
                                    "Value": jobCode,
                                  },
                                },
                                {
                                  "EQUALS": {
                                    "Field": "factory_id",
                                    "Value": factoryID,
                                  },
                                },
                              ],
                            };
                            await appStore.jobApp.list(conditions).then((value) async {
                              if (value.containsKey("status") && value["status"]) {
                                if (value["payload"].isNotEmpty) {
                                  await Future.value(await Job.fromServer(value["payload"][0])).then((job) async {
                                    await Future.forEach(value["payload"][0]["job_items"], (dynamic item) async {
                                      JobItem jobItem = await JobItem.fromServer(Map<String, dynamic>.from(item));
                                      if (jobItem.material.isWeighed) {
                                        jobItems.add(jobItem);
                                        jobItemIDs.add(jobItem.id);
                                      }
                                    });
                                  }).then((value) async {
                                    await Future.forEach([
                                      await getJobItemWeighings(),
                                      await getJobItemOverIssues(),
                                      await getJobItemUnderIssues(),
                                    ], (element) {});
                                  });
                                }
                              }
                            }).then((value) {
                              setState(() {
                                isDataLoaded = true;
                                isLoadingData = false;
                              });
                            });
                          }
                        },
                        child: checkButton(),
                      ),
                    ],
                  ),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingData
        ? SuperPage(childWidget: loader(context))
        : SuperPage(
            childWidget: buildWidget(
              detailsWidget(),
              context,
              "Job Details",
              () {
                navigationService.pushReplacement(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => const JobWidget(),
                  ),
                );
              },
            ),
          );
  }
}
