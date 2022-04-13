import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/terminals.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure_conversion.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/socket_utility.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/job_interface/details/job_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class JobItemDetailsWidget extends StatefulWidget {
  final String jobCode;
  final JobItem jobItem;
  final List<JobItem> allJobItems;
  const JobItemDetailsWidget({
    Key? key,
    required this.jobCode,
    required this.jobItem,
    required this.allJobItems,
  }) : super(key: key);

  @override
  State<JobItemDetailsWidget> createState() => _JobItemDetailsWidgetState();
}

class _JobItemDetailsWidgetState extends State<JobItemDetailsWidget> {
  bool isLoadingData = true;
  double currentWeight = 0;
  double taredWeight = 0;
  double actualWeight = 0;
  bool isVerified = false;
  double requiredQty = 0;
  bool isMaterialScanned = false;
  List<Terminal> terminals = [];
  List<Terminal> thisTerminal = [];
  double scaleFactor = 1;
  List<UnitOfMeasurementConversion> uomConversions = [];
  String back = '{"action":"back"}';
  String tare = '{"action":"tare"}';
  String complete = '{"action":"complete"}';
  Map<String, dynamic> scannedMaterialData = {};
  late DateTime startTime, endTime;

  @override
  void initState() {
    super.initState();
    getAllData();
    requiredQty = widget.jobItem.requiredWeight - widget.jobItem.actualWeight;
    startTime = DateTime.now();
    scannerListener.addListener(listenToScanner);
    socketUtility.addListener(listenToWeighingScale);
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    socketUtility.removeListener(listenToWeighingScale);
    super.dispose();
  }

  void getAllData() async {
    await Future.forEach([
      await getUOMConversions(),
      await getScales(),
    ], (element) {
      setState(() {
        isLoadingData = false;
      });
    }).then((value) async {
      await getAPIKey();
    });
  }

