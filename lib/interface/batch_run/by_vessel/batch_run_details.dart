import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/batch_run.dart';
import 'package:eazyweigh/domain/entity/device.dart';
import 'package:eazyweigh/domain/entity/device_data.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
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
  List<Vessel> vessels = [];
  List<Device> devices = [];
  List<String> deviceIDs = [];
  List<DateTime> ticks = [];
  Map<String, double> maxValues = {};
  Map<String, int> colours = {};
  late Job job;
  Map<String, List<DeviceData>> devicesData = {};
  Map<String, List<DeviceDataPoint>> devicesDataPoints = {};
  late TextEditingController factoryController, vesselController;
  bool viewScaled = true;

  @override
  void initState() {
    getFactories();
    factoryController = TextEditingController();
    vesselController = TextEditingController();
    factoryController.addListener(() {
      getVessels();
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

  Future<dynamic> getVessels() async {
    vessels = [];
    setState(() {
      isLoadingData = true;
    });

    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryController.text,
      }
    };

    await appStore.vesselApp.list(conditions).then((response) {
      if (response.containsKey("status") && response["status"]) {
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
                vessels.isEmpty
                    ? Container()
                    : DropDownWidget(
                        disabled: false,
                        hint: "Select Vessel",
                        controller: vesselController,
                        itemList: vessels,
                      ),
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () async {
                        var vesselID = vesselController.text;

                        String errors = "";

                        if (factoryController.text.isEmpty) {
                          errors += "Factory Missing.\n";
                        }

                        if (vesselID.isEmpty) {
                          errors += "Vessel Selection Missing.\n";
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
                            "EQUALS": {
                              "Field": "vessel_id",
                              "Value": vesselID,
                            }
                          };

                          await appStore.batchRunApp.list(conditions).then((batchResponse) async {
                            if (batchResponse.containsKey("status") && batchResponse["status"]) {
                              if (batchResponse["payload"].isEmpty) {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CustomDialog(
                                      message: "No Running Job Found on vessel.",
                                      title: "Errors",
                                    );
                                  },
                                );
                              } else {
                                List<BatchRun> batchRuns = [];
                                for (var item in batchResponse["payload"]) {
                                  BatchRun batchRun = BatchRun.fromJSON(item);
                                  batchRuns.add(batchRun);
                                }
                                batchRuns.sort((a, b) => b.startTime.compareTo(a.startTime));
                                BatchRun runningBatch = batchRuns[0];
                                job = runningBatch.job;
                                Map<String, dynamic> deviceDataConditions = {
                                  "AND": [
                                    {
                                      "GREATEREQUAL": {
                                        "Field": "created_at",
                                        "Value": runningBatch.startTime.toUtc().toIso8601String().toString().split(".")[0] + "Z",
                                      },
                                    },
                                    {
                                      "LESSEQUAL": {
                                        "Field": "created_at",
                                        "Value": runningBatch.endTime.toUtc().toIso8601String().toString().split(".")[0] + "Z",
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
                                      devicesDataPoints[deviceData.deviceID]!.add(
                                        DeviceDataPoint(
                                          timeStamp: deviceData.createdAt,
                                          value: deviceData.value,
                                        ),
                                      );
                                      if (maxValues.containsKey(deviceData.deviceID)) {
                                        if (deviceData.value > (maxValues[deviceData.deviceID] ?? 1)) {
                                          maxValues[deviceData.deviceID] = deviceData.value;
                                        }
                                      } else {
                                        maxValues[deviceData.deviceID] = deviceData.value;
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
                                          colours[device.id] = device.deviceType.colour;
                                        }
                                        Map<String, List<DeviceDataPoint>> finalDeviceDataPoints = {};
                                        devicesDataPoints.forEach((key, value) {
                                          String deviceName = devices.firstWhere((element) => element.id == key).deviceType.description;
                                          finalDeviceDataPoints[deviceName] = value;
                                        });
                                        devicesDataPoints = finalDeviceDataPoints;
                                        Map<String, double> finalMaxValues = {};
                                        maxValues.forEach((key, value) {
                                          String deviceName = devices.firstWhere((element) => element.id == key).deviceType.description;
                                          finalMaxValues[deviceName] = value;
                                        });
                                        maxValues = finalMaxValues;
                                        Map<String, int> finalColour = {};
                                        colours.forEach((key, value) {
                                          String deviceName = devices.firstWhere((element) => element.id == key).deviceType.description;
                                          finalColour[deviceName] = value;
                                        });
                                        colours = finalColour;
                                        devicesDataPoints = Map.fromEntries(devicesDataPoints.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
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
      series.add(
        charts.Series<DeviceDataPoint, DateTime>(
          id: key,
          domainFn: (DeviceDataPoint deviceDataPoint, _) => deviceDataPoint.timeStamp.toLocal(),
          measureFn: (DeviceDataPoint deviceDataPoint, _) => viewScaled
              ? deviceDataPoint.value < 0
                  ? 0
                  : deviceDataPoint.value / (maxValues[key] ?? 1)
              : deviceDataPoint.value,
          data: values,
          seriesColor: charts.ColorUtil.fromDartColor(Color(colours[key] ?? 0xFFFFFFFF)),
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
          "Running Details for Job: " + job.jobCode,
          style: const TextStyle(
            fontSize: 30.0,
            color: menuItemColor,
          ),
        ),
        Text(
          "Material: " + job.material.code.toString() + " - " + job.material.description,
          style: const TextStyle(
            fontSize: 30.0,
            color: menuItemColor,
          ),
        ),
        const Text(
          "Max Values",
          style: TextStyle(
            fontSize: 30.0,
            color: menuItemColor,
          ),
        ),
        Wrap(
          children: wrappedWidget(),
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
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 300,
          child: charts.TimeSeriesChart(
            buildChart(),
            animate: true,
            domainAxis: const charts.DateTimeAxisSpec(
              tickProviderSpec: charts.AutoDateTimeTickProviderSpec(
                includeTime: true,
              ),
            ),
            behaviors: [
              charts.SeriesLegend(
                position: charts.BehaviorPosition.bottom,
                entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.purple.shadeDefault,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 30.0,
        ),
        viewScaled
            ? const Text(
                "Note:- Each data point is scaled against the maximum value for that device during the period.",
                style: TextStyle(
                  fontSize: 14.0,
                  color: menuItemColor,
                ),
              )
            : Container(),
      ],
    );
  }

  List<Widget> wrappedWidget() {
    List<Widget> widget = [];
    maxValues.forEach((key, value) {
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
