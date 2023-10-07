import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/date_picker/date_picker.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/time_picker/time_picker.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BatchRunCreateWidget extends StatefulWidget {
  const BatchRunCreateWidget({Key? key}) : super(key: key);

  @override
  State<BatchRunCreateWidget> createState() => _BatchRunCreateWidgetState();
}

class _BatchRunCreateWidgetState extends State<BatchRunCreateWidget> {
  bool isLoadingData = true;
  bool isScanning = false;
  List<Factory> factories = [];
  List<Vessel> vessels = [];
  late TextEditingController factoryController, vesselController, jobCodeController, startDateController, startTimeController, endDateController, endTimeController;

  @override
  void initState() {
    factoryController = TextEditingController();
    vesselController = TextEditingController();
    jobCodeController = TextEditingController();
    startDateController = TextEditingController();
    startTimeController = TextEditingController();
    endDateController = TextEditingController();
    endTimeController = TextEditingController();
    factoryController.addListener(getFactoryVessels);
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
        factories.sort((a, b) => a.name.compareTo(b.name));
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

  Future<dynamic> getFactoryVessels() async {
    setState(() {
      isLoadingData = true;
    });
    vessels = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryController.text,
      }
    };
    await appStore.vesselApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          Vessel vessel = Vessel.fromJSON(item);
          vessels.add(vessel);
        }
        vessels.sort((a, b) => a.name.compareTo(b.name));
      }
    }).then((value) {
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Widget operatorCreateWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Start Batch",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Factory",
                  controller: factoryController,
                  itemList: factories,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Vessel",
                  controller: vesselController,
                  itemList: vessels,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: textField(false, jobCodeController, "Job Code", false),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () {
                        setState(() {
                          isScanning = true;
                        });
                      },
                      child: scanButton(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () async {
                        Map<String, dynamic> postData = {};
                        var vesselID = vesselController.text;
                        var jobCode = jobCodeController.text;

                        String errors = "";

                        if (factoryController.text.isEmpty) {
                          errors += "Factory Missing.\n";
                        }

                        if (vesselID.isEmpty) {
                          errors += "Vessel Missing.\n";
                        } else {
                          postData["vessel_id"] = vesselID;
                        }

                        if (jobCode.isEmpty) {
                          errors += "Job Code Missing.\n";
                        }

                        if (errors.isNotEmpty) {
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
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return loader(context);
                            },
                          );

                          Map<String, dynamic> conditions = {
                            "AND": [
                              {
                                "EQUALS": {
                                  "Field": "job_code",
                                  "Value": jobCode,
                                }
                              },
                              {
                                "EQUALS": {
                                  "Field": "factory_id",
                                  "Value": factoryController.text,
                                }
                              },
                            ]
                          };
                          await appStore.jobApp.list(conditions).then((value) async {
                            if (value.containsKey("status") && value["status"]) {
                              Job job = Job.fromJSON(value["payload"][0]);
                              postData["job_id"] = job.id;
                              var now = DateTime.now().toUtc();
                              String month = now.month < 10 ? "0" + now.month.toString() : now.month.toString();
                              String day = now.day < 10 ? "0" + now.day.toString() : now.day.toString();
                              String hour = now.hour < 10 ? "0" + now.hour.toString() : now.hour.toString();
                              String minute = now.minute < 10 ? "0" + now.minute.toString() : now.minute.toString();
                              String second = now.second < 10 ? "0" + now.second.toString() : now.second.toString();
                              postData["start_time"] = now.year.toString() + "-" + month + "-" + day + "T" + hour + ":" + minute + ":" + second + "Z";
                              await appStore.batchRunApp.create(postData).then((response) async {
                                if (response["status"]) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialog(
                                        message: "Batch Started",
                                        title: "Info",
                                      );
                                    },
                                  );
                                  factoryController.text = "";
                                  vesselController.text = "";
                                  jobCodeController.text = "";
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
                      },
                      child: checkButton(),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () {
                        factoryController.text = "";
                        vesselController.text = "";
                        jobCodeController.text = "";
                      },
                      child: clearButton(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productionManagerCreateWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Start Batch",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Factory",
                  controller: factoryController,
                  itemList: factories,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Vessel",
                  controller: vesselController,
                  itemList: vessels,
                ),
                DatePickerWidget(
                  dateController: startDateController,
                  hintText: "Start Date",
                  labelText: "Start Date",
                ),
                TimePickerWidget(
                  dateController: startTimeController,
                  hintText: "Start Time",
                  labelText: "Start Time",
                ),
                DatePickerWidget(
                  dateController: endDateController,
                  hintText: "End Date",
                  labelText: "End Date",
                ),
                TimePickerWidget(
                  dateController: endTimeController,
                  hintText: "End Time",
                  labelText: "End Time",
                ),
                textField(false, jobCodeController, "Job Code", false),
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () async {
                        Map<String, dynamic> postData = {};
                        var vesselID = vesselController.text;
                        var jobCode = jobCodeController.text;
                        var startDate = startDateController.text;
                        var startTime = startTimeController.text;
                        var endDate = endDateController.text;
                        var endTime = endTimeController.text;

                        String errors = "";

                        if (factoryController.text.isEmpty) {
                          errors += "Factory Missing.\n";
                        }

                        if (vesselID.isEmpty) {
                          errors += "Vessel Missing.\n";
                        } else {
                          postData["vessel_id"] = vesselID;
                        }

                        if (jobCode.isEmpty) {
                          errors += "Job Code Missing.\n";
                        }

                        if (startDate.isEmpty) {
                          errors += "Start Date Missing.\n";
                        }

                        if (startTime.isEmpty) {
                          errors += "Start Time Missing.\n";
                        }

                        if (endDate.isEmpty) {
                          errors += "End Time Missing.\n";
                        }

                        if (endTime.isEmpty) {
                          errors += "End Time Missing.\n";
                        }

                        if (errors.isNotEmpty) {
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
                          var time = ((startTime).split("(")[1]).split(")")[0];
                          int hours = int.parse(time.split(":")[0].toString());
                          int minutes = int.parse(time.split(":")[1].toString());
                          var startDateTime =
                              DateTime(int.parse(startDate.split("-")[0].toString()), int.parse(startDate.split("-")[1].toString()), int.parse(startDate.split("-")[2].toString()), hours, minutes);

                          time = ((endTime).split("(")[1]).split(")")[0];
                          hours = int.parse(time.split(":")[0].toString());
                          minutes = int.parse(time.split(":")[1].toString());
                          var endDateTime =
                              DateTime(int.parse(endDate.split("-")[0].toString()), int.parse(endDate.split("-")[1].toString()), int.parse(endDate.split("-")[2].toString()), hours, minutes);

                          if (startDateTime.difference(endDateTime).inSeconds > 0) {
                            errors += "Start Date & Time can not be later than End Date & Time.";
                          }

                          if (errors.isNotEmpty) {
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
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return loader(context);
                              },
                            );

                            Map<String, dynamic> runningBatchConditions = {
                              "AND": [
                                {
                                  "EQUALS": {
                                    "Field": "vessel_id",
                                    "Value": vesselID,
                                  }
                                },
                                {
                                  "OR": [
                                    {
                                      "BETWEEN": {
                                        "Field": "start_time",
                                        "LowerValue": startDateTime.toUtc().toIso8601String().toString().split(".")[0] + "Z",
                                        "HigherValue": endDateTime.toUtc().toIso8601String().toString().split(".")[0] + "Z",
                                      }
                                    },
                                    {
                                      "BETWEEN": {
                                        "Field": "end_time",
                                        "LowerValue": startDateTime.toUtc().toIso8601String().toString().split(".")[0] + "Z",
                                        "HigherValue": endDateTime.toUtc().toIso8601String().toString().split(".")[0] + "Z",
                                      }
                                    },
                                  ]
                                },
                              ],
                            };

                            await appStore.batchRunApp.list(runningBatchConditions).then((batchRunResponse) async {
                              if (batchRunResponse.containsKey("status") && batchRunResponse["status"]) {
                                if (batchRunResponse["payload"].isNotEmpty) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialog(
                                        message: "A Batch is already running.",
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
                                          "Value": jobCode,
                                        }
                                      },
                                      {
                                        "EQUALS": {
                                          "Field": "factory_id",
                                          "Value": factoryController.text,
                                        }
                                      },
                                    ]
                                  };

                                  Map<String, dynamic> currentBatchCondition = {
                                    "AND": [
                                      {
                                        "EQUALS": {
                                          "Field": "vessel_id",
                                          "Value": vesselID,
                                        }
                                      },
                                      {
                                        "IS": {
                                          "Field": "end_time",
                                          "Value": "NULL",
                                        }
                                      },
                                    ],
                                  };

                                  await appStore.jobApp.list(conditions).then((value) async {
                                    if (value.containsKey("status") && value["status"]) {
                                      if (value["payload"].isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const CustomDialog(
                                              message: "No Job Found",
                                              title: "Errors",
                                            );
                                          },
                                        );
                                      } else {
                                        Job job = Job.fromJSON(value["payload"][0]);
                                        postData["job_id"] = job.id;

                                        postData["start_time"] = startDateTime.toUtc().toIso8601String().toString().split(".")[0] + "Z";
                                        postData["end_time"] = endDateTime.toUtc().toIso8601String().toString().split(".")[0] + "Z";

                                        await appStore.batchRunApp.createSuper(postData).then((response) async {
                                          if (response["status"]) {
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const CustomDialog(
                                                  message: "Batch Run Details Updated",
                                                  title: "Info",
                                                );
                                              },
                                            );
                                            factoryController.text = "";
                                            vesselController.text = "";
                                            jobCodeController.text = "";
                                            startDateController.text = "";
                                            startTimeController.text = "";
                                            endDateController.text = "";
                                            endTimeController.text = "";
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
                              } else {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                      message: batchRunResponse["message"],
                                      title: "Errors",
                                    );
                                  },
                                );
                              }
                            });
                          }
                        }
                      },
                      child: checkButton(),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () {
                        factoryController.text = "";
                        vesselController.text = "";
                        jobCodeController.text = "";
                      },
                      child: clearButton(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
              isScanning
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width - 50,
                      child: MobileScanner(
                        controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.normal,
                          facing: CameraFacing.back,
                        ),
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          // final Uint8List? image = capture.image;
                          for (final barcode in barcodes) {
                            debugPrint('Barcode found! ${barcode.rawValue}');
                            Map<String, dynamic> scannerData = jsonDecode(barcode.rawValue.toString().replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\""));
                            String jobCode = scannerData["job_code"];
                            jobCodeController.text = jobCode;
                          }
                          setState(() {
                            isScanning = false;
                          });
                        },
                      ),
                    )
                  : currentUser.userRole.role == "Superuser" || currentUser.userRole.role == "Production Manager" || currentUser.userRole.role == "Administrator"
                      ? productionManagerCreateWidget()
                      : operatorCreateWidget(),
              context,
              "Start Batch",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
