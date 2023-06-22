import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job_item_assignment.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/job_assignment_interface/details/list.dart';
import 'package:flutter/material.dart';

class JobAssignmentDetailsWidget extends StatefulWidget {
  const JobAssignmentDetailsWidget({Key? key}) : super(key: key);

  @override
  State<JobAssignmentDetailsWidget> createState() => _JobAssignmentDetailsWidgetState();
}

class _JobAssignmentDetailsWidgetState extends State<JobAssignmentDetailsWidget> {
  bool isLoadingData = true;
  bool isJobItemsLoaded = false;
  List<Factory> factories = [];
  List<JobItemAssignment> jobItemAssignments = [];
  late TextEditingController jobCodeController, factoryController;

  @override
  void initState() {
    jobCodeController = TextEditingController();
    factoryController = TextEditingController();
    getFactories();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  Widget detailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Get Job Details",
          style: TextStyle(
            color: formHintTextColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DropDownWidget(disabled: false, hint: "Factory", controller: factoryController, itemList: factories),
            textField(false, jobCodeController, "Job Code", false),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () async {
                setState(() {
                  isJobItemsLoaded = false;
                  jobItemAssignments = [];
                });
                String errors = "";
                var factoryID = factoryController.text;
                var jobCode = jobCodeController.text;

                if (factoryID == "" || factoryID.isEmpty) {
                  errors += "Facrory Required. \n";
                }

                if (jobCode == "" || jobCode.isEmpty) {
                  errors += "Job Code Required. \n";
                }

                if (errors.isNotEmpty || errors != "") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
                        message: errors,
                        title: "Errors",
                      );
                    },
                  );
                } else {
                  Map<String, dynamic> conditions = {
                    "AND": [
                      {
                        "EQUALS": {
                          "Field": "job_code",
                          "Value": jobCodeController.text.toString(),
                        }
                      },
                      {
                        "EQUALS": {
                          "Field": "factory_id",
                          "Value": factoryID.toString(),
                        }
                      },
                    ],
                  };

                  jobItemAssignments = [];
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return loader(context);
                    },
                  );
                  await appStore.jobApp.list(conditions).then((value) async {
                    if (value.containsKey("status") && value["status"]) {
                      Map<String, dynamic> conditions = {
                        "EQUALS": {
                          "Field": "job_id",
                          "Value": value["payload"][0]["id"],
                        }
                      };
                      await appStore.jobItemApp.get(conditions).then((jobItemsResponse) async {
                        List<String> jobItemIDs = [];
                        if (jobItemsResponse.containsKey("status") && jobItemsResponse["status"]) {
                          for (var item in jobItemsResponse["payload"]) {
                            jobItemIDs.add(item["id"]);
                          }
                          Map<String, dynamic> conditions = {
                            "IN": {
                              "Field": "job_item_id",
                              "Value": jobItemIDs,
                            }
                          };
                          await appStore.jobItemAssignmentApp.list(conditions).then((response) async {
                            if (response.containsKey("status")) {
                              if (response["status"]) {
                                for (var item in response["payload"]) {
                                  JobItemAssignment jobItemAssignment = JobItemAssignment.fromJSON(item);
                                  jobItemAssignments.add(jobItemAssignment);
                                }
                                Navigator.of(context).pop();
                                setState(() {
                                  isJobItemsLoaded = true;
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
                            } else {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "Job Assignment Not Found.",
                                    title: "Errors",
                                  );
                                },
                              );
                            }
                          });
                        }
                      });
                    } else {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomDialog(
                            message: "Job Assignment Not Found.",
                            title: "Errors",
                          );
                        },
                      );
                    }
                  });
                }
              },
              child: checkButton(),
            ),
          ],
        ),
        const Divider(
          color: Colors.transparent,
        ),
        isJobItemsLoaded
            ? jobItemAssignments.isEmpty
                ? const Text(
                    "No Job Item Assignment Found",
                    style: TextStyle(
                      color: formHintTextColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Job Item Assigned To:",
                        style: TextStyle(
                          color: formHintTextColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      JobAssignmentListWidget(jobItemAssignments: jobItemAssignments)
                    ],
                  )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeChanged,
      builder: (_, theme, child) {
        return isLoadingData
            ? SuperPage(
                childWidget: loader(context),
              )
            : SuperPage(
                childWidget: buildWidget(
                  detailsWidget(),
                  context,
                  "Job Assignment Details",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
