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
import 'package:eazyweigh/interface/batch_run/text_symbol_renderer.dart';
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
  List<Job> jobs = [];
  late Mat material;
  Map<String, Map<String, int>> ticks = {};
  Map<String, Map<String, List<DeviceData>>> devicesData = {};
  Map<String, Map<String, List<DeviceDataPoint>>> devicesDataPoints = {}, finalDeviceDataPoints = {};
  late TextEditingController factoryController, skuCodeController, deviceController;
  String value = "";

  @override
  void initState() {
    getFactories();
    factoryController = TextEditingController();
    skuCodeController = TextEditingController();
    deviceController = TextEditingController();
    deviceController.addListener(() {
      // print(deviceController.text);
      setState(() {});
    });
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
                          setState(() {
                            isLoadingData = true;
                          });

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
                              material = Mat.fromJSON(value["payload"][0]);
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
                                                if (!ticks.containsKey(deviceData.deviceID)) {
                                                  ticks[deviceData.deviceID] = {};
                                                }
                                                if (!ticks[deviceData.deviceID]!.containsKey(currentJob.jobCode)) {
                                                  ticks[deviceData.deviceID]![currentJob.jobCode] = 0;
                                                }
                                                ticks[deviceData.deviceID]![currentJob.jobCode] = ticks[deviceData.deviceID]![currentJob.jobCode]! + 1;
                                                if (!deviceIDs.contains(deviceData.deviceID)) {
                                                  deviceIDs.add(deviceData.deviceID);
                                                }
                                                if (!devicesData.containsKey(deviceData.deviceID)) {
                                                  devicesData[deviceData.deviceID] = {};
                                                  devicesDataPoints[deviceData.deviceID] = {};
                                                }
                                                if (!devicesData[deviceData.deviceID]!.containsKey(currentJob.jobCode)) {
                                                  devicesData[deviceData.deviceID]![currentJob.jobCode] = [];
                                                  devicesDataPoints[deviceData.deviceID]![currentJob.jobCode] = [];
                                                }
                                                devicesData[deviceData.deviceID]![currentJob.jobCode]!.add(deviceData);
                                                devicesDataPoints[deviceData.deviceID]![currentJob.jobCode]!.add(
                                                  DeviceDataPoint(
                                                    timeStamp: deviceData.createdAt,
                                                    value: deviceData.value,
                                                  ),
                                                );
                                              }
                                              Map<String, dynamic> deviceConditions = {
                                                "IN": {
                                                  "Field": "id",
                                                  "Value": deviceIDs,
                                                }
                                              };
                                              await appStore.deviceApp.list(deviceConditions).then((value) {
                                                if (value.containsKey("status") && value["status"]) {
                                                  devices = [];
                                                  for (var item in value["payload"]) {
                                                    Device device = Device.fromJSON(item);
                                                    devices.add(device);
                                                  }
                                                  devices.sort((a, b) => a.deviceType.description.compareTo(b.deviceType.description));
                                                  deviceController.text = devices[0].id;
                                                }
                                              }).then((value) {
                                                finalDeviceDataPoints = {};
                                                devicesDataPoints.forEach((key, value) {
                                                  String deviceName = devices.firstWhere((element) => element.id == key).deviceType.description;
                                                  finalDeviceDataPoints[deviceName] = value;
                                                });
                                                devicesDataPoints = Map.fromEntries(devicesDataPoints.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
                                                setState(() {
                                                  isLoadingData = false;
                                                  isDataLoaded = true;
                                                });
                                              });
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

  List<charts.Series<dynamic, num>> buildChart(String deviceID) {
    List<charts.Series<dynamic, num>> series = [];
    deviceID = devices.firstWhere((element) => element.id == deviceID).deviceType.description;
    var jobDeviceDataPoint = finalDeviceDataPoints[deviceID];
    jobDeviceDataPoint = Map.fromEntries(jobDeviceDataPoint!.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    Map<String, List<DeviceDataPoint>> finalJobDeviceDataPoint = {};
    jobDeviceDataPoint.forEach((key, values) {
      int tick = 0;
      values.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
      for (var value in values) {
        if (!finalJobDeviceDataPoint.containsKey(key)) {
          finalJobDeviceDataPoint[key] = [];
        }
        finalJobDeviceDataPoint[key]!.add(DeviceDataPoint(
          timeStamp: value.timeStamp,
          value: value.value,
          tick: tick++,
        ));
      }
    });
    finalJobDeviceDataPoint.forEach((key, values) {
      series.add(
        charts.Series<DeviceDataPoint, num>(
          id: key,
          domainFn: (DeviceDataPoint deviceDataPoint, _) => deviceDataPoint.tick,
          measureFn: (DeviceDataPoint deviceDataPoint, _) => deviceDataPoint.value,
          data: values,
        ),
      );
    });
    return series;
  }

  List<Widget> chartWidget() {
    List<Widget> widgets = [
      Text(
        "Run Details for Material: " + material.code.toString() + " - " + material.description,
        style: const TextStyle(
          fontSize: 30.0,
          color: menuItemColor,
        ),
      ),
    ];
    widgets.add(
      DropDownWidget(
        disabled: false,
        hint: "Select Device",
        controller: deviceController,
        itemList: devices,
      ),
    );
    widgets.add(
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 300,
        child: charts.LineChart(
          buildChart(deviceController.text),
          animate: true,
          behaviors: [
            charts.SlidingViewport(),
            charts.PanAndZoomBehavior(),
            charts.SeriesLegend(
              position: charts.BehaviorPosition.top,
              entryTextStyle: charts.TextStyleSpec(
                color: charts.MaterialPalette.purple.shadeDefault,
                fontSize: 16,
              ),
            ),
            charts.LinePointHighlighter(
              symbolRenderer: TextSymbolRenderer(() => value),
            ),
          ],
          selectionModels: [
            charts.SelectionModelConfig(changedListener: (charts.SelectionModel model) {
              if (model.hasDatumSelection) {
                value = model.selectedSeries[0].domainFn(model.selectedDatum[0].index).toString().substring(0, 16) + " - " + model.selectedSeries[0].measureFn(model.selectedDatum[0].index).toString();
              }
            })
          ],
        ),
      ),
    );

    widgets.add(const Divider(
      height: 50.0,
      color: Colors.white,
    ));
    return widgets;
  }

  Widget viewWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: devicesData.isEmpty
          ? [
              Text(
                "No Data Found for: " + skuCodeController.text,
                style: const TextStyle(
                  fontSize: 30.0,
                  color: menuItemColor,
                ),
              )
            ]
          : chartWidget(),
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
  final int tick;
  final DateTime timeStamp;
  final double value;

  DeviceDataPoint({
    this.tick = 0,
    required this.timeStamp,
    required this.value,
  });
}
