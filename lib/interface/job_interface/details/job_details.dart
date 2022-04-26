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
      await appStore.jobWeighingApp.list(jobItemID).then(
        (response) {
          if (response.containsKey("status") && response["status"]) {
            for (var item in response["payload"]) {
              JobItemWeighing jobItemWeighing = JobItemWeighing.fromJSON(item);
              if (jobWeighings.containsKey(jobItemID)) {
                jobWeighings[jobItemID]!.add(jobItemWeighing);
              } else {
                jobWeighings[jobItemID] = [jobItemWeighing];
              }
            }
          }
        },
      );
    }
  }

  Future<dynamic> getJobItemOverIssues() async {
    String jobID = jobItems.first.jobID;
    await appStore.overIssueApp.list(jobID).then(
      (response) async {
        if (response.containsKey("status") && response["status"]) {
          for (var item in response["payload"]) {
            OverIssue overIssue = OverIssue.fromJSON(item);
            if (overIssues.containsKey(overIssue.jobItem.id)) {
              overIssues[overIssue.jobItem.id]!
                  .add(HybridOverIssue(job: job, overIssue: overIssue));
            } else {
              overIssues[overIssue.jobItem.id] = [
                HybridOverIssue(job: job, overIssue: overIssue)
              ];
            }
          }
        }
      },
    );
  }

  Future<dynamic> getJobItemUnderIssues() async {
    String jobID = jobItems.first.jobID;
    await appStore.underIssueApp.list(jobID).then(
      (response) async {
        if (response.containsKey("status") && response["status"]) {
          for (var item in response["payload"]) {
            UnderIssue underIssue = UnderIssue.fromJSON(item);
            if (underIssues.containsKey(underIssue.jobItem.id)) {
              underIssues[underIssue.jobItem.id]!
                  .add(HybridUnderIssue(job: job, underIssue: underIssue));
            } else {
              underIssues[underIssue.jobItem.id] = [
                HybridUnderIssue(job: job, underIssue: underIssue)
              ];
            }
          }
        }
      },
    );
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
        for (var item in response["payload"]) {
          Factory fact = Factory.fromJSON(item);
          factories.add(fact);
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
              title: "Errors",
            );
          },
        );
      }
    });
  }

  List<Widget> jobItemsWidget() {
    List<Widget> widgets = [
      Text(
        "Details for Job Code: " + jobCodeController.text,
        style: const TextStyle(
          color: formHintTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        ),
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
        const Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
          child: Text(
            "Weighings: ",
            style: TextStyle(
              fontSize: 18.0,
              color: menuItemColor,
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
                    color: isDarkTheme ? foregroundColor : backgroundColor,
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
        const Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
          child: Text(
            "Over Issued Items: ",
            style: TextStyle(
              fontSize: 18.0,
              color: menuItemColor,
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
                    color: isDarkTheme ? foregroundColor : backgroundColor,
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
        const Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
          child: Text(
            "Under Issued Items: ",
            style: TextStyle(
              fontSize: 18.0,
              color: menuItemColor,
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
                    color: isDarkTheme ? foregroundColor : backgroundColor,
                  ),
                ),
        ),
      );
    }
    return widgets;
  }

  Widget detailsWidget() {
    return isDataLoaded
        ? jobItems.isEmpty
            ? Text(
                "No Job Details Found",
                style: TextStyle(
                  fontSize: 20.0,
                  color: isDarkTheme ? foregroundColor : backgroundColor,
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
                  color: isDarkTheme ? foregroundColor : backgroundColor,
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
                      backgroundColor:
                          MaterialStateProperty.all<Color>(menuItemColor),
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
                        await appStore.jobApp
                            .list(conditions)
                            .then((value) async {
                          if (value.containsKey("status") && value["status"]) {
                            if (value["payload"].isNotEmpty) {
                              job = Job.fromJSON(value["payload"][0]);
                              for (var item in value["payload"][0]
                                  ["job_items"]) {
                                JobItem jobItem = JobItem.fromJSON(item);
                                jobItems.add(jobItem);
                                jobItemIDs.add(jobItem.id);
                              }
                              await Future.forEach([
                                await getJobItemWeighings(),
                                await getJobItemOverIssues(),
                                await getJobItemUnderIssues(),
                              ], (element) {});
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