  Future<dynamic> getAPIKey() async {
    String apiKey = storage?.getString("api_key") ?? "";
    if (apiKey.isEmpty || apiKey == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomDialog(
            message: "This is not a registered Terminal.",
            title: "Errors",
          );
        },
      );
      await Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => JobDetailsWidget(
              jobCode: widget.jobCode,
              jobItems: widget.allJobItems,
            ),
          ),
        );
      });
    } else {
      for (var terminal in terminals) {
        if (terminal.apiKey == apiKey) {
          thisTerminal.add(terminal);
        }
      }
      scaleFactor =
          getScaleFactor(thisTerminal[0].uom.code, widget.jobItem.uom.code);
    }
  }

  double getScaleFactor(String terminalCode, String jobItemCode) {
    if (terminalCode != jobItemCode) {
      for (var uomConversion in uomConversions) {
        if (uomConversion.unitOfMeasure1.code == terminalCode &&
            uomConversion.unitOfMeasure2.code == jobItemCode) {
          return uomConversion.value2 / uomConversion.value1;
        }
        if (uomConversion.unitOfMeasure1.code == jobItemCode &&
            uomConversion.unitOfMeasure2.code == terminalCode) {
          return uomConversion.value1 / uomConversion.value2;
        }
      }
    }
    return 1;
  }

  Future<dynamic> getUOMConversions() async {
    uomConversions = [];
    Map<String, dynamic> conditions = {
      "factory_id": widget.jobItem.material.factoryID,
    };
    await appStore.unitOfMeasurementConversionApp
        .list(conditions)
        .then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          UnitOfMeasurementConversion unitOfMeasurementConversion =
              UnitOfMeasurementConversion.fromJSON(item);
          uomConversions.add(unitOfMeasurementConversion);
        }
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

  Future<dynamic> getScales() async {
    terminals = [];
    Map<String, dynamic> conditions = {
      "factory_id": widget.jobItem.material.factoryID,
    };
    await appStore.terminalApp.list(conditions).then((value) async {
      if (value["status"]) {
        for (var item in value["payload"]) {
          Terminal terminal = Terminal.fromJSON(item);
          terminals.add(terminal);
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

  Future<void> printLabel(Map<String, dynamic> printData) async {}

  dynamic listenToScanner(String data) async {
    Map<String, dynamic> scannerData = jsonDecode(data
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "back":
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => JobDetailsWidget(
              jobCode: widget.jobCode,
              jobItems: widget.allJobItems,
            ),
          ),
        );
        break;
      case "complete":
        actualWeight = currentWeight;
        Map<String, dynamic> jobItemWeighing = {
          "job_code": widget.jobCode,
          "job_item_id": widget.jobItem.id,
          "material_code": widget.jobItem.material.code,
          "material_description": widget.jobItem.material.description,
          "weight": actualWeight,
          "batch": scannedMaterialData["batch"],
          "start_time": startTime.toIso8601String() + "Z",
          "end_time": DateTime.now().toIso8601String() + "Z",
        };
        Map<String, dynamic> printingData = {
          "job_code": widget.jobCode,
          "weigher": currentUser.firstName + " " + currentUser.lastName,
          "material_code": widget.jobItem.material.code,
          "material_description": widget.jobItem.material.description,
          "weight": actualWeight,
          "job_item_id": widget.jobItem.id,
        };
        if (actualWeight != 0) {
          await appStore.jobWeighingApp.create(jobItemWeighing).then((value) {
            if (value["status"]) {
              String id = value["payload"]["id"];
              printingData["job_item_weighing_id"] = id;
              printLabel(printingData);
              setState(() {
                widget.jobItem.requiredWeight =
                    widget.jobItem.requiredWeight - actualWeight;
                widget.jobItem.actualWeight += actualWeight;
                requiredQty = requiredQty - actualWeight;
                actualWeight = 0;
              });
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    message: value["message"],
                    title: "Errors",
                  );
                },
              );
              Future.delayed(const Duration(seconds: 3)).then((value) {
                Navigator.of(context).pop();
              });
            }
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomDialog(
                message: "Nothing to Weigh.",
                title: "Errors",
              );
            },
          );
          Future.delayed(const Duration(seconds: 3)).then((value) {
            Navigator.of(context).pop();
          });
        }
        break;
      case "tare":
        setState(() {
          taredWeight = currentWeight * scaleFactor;
          currentWeight = 0;
        });
        break;
      case "logout":
        logout(context);
        break;
      default:
        verifyMaterial(data);
    }
  }

  dynamic listenToWeighingScale(String data) {
    Map<String, dynamic> scannerData = jsonDecode(data
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));
    try {
      setState(() {
        currentWeight =
            double.parse((scannerData["data"]).toString()) * scaleFactor -
                taredWeight;
      });
    } catch (e) {
      //TODO logging service
    }
  }

  Future<dynamic> verifyMaterial(String scannerData) async {
    Map<String, dynamic> jsonData = jsonDecode(scannerData
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));

    if (jsonData.containsKey("code")) {
      String matCode = jsonData["code"];
      if (!isMaterialScanned) {
        setState(() {
          isMaterialScanned = true;
        });
      }
      if (matCode == widget.jobItem.material.code) {
        scannedMaterialData = jsonData;
        setState(() {
          isVerified = true;
        });
      } else {
        Map<String, dynamic> scannedData = {
          "job_id": widget.jobItem.jobID,
          "actual_code": matCode,
          "expected_code": widget.jobItem.material.code,
          "user_username": currentUser.username,
          "terminal_id": thisTerminal[0].id,
        };
        await appStore.scannedDataApp.create(scannedData).then((value) {});
      }
    }
  }

  List<Widget> getRowWidget(JobItem jobItem) {
    List<Widget> widgets = [];
    widgets.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Material",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          Text(
            jobItem.material.code + " - " + jobItem.material.description,
            style: const TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    widgets.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Required Quantity",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          Text(
            jobItem.requiredWeight.toString() + " " + jobItem.uom.code,
            style: const TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    return widgets;
  }

  Widget verifiedState() {
    JobItem jobItem = widget.jobItem;
    double upperLimit = jobItem.upperBound;
    requiredQty = jobItem.requiredWeight - jobItem.actualWeight - actualWeight;
    double lowerLimit = jobItem.lowerBound;
    int precision = (upperLimit - requiredQty) >= 10
        ? 0
        : (upperLimit - requiredQty) >= 1
            ? 1
            : (upperLimit - requiredQty) >= 0.1
                ? 2
                : 3;
    return Column(
      children: [
        Container(
          height: 100.0,
          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getRowWidget(jobItem),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 - 50,
                  child: Center(
                    child: QrImage(
                      data: tare,
                      size: 200.0 * MediaQuery.of(context).size.width / 1920,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  child: Center(
                    child: Text(
                      "Tare",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.transparent,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 - 50,
                  child: Center(
                    child: QrImage(
                      data: complete,
                      size: 200.0 * MediaQuery.of(context).size.width / 1920,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  child: Center(
                    child: Text(
                      "Complete",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.transparent,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 - 50,
                  child: Center(
                    child: QrImage(
                      data: back,
                      size: 200.0 * MediaQuery.of(context).size.width / 1920,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  child: Center(
                    child: Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        BaseWidget(
          builder: (context, sizeInformation) {
            return SizedBox(
              width: sizeInformation.screenSize.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            currentWeight.toStringAsFixed(precision),
                            style: TextStyle(
                                fontSize: 300.0 *
                                    sizeInformation.screenSize.height /
                                    1006,
                                color: (currentWeight > upperLimit ||
                                        currentWeight < lowerLimit)
                                    ? Colors.red
                                    : Colors.green),
                          ),
                          Icon(
                            currentWeight < lowerLimit
                                ? Icons.arrow_circle_up
                                : currentWeight > upperLimit
                                    ? Icons.arrow_circle_down
                                    : Icons.check_circle,
                            size: 200.0 *
                                sizeInformation.screenSize.height /
                                1006,
                            color: (currentWeight < lowerLimit ||
                                    currentWeight > upperLimit)
                                ? Colors.red
                                : Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget unScannedState() {
    return Center(
      child: Column(
        children: [
          const Text(
            "Please Scan Material QR Code.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.0,
            ),
          ),
          const Divider(),
          QrImage(
            data: back,
            size: 250,
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget unVerifiedState() {
    return Center(
      child: Column(
        children: [
          const Text(
            "Incorrect Material. Please Scan Correct Material.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.0,
            ),
          ),
          const Divider(),
          QrImage(
            data: back,
            size: 250,
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        isMaterialScanned
            ? isVerified
                ? verifiedState()
                : unVerifiedState()
            : unScannedState(),
        context,
        "All Job Items",
        () {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (BuildContext context) => JobDetailsWidget(
                jobCode: widget.jobCode,
                jobItems: widget.allJobItems,
              ),
            ),
          );
        },
      ),
    );
  }
}
