import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/over_issue.dart';
import 'package:eazyweigh/domain/entity/terminals.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure_conversion.dart';
import 'package:eazyweigh/infrastructure/printing_service.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/socket_utility.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OverIssueItemDetailsWidget extends StatefulWidget {
  final OverIssue overIssue;
  final JobItem jobItem;
  final String jobCode;
  const OverIssueItemDetailsWidget({
    Key? key,
    required this.jobItem,
    required this.overIssue,
    required this.jobCode,
  }) : super(key: key);

  @override
  State<OverIssueItemDetailsWidget> createState() =>
      _OverIssueItemDetailsWidgetState();
}

class _OverIssueItemDetailsWidgetState
    extends State<OverIssueItemDetailsWidget> {
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
    startTime = DateTime.now();
    socketUtility.initCommunication();
    printingService.addListener(listenToPrintingService);
    scannerListener.addListener(listenToScanner);
    socketUtility.addListener(listenToWeighingScale);
  }

  @override
  void dispose() {
    printingService.removeListener(listenToPrintingService);
    scannerListener.removeListener(listenToScanner);
    socketUtility.removeListener(listenToWeighingScale);
    super.dispose();
  }

  void listenToPrintingService(String message) {
    Map<String, dynamic> scannerData = jsonDecode(message
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));
    if (!(scannerData.containsKey("status") && scannerData["status"])) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomDialog(
            message: "Unable to Print.",
            title: "Error",
          );
        },
      );
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.of(context).pop();
      });
    }
    printingService.close();
  }

  dynamic listenToScanner(String data) async {
    Map<String, dynamic> scannerData = jsonDecode(data
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "back":
        Navigator.of(context).pop();
        break;
      case "complete":
        actualWeight = currentWeight;
        Map<String, dynamic> update = {
          "weighed": true,
          "weight": actualWeight,
        };
        Map<String, dynamic> printingData = {
          "job_id": widget.jobItem.jobID,
          "weigher": currentUser.firstName + " " + currentUser.lastName,
          "material_code": widget.jobItem.material.code,
          "material_description": widget.jobItem.material.description,
          "weight": actualWeight,
          "uom": widget.jobItem.uom.code,
          "batch": scannedMaterialData["batch"],
          "job_item_id": widget.jobItem.id,
          "job_code": widget.jobCode,
          "over_issue_id": widget.overIssue.id,
        };
        if (actualWeight >= requiredQty * .99 &&
            actualWeight <= 1.01 * requiredQty) {
          await appStore.overIssueApp
              .update(widget.overIssue.id, update)
              .then((value) async {
            if (value["status"]) {
              printingService.printJobItemLabel(printingData);

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
                message: "Weight Not Correct.",
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

  dynamic listenToWeighingScale(String data) {
    Map<String, dynamic> scannerData = jsonDecode(data
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));
    try {
      if (scannerData.containsKey("error")) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              message: scannerData["error"],
              title: "Errors",
            );
          },
        );
        Future.delayed(const Duration(seconds: 3)).then((value) {
          Navigator.of(context).pop();
        });
      } else {
        setState(() {
          currentWeight =
              double.parse((scannerData["data"]).toString()) * scaleFactor -
                  taredWeight;
        });
      }
    } catch (e) {
      FLog.info(text: "Unable to Connect to Scale");
    }
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
        Navigator.of(context).pop();
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
            (widget.overIssue.actual - widget.overIssue.req).toString() +
                " " +
                widget.jobItem.uom.code,
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
    double upperLimit = (widget.overIssue.actual - widget.overIssue.req) * 1.01;
    requiredQty = widget.overIssue.actual - widget.overIssue.req;
    double lowerLimit = (widget.overIssue.actual - widget.overIssue.req) * 0.99;
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
        const Divider(
          height: 10,
          color: Colors.transparent,
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
            backgroundColor: Colors.red,
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
            backgroundColor: Colors.red,
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
        "Over Weighing",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
