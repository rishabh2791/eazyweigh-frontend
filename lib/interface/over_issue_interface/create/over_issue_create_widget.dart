import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/over_issue_interface/create/job_items_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class OverIssueCreateWidget extends StatefulWidget {
  const OverIssueCreateWidget({Key? key}) : super(key: key);

  @override
  State<OverIssueCreateWidget> createState() => _OverIssueCreateWidgetState();
}

class _OverIssueCreateWidgetState extends State<OverIssueCreateWidget> {
  late Job runningJob;
  bool isLoadingData = true;
  bool isJobItemsLoaded = false;
  List<Factory> factories = [];
  List<JobItem> jobItems = [];
  Map<String, double> overIssueQty = {};
  late TextEditingController factoryController, jobCodeController, materialCodeController;

  @override
  void initState() {
    getDetails();
    factoryController = TextEditingController();
    jobCodeController = TextEditingController();
    materialCodeController = TextEditingController();
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    TextEditingController overIssueController = TextEditingController();
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Over Issue Quantity'),
            content: Column(
              children: [
                TextField(
                  controller: materialCodeController,
                  decoration: const InputDecoration(hintText: "Over Issue Material"),
                ),
                TextField(
                  controller: overIssueController,
                  decoration: const InputDecoration(hintText: "Over Issue Quantity"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Issue',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                onPressed: () async {
                  int errors = 0;
                  var qty = overIssueController.text;
                  var materialCode = materialCodeController.text;
                  if (materialCode.isEmpty) {
                    errors += 1;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialog(
                          message: "Material Required",
                          title: "Errors",
                        );
                      },
                    );
                  }
                  if (qty == "" || qty.isEmpty) {
                    errors += 1;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialog(
                          message: "Quantity Required",
                          title: "Errors",
                        );
                      },
                    );
                  }
                  if (errors == 0) {
                    Map<String, dynamic> conditions = {
                      "EQUALS": {
                        "Field": "code",
                        "Value": materialCodeController.text,
                      }
                    };
                    await appStore.materialApp.list(conditions).then((materialResponse) async {
                      if (materialResponse.containsKey("status") && materialResponse["status"]) {
                        if (materialResponse["payload"].isNotEmpty) {
                          double weight = double.parse(overIssueController.text);
                          Mat mat = Mat.fromJSON(materialResponse["payload"][0]);
                          JobItem additionalJobItem = JobItem(
                            actualWeight: 0,
                            assigned: false,
                            complete: false,
                            createdAt: DateTime.now().toUtc(),
                            createdBy: currentUser,
                            id: const Uuid().v4(),
                            jobID: runningJob.id,
                            lowerBound: weight * 0.99,
                            material: mat,
                            requiredWeight: 0,
                            uom: mat.uom,
                            updatedAt: DateTime.now().toUtc(),
                            updatedBy: currentUser,
                            upperBound: weight * 1.01,
                            verified: false,
                            added: false,
                          );
                          Map<String, dynamic> data = {
                            "material_id": mat.id,
                            "job_id": runningJob.id,
                            "unit_of_measurement_id": mat.uom.id,
                            "created_by_username": currentUser.username,
                            "updated_by_username": currentUser.username,
                          };
                          await appStore.jobItemApp.create(data).then((response) {
                            if (response.containsKey("status") && response["status"]) {
                              additionalJobItem.id = response["payload"]["id"];
                              setState(() {
                                jobItems.add(additionalJobItem);
                                overIssueQty[additionalJobItem.id] = weight;
                              });
                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                    message: "Unable to add Material: " + materialCode,
                                    title: "Errors",
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
                                message: "Unable to fetch Material: " + materialCode,
                                title: "Errors",
                              );
                            },
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              message: "Unable to fetch Material: " + materialCode,
                              title: "Errors",
                            );
                          },
                        );
                      }
                    });
                  }
                },
              ),
            ],
          );
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
                        runningJob = Job.fromJSON(response["payload"][0]);
                        Map<String, dynamic> conditions = {
                          "EQUALS": {
                            "Field": "job_id",
                            "Value": response["payload"][0]["id"],
                          }
                        };
                        await appStore.jobItemApp.get(conditions).then(
                          (value) async {
                            if (value["status"]) {
                              for (var item in value["payload"]) {
                                JobItem jobItem = JobItem.fromJSON(item);
                                jobItems.add(jobItem);
                                overIssueQty[jobItem.id] = 0;
                              }
                              Map<String, dynamic> conditions = {
                                "EQUALS": {
                                  "Field": "job_id",
                                  "Value": jobItems[0].jobID,
                                }
                              };
                              await appStore.overIssueApp.list(conditions).then((value) {
                                if (value.containsKey("status")) {
                                  if (value["status"]) {
                                    for (var item in value["payload"]) {
                                      overIssueQty[item["job_item_id"]] = double.parse(item["actual"].toString()) - double.parse(item["required"].toString());
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
              child: genericButton(Icons.get_app, "Get Details"),
            ),
            const VerticalDivider(
              color: Colors.transparent,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () async {
                List<Map<String, dynamic>> overIssued = [];
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return loader(context);
                  },
                );
                overIssueQty.forEach((key, value) {
                  if (value != 0) {
                    JobItem jobItem = getJobItem(key);
                    var overIssue = {
                      "job_item_id": key,
                      "unit_of_measurement_id": jobItem.uom.id,
                      "required": jobItem.requiredWeight,
                      "actual": jobItem.actualWeight == 0 ? jobItem.requiredWeight + value : jobItem.actualWeight + value,
                    };
                    overIssued.add(overIssue);
                  }
                });
                await appStore.overIssueApp.createMultiple(overIssued).then((response) {
                  Navigator.of(context).pop();
                  if (response.containsKey("status")) {
                    if (response["status"]) {
                      int created = response["payload"]["models"].length;
                      int notCreated = response["payload"]["errors"].length;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            message: "Created " + created.toString() + " over issues. Error in creating " + notCreated.toString() + " over issues.",
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
              child: checkButton(),
            ),
          ],
        ),
        const Divider(
          color: Colors.transparent,
        ),
        isJobItemsLoaded
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Items to Over Issue",
                    style: TextStyle(
                      color: formHintTextColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Container(),
        isJobItemsLoaded
            ? const Divider(
                color: Colors.transparent,
              )
            : Container(),
        isJobItemsLoaded
            ? TextButton(
                onPressed: () {
                  _displayTextInputDialog(context);
                },
                child: const Text(
                  "Add Another",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container(),
        isJobItemsLoaded
            ? const Divider(
                color: Colors.transparent,
              )
            : Container(),
        isJobItemsLoaded
            ? JobItemsListWidget(
                jobItems: jobItems,
                overIssueQty: overIssueQty,
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
                  homeWidget(),
                  context,
                  "Over Issue Material",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
