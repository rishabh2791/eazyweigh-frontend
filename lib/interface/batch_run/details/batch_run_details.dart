import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/batch_run.dart';
import 'package:eazyweigh/domain/entity/device.dart';
import 'package:eazyweigh/domain/entity/device_data.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BatchRunDetails extends StatefulWidget {
  const BatchRunDetails({Key? key}) : super(key: key);

  @override
  State<BatchRunDetails> createState() => _BatchRunDetailsState();
}

class _BatchRunDetailsState extends State<BatchRunDetails> {
  bool isLoadingData = true;
  bool isDataLoaded = false;
  List<Factory> factories = [];
  List<Device> devices = [];
  List<String> deviceIDs = [];
  List<DateTime> ticks = [];
  Map<String, List<DeviceData>> devicesData = {};
  Map<String, List<DeviceDataPoint>> devicesDataPoints = {};
  late TextEditingController factoryController, jobCodeController;

  @override
  void initState() {
    getFactories();
    factoryController = TextEditingController();
    jobCodeController = TextEditingController();
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

  Widget selectionWidget() {
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
                  "Batch Running Details",
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
                textField(false, jobCodeController, "Job Code", false),
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () async {
                        var jobCode = jobCodeController.text;

                        String errors = "";

                        if (factoryController.text.isEmpty) {
                          errors += "Factory Missing.\n";
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
                              Map<String, dynamic> jobConditions = {
                                "EQUALS": {
                                  "Field": "job_id",
                                  "Value": job.id,
                                }
                              };
                              await appStore.batchRunApp.list(jobConditions).then((batchResponse) async {
                                if (batchResponse.containsKey("status") && batchResponse["status"]) {
                                  if (batchResponse["payload"].isEmpty) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog(
                                          message: "Job " + jobCodeController.text + " not found.",
                                          title: "Errors",
                                        );
                                      },
                                    );
                                  } else {
                                    BatchRun batchRun = BatchRun.fromJSON(batchResponse["payload"][0]);
                                    Map<String, dynamic> deviceDataConditions = {
                                      "AND": [
                                        {
                                          "GREATEREQUAL": {
                                            "Field": "created_at",
                                            "Value": batchRun.startTime.toUtc().toIso8601String().toString().split(".")[0] + "Z",
                                          },
                                        },
                                        {
                                          "LESSEQUAL": {
                                            "Field": "created_at",
                                            "Value": batchRun.endTime.toUtc().toIso8601String().toString().split(".")[0] + "Z",
                                          },
                                        }
                                      ]
                                    };
                                    await appStore.deviceDataApp.list(deviceDataConditions).then((deviceDataResponse) async {
                                      if (deviceDataResponse.containsKey("status") && deviceDataResponse["status"]) {
                                        for (var item in deviceDataResponse["payload"]) {
                                          DeviceData deviceData = DeviceData.fromJSON(item);
                                          if (!ticks.contains(deviceData.createdAt)) {
                                            ticks.add(deviceData.createdAt);
                                          }
                                          if (!deviceIDs.contains(deviceData.deviceID)) {
                                            deviceIDs.add(deviceData.deviceID);
                                          }
                                          if (!devicesData.containsKey(deviceData.deviceID)) {
                                            devicesData[deviceData.deviceID] = [];
                                            devicesDataPoints[deviceData.deviceID] = [];
                                          }
                                          devicesData[deviceData.deviceID]!.add(deviceData);
                                          devicesDataPoints[deviceData.deviceID]!.add(DeviceDataPoint(
                                            timeStamp: deviceData.createdAt,
                                            value: deviceData.value,
                                          ));
                                        }
                                        Map<String, dynamic> deviceConditions = {
                                          "IN": {
                                            "Field": "id",
                                            "Value": deviceIDs,
                                          }
                                        };
                                        await appStore.deviceApp.list(deviceConditions).then((value) {
                                          if (value.containsKey("status") && value["status"]) {
                                            for (var item in value["payload"]) {
                                              Device device = Device.fromJSON(item);
                                              devices.add(device);
                                            }
                                            buildChart();
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
                                          Navigator.of(context).pop();
                                          setState(() {
                                            isDataLoaded = true;
                                          });
                                        });
                                      } else {
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                              message: deviceDataResponse["message"],
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
                                        message: batchResponse["message"],
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

  List<charts.Series<dynamic, DateTime>> buildChart() {
    List<charts.Series<dynamic, DateTime>> series = [];
    devicesDataPoints.forEach((key, values) {
      values.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
      Device thisDevice = devices.firstWhere((element) => element.id == key);
      series.add(
        charts.Series<DeviceDataPoint, DateTime>(
          id: thisDevice.deviceType.description,
          domainFn: (DeviceDataPoint deviceDataPoint, _) => deviceDataPoint.timeStamp.toLocal(),
          measureFn: (DeviceDataPoint deviceDataPoint, _) => deviceDataPoint.value,
          data: values,
          // colorFn: (_, __) => charts.MaterialPalette.gray.shade300,
          // fillColorFn: (_, __) => charts.MaterialPalette.gray.shade300,
        ),
      );
    });
    return series;
  }

  Widget viewWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Running Details for Job: " + jobCodeController.text,
          style: const TextStyle(
            fontSize: 30.0,
            color: menuItemColor,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 200,
          height: MediaQuery.of(context).size.height - 250,
          child: charts.TimeSeriesChart(
            buildChart(),
            animate: true,
            behaviors: [
              charts.SeriesLegend(
                position: charts.BehaviorPosition.start,
                entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.purple.shadeDefault,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
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
              isDataLoaded ? viewWidget() : selectionWidget(),
              context,
              "Batch Run Details",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}

class DeviceDataPoint {
  final DateTime timeStamp;
  final double value;

  DeviceDataPoint({
    required this.timeStamp,
    required this.value,
  });
}
