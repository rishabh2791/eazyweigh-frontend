import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/under_issue_interface/create/job_items_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';

class UnderIssueCreateWidget extends StatefulWidget {
  const UnderIssueCreateWidget({Key? key}) : super(key: key);

  @override
  State<UnderIssueCreateWidget> createState() => _UnderIssueCreateWidgetState();
}

class _UnderIssueCreateWidgetState extends State<UnderIssueCreateWidget> {
  bool isLoadingData = true;
  bool isJobItemsLoaded = false;
  List<Factory> factories = [];
  List<JobItem> jobItems = [];
  Map<String, double> underIssueQty = {};
  late TextEditingController factoryController, jobCodeController;

  @override
  void initState() {
    getDetails();
    factoryController = TextEditingController();
    jobCodeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDetails() async {
    await Future.forEach([await getFactories()], (value) {
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Widget homeWidget() {
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
            DropDownWidget(
                disabled: false,
                hint: "Factory",
                controller: factoryController,
                itemList: factories),
            textField(false, jobCodeController, "Job Code", false),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () async {
                setState(() {
                  isJobItemsLoaded = false;
                  jobItems = [];
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

                  jobItems = [];
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return loader(context);
                    },
                  );
                  await appStore.jobApp.list(conditions).then((response) async {
                    if (response["status"]) {
                      if (response["payload"].length == 0) {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const CustomDialog(
                              message: "Job Not Found.",
                              title: "Errors",
                            );
                          },
                        );
                      } else {
                        if (response["payload"][0]["complete"]) {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                message: "Job Complete.",
                                title: "Errors",
                              );
                            },
                          );
                        } else {
                          String jobID = response["payload"][0]["id"];
                          await appStore.jobItemApp.get(jobID, {}).then(
                            (value) async {
                              if (value["status"]) {
                                for (var item in value["payload"]) {
                                  JobItem jobItem = JobItem.fromJSON(item);
                                  jobItems.add(jobItem);
                                  underIssueQty[jobItem.id] = 0;
                                }
                                await appStore.underIssueApp
                                    .list(jobItems[0].jobID)
                                    .then((value) {
                                  if (value.containsKey("status")) {
                                    if (value["status"]) {
                                      for (var item in value["payload"]) {
                                        underIssueQty[item["job_item_id"]] =
                                            double.parse(
                                                    item["actual"].toString()) -
                                                double.parse(item["required"]
                                                    .toString());
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
                                            message: value["message"],
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
                                          message: "Unable to connect.",
                                          title: "Errors",
                                        );
                                      },
                                    );
                                  }
                                });
                              } else {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                      message: value["message"],
                                      title: "Errors",
                                    );
                                  },
                                );
                              }
                            },
                          ).then((value) {
                            setState(() {
                              isJobItemsLoaded = true;
                            });
                          });
                        }
                      }
                    } else {
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
              },
              child: checkButton(),
            ),
            const VerticalDivider(),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () async {
                List<Map<String, dynamic>> underIssued = [];
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return loader(context);
                  },
                );
                underIssueQty.forEach((key, value) {
                  if (value != 0) {
                    JobItem jobItem = getJobItem(key);
                    var underIssue = {
                      "job_item_id": key,
                      "unit_of_measurement_id": jobItem.uom.id,
                      "required": jobItem.requiredWeight,
                      "actual": jobItem.actualWeight == 0
                          ? jobItem.requiredWeight + value
                          : jobItem.actualWeight + value,
                    };
                    underIssued.add(underIssue);
                  }
                });
                await appStore.underIssueApp
                    .createMultiple(underIssued)
                    .then((response) {
                  Navigator.of(context).pop();
                  if (response.containsKey("status")) {
                    if (response["status"]) {
                      int created = response["payload"]["models"].length;
                      int notCreated = response["payload"]["errors"].length;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            message: "Created " +
                                created.toString() +
                                " under issues. Error in creating " +
                                notCreated.toString() +
                                " under issues.",
                            title: "Info",
                          );
                        },
                      ).then((value) {
                        Navigator.of(context).pop();
                      });
                    } else {
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialog(
                          message: "Unable to Connect",
                          title: "Errors",
                        );
                      },
                    );
                  }
                });
              },
              child: clearButton(),
            ),
          ],
        ),
        const Divider(),
        isJobItemsLoaded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Select Items to Under Issue",
                    style: TextStyle(
                      color: formHintTextColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Container(),
        isJobItemsLoaded ? const Divider() : Container(),
        isJobItemsLoaded
            ? JobItemsListWidget(
                jobItems: jobItems,
                underIssueQty: underIssueQty,
              )
            : Container(),
      ],
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

  dynamic getJobItem(String id) {
    for (var jobItem in jobItems) {
      if (jobItem.id == id) {
        return jobItem;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingData
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: buildWidget(
              homeWidget(),
              context,
              "Under Issue Material",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
