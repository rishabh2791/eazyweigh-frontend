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
  State<JobAssignmentCreateWidget> createState() => _JobAssignmentCreateWidgetState();
}

class _JobAssignmentCreateWidgetState extends State<JobAssignmentCreateWidget> {
  bool isLoadingData = true;
  bool isJobItemsLoaded = false;
  List<Factory> factories = [];
  List<JobItem> jobItems = [];
  List<ShiftSchedule> shiftSchedules = [];
  late TextEditingController jobCodeController, factoryController, shiftScheduleController;

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
            "Value": DateTime(today.year, today.month, today.day).add(const Duration(days: 7)).toString(),
          },
        },
      ],
    };
    await appStore.shiftScheduleApp.list(conditions).then((value) async {
      if (value["status"]) {
        await Future.forEach(value["payload"], (dynamic item) async {
          ShiftSchedule shiftSchedule = await ShiftSchedule.fromServer(Map<String, dynamic>.from(item));
          shiftSchedules.add(shiftSchedule);
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
                          Map<String, dynamic> conditions = {
                            "EQUALS": {
                              "Field": "job_id",
                              "Value": response["payload"][0]["id"],
                            }
                          };
                          await appStore.jobItemApp.get(conditions).then((value) async {
                            if (value["status"]) {
                              await Future.forEach(value["payload"], (dynamic item) async {
                                JobItem jobItem = await JobItem.fromServer(Map<String, dynamic>.from(item));
                                jobItems.add(jobItem);
                              }).then((value) {
                                setState(() {
                                  isJobItemsLoaded = true;
                                });
                                Navigator.of(context).pop();
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
                          }).then((value) {
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
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                          elevation: MaterialStateProperty.all<double>(5.0),
                        ),
                        onPressed: () {
                          for (var jobItem in jobItems) {
                            jobItem.selected = true;
                          }
                          setState(() {});
                        },
                        child: const Tooltip(
                          decoration: BoxDecoration(
                            color: foregroundColor,
                          ),
                          textStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                          message: "Select All",
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: Icon(
                              Icons.select_all,
                              color: backgroundColor,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                      DropDownWidget(
                        disabled: false,
                        hint: "Select Weigher",
                        controller: shiftScheduleController,
                        itemList: shiftSchedules,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
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
                                    message: "Please Select at least one Job Item",
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
                              await appStore.jobItemAssignmentApp.createMultiple(jobItemsAssigned).then(
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
                      const VerticalDivider(
                        color: Colors.transparent,
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
