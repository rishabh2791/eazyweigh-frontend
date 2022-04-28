import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/shift_schedule.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/job_assignment_interface/create/list.dart';
import 'package:flutter/material.dart';

class JobAssignmentCreateWidget extends StatefulWidget {
  const JobAssignmentCreateWidget({Key? key}) : super(key: key);

  @override
  State<JobAssignmentCreateWidget> createState() =>
      _JobAssignmentCreateWidgetState();
}

class _JobAssignmentCreateWidgetState extends State<JobAssignmentCreateWidget> {
  bool isLoadingData = true;
  bool isJobItemsLoaded = false;
  List<Factory> factories = [];
  List<JobItem> jobItems = [];
  List<ShiftSchedule> shiftSchedules = [];
  late TextEditingController jobCodeController,
      factoryController,
      shiftScheduleController;

  @override
  void initState() {
    getFactories();
    jobCodeController = TextEditingController();
    factoryController = TextEditingController();
    shiftScheduleController = TextEditingController();
    super.initState();
    factoryController.addListener(getShiftSchedule);
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

  Future<dynamic> getShiftSchedule() async {
    shiftSchedules = [];
    setState(() {
      isLoadingData = true;
    });
    DateTime today = DateTime.now();
    Map<String, dynamic> conditions = {
      "AND": [
        {
          "GREATEREQUAL": {
            "Field": "date",
            "Value": DateTime(today.year, today.month, today.day).toString(),
          },
        },
        {
          "LESSEQUAL": {
            "Field": "date",
            "Value": DateTime(today.year, today.month, today.day)
                .add(const Duration(days: 7))
                .toString(),
          },
        },
      ],
    };
    await appStore.shiftScheduleApp.list(conditions).then((value) async {
      if (value["status"]) {
        for (var item in value["payload"]) {
          if (item["user"]["user_role"]["role"] == "Operator") {
            ShiftSchedule shiftSchedule = ShiftSchedule.fromJSON(item);
            shiftSchedules.add(shiftSchedule);
          }
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
              message: value["message"],
              title: "Errors",
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
          ],
        ),
        const Divider(
          color: Colors.transparent,
        ),
        isJobItemsLoaded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Items to Assign To:",
                    style: TextStyle(
                      color: formHintTextColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      DropDownWidget(
                        disabled: false,
                        hint: "Select Weigher",
                        controller: shiftScheduleController,
                        itemList: shiftSchedules,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(menuItemColor),
                          elevation: MaterialStateProperty.all<double>(5.0),
                        ),
                        onPressed: () async {
                          List<Map<String, dynamic>> jobItemsAssigned = [];
                          String shiftSchedule = shiftScheduleController.text;
                          for (var jobItem in jobItems) {
                            if (jobItem.selected) {
                              Map<String, dynamic> jobItemAssigned = {
                                "job_item_id": jobItem.id,
                                "shift_schedule_id": shiftSchedule,
                              };
                              jobItemsAssigned.add(jobItemAssigned);
                            }
                          }

                          if (shiftScheduleController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialog(
                                  message: "Assignee Required",
                                  title: "Errors",
                                );
                              },
                            );
                          } else {
                            if (jobItemsAssigned.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message:
                                        "Please Select at least one Job Item",
                                    title: "Errors",
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return loader(context);
                                },
                              );
                              await appStore.jobItemAssignmentApp
                                  .createMultiple(jobItemsAssigned)
                                  .then(
                                (response) async {
                                  if (response["status"]) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const CustomDialog(
                                          message: "Job Items Assigned.",
                                          title: "Info",
                                        );
                                      },
                                    );
                                    setState(() {
                                      isJobItemsLoaded = false;
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
                                },
                              );
                            }
                          }
                        },
                        child: checkButton(),
                      ),
                    ],
                  ),
                ],
              )
            : Container(),
        isJobItemsLoaded
            ? const Divider(
                color: Colors.transparent,
              )
            : Container(),
        isJobItemsLoaded ? JobItemsListWidget(jobItems: jobItems) : Container(),
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
                  "Assign Job",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
