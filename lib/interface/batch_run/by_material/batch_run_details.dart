import 'dart:math';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/batch_run.dart';
import 'package:eazyweigh/domain/entity/device.dart';
import 'package:eazyweigh/domain/entity/device_data.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
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
  Map<String, List<DateTime>> ticks = {};
  Map<String, Map<String, double>> maxValues = {};
  Map<String, Map<String, int>> colours = {};
  List<Job> jobs = [];
  Map<String, Map<String, List<DeviceData>>> devicesData = {};
  Map<String, Map<String, List<DeviceDataPoint>>> devicesDataPoints = {};
  late TextEditingController factoryController, skuCodeController;
  bool viewScaled = true;

  @override
  void initState() {
    getFactories();
    factoryController = TextEditingController();
    skuCodeController = TextEditingController();
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
                  "Batch Run Details",
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
                textField(false, skuCodeController, "Material Code", false),
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () async {
                        var skuCode = skuCodeController.text;

                        String errors = "";

                        if (factoryController.text.isEmpty) {
                          errors += "Factory Missing.\n";
                        }

                        if (skuCode.isEmpty) {
                          errors += "Material Code Missing.\n";
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
                                  "Field": "code",
                                  "Value": skuCode,
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
                          await appStore.materialApp.list(conditions).then((value) async {
                            if (value.containsKey("status") && value["status"]) {
                              Mat material = Mat.fromJSON(value["payload"][0]);
                              Map<String, dynamic> skuConditions = {
                                "EQUALS": {
                                  "Field": "material_id",
                                  "Value": material.id,
                                }
                              };
                              await appStore.jobApp.list(skuConditions).then((jobResponse) async {
                                if (jobResponse.containsKey("status") && jobResponse["status"]) {
                                  if (jobResponse["payload"].isEmpty) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const CustomDialog(
                                          message: "No Data FOund",
                                          title: "Errors",
                                        );
                                      },
                                    );
                                  } else {
                                    for (var item in jobResponse["payload"]) {
                                      Job job = Job.fromJSON(item);
                                      jobs.add(job);
                                    }
                                    jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                                    jobs = jobs.take(max(10, jobs.length)).toList();
                                    await Future.forEach(jobs, (Job currentJob) async {
                                      Map<String, dynamic> jobConditions = {
                                        "EQUALS": {
                                          "Field": "job_id",
                                          "Value": currentJob.id,
                                        }
                                      };
                                      await appStore.batchRunApp.list(jobConditions).then((batchResponse) async {
                                        if (batchResponse.containsKey("status") && batchResponse["status"] && batchResponse["payload"].isNotEmpty) {
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
                                                if (!ticks.containsKey(currentJob.jobCode)) {
                                                  ticks[currentJob.jobCode] = [];
                                                }
                                                if (!ticks[currentJob.jobCode]!.contains(deviceData.createdAt)) {
                                                  ticks[currentJob.jobCode]!.add(deviceData.createdAt);
                                                }
                                                if (!deviceIDs.contains(deviceData.deviceID)) {
                                                  deviceIDs.add(deviceData.deviceID);
                                                }
                                                if (!devicesData.containsKey(currentJob.jobCode)) {
                                                  devicesData[currentJob.jobCode] = {};
                                                  devicesDataPoints[currentJob.jobCode] = {};
                                                  colours[currentJob.jobCode] = {};
                                                }
                                                if (!devicesData[currentJob.jobCode]!.containsKey(deviceData.deviceID)) {
                                                  devicesData[currentJob.jobCode]![deviceData.deviceID] = [];
                                                  devicesDataPoints[currentJob.jobCode]![deviceData.deviceID] = [];
                                                }
                                                devicesData[currentJob.jobCode]![deviceData.deviceID]!.add(deviceData);
                                                devicesDataPoints[currentJob.jobCode]![deviceData.deviceID]!.add(
                                                  DeviceDataPoint(
                                                    timeStamp: deviceData.createdAt,
                                                    value: deviceData.value,
                                                  ),
                                                );
                                                if (!maxValues.containsKey(currentJob.jobCode)) {
                                                  maxValues[currentJob.jobCode] = {};
                                                }
                                                if (maxValues[currentJob.jobCode]!.containsKey(deviceData.deviceID)) {
                                                  if (deviceData.value > (maxValues[currentJob.jobCode]![deviceData.deviceID] ?? 1)) {
                                                    maxValues[currentJob.jobCode]![deviceData.deviceID] = deviceData.value;
                                                  }
                                                } else {
                                                  maxValues[currentJob.jobCode]![deviceData.deviceID] = deviceData.value;
                                                }
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
                                                    colours[currentJob.jobCode]![device.id] = device.deviceType.colour;
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
                                              }).then((value) {
                                                if (devicesData.containsKey(currentJob.jobCode)) {
                                                  Map<String, List<DeviceDataPoint>> finalDeviceDataPoints = {};
                                                  devicesDataPoints[currentJob.jobCode]!.forEach((key, value) {
                                                    String deviceName = devices.firstWhere((element) => element.id == key).deviceType.description;
                                                    finalDeviceDataPoints[deviceName] = value;
                                                  });
                                                  devicesDataPoints[currentJob.jobCode] = finalDeviceDataPoints;
                                                  Map<String, double> finalMaxValues = {};
                                                  maxValues[currentJob.jobCode]!.forEach((key, value) {
                                                    String deviceName = devices.firstWhere((element) => element.id == key).deviceType.description;
                                                    finalMaxValues[deviceName] = value;
                                                  });
                                                  maxValues[currentJob.jobCode] = finalMaxValues;
                                                  Map<String, int> finalColour = {};
                                                  colours[currentJob.jobCode]!.forEach((key, value) {
                                                    String deviceName = devices.firstWhere((element) => element.id == key).deviceType.description;
                                                    finalColour[deviceName] = value;
                                                  });
                                                  colours[currentJob.jobCode] = finalColour;
                                                  devicesDataPoints = Map.fromEntries(devicesDataPoints.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
                                                }
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
                                      });
                                    }).then((value) {
                                      setState(() {
                                        isLoadingData = false;
                                        isDataLoaded = true;
                                      });
                                    });
                                  }
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
                        skuCodeController.text = "";
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

  List<charts.Series<dynamic, DateTime>> buildChart(String jobCode) {
    List<charts.Series<dynamic, DateTime>> series = [];
    devicesDataPoints[jobCode]!.forEach((key, values) {
      values.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
      series.add(
        charts.Series<DeviceDataPoint, DateTime>(
          id: key,
          domainFn: (DeviceDataPoint deviceDataPoint, _) => deviceDataPoint.timeStamp.toLocal(),
          measureFn: (DeviceDataPoint deviceDataPoint, _) => viewScaled
              ? deviceDataPoint.value < 0
                  ? 0
                  : deviceDataPoint.value / (maxValues[jobCode]![key] ?? 1)
              : deviceDataPoint.value,
          data: values,
          seriesColor: charts.ColorUtil.fromDartColor(Color(colours[jobCode]![key] ?? 0xFFFFFFFF)),
        ),
      );
    });
    return series;
  }

  List<Widget> chartWidget() {
    List<Widget> widgets = [
      Text(
        "Running Details for Material: " + skuCodeController.text,
        style: const TextStyle(
          fontSize: 30.0,
          color: menuItemColor,
        ),
      ),
      Row(
        children: [
          Container(
            height: 60.0,
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: Transform.scale(
              scale: 2.0,
              child: Checkbox(
                value: viewScaled,
                fillColor: MaterialStateProperty.all(menuItemColor),
                activeColor: menuItemColor,
                onChanged: (newValue) {
                  setState(() {
                    viewScaled = !viewScaled;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          const Expanded(
            child: Text(
              "View Scaled",
              style: TextStyle(
                color: menuItemColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ];
    for (var job in jobs) {
      if (devicesData.containsKey(job.jobCode)) {
        widgets.add(
          Text(
            "Running Details for Job: " + job.jobCode,
            style: const TextStyle(
              fontSize: 30.0,
              color: menuItemColor,
            ),
          ),
        );
        widgets.add(
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 300,
            child: charts.TimeSeriesChart(
              buildChart(job.jobCode),
              animate: true,
              domainAxis: const charts.DateTimeAxisSpec(
                tickProviderSpec: charts.AutoDateTimeTickProviderSpec(
                  includeTime: true,
                ),
              ),
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
          ),
        );
        widgets.add(
          const Text(
            "Max Values",
            style: TextStyle(
              fontSize: 30.0,
              color: menuItemColor,
            ),
          ),
        );
        widgets.add(
          Wrap(
            children: wrappedWidget(job.jobCode),
          ),
        );
        widgets.add(const Divider(
          height: 30.0,
        ));
      }
    }
    return widgets;
  }

  Widget viewWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: chartWidget(),
    );
  }

  List<Widget> wrappedWidget(String jobCode) {
    List<Widget> widget = [];
    Map<String, double> jobMaxValues = maxValues[jobCode]!;
    jobMaxValues = Map.fromEntries(jobMaxValues.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    jobMaxValues.forEach((key, value) {
      widget.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Text(
            key + " " + value.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 20.0,
              color: menuItemColor,
            ),
          ),
        ),
      );
    });
    return widget;
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
