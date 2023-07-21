import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/terminals.dart';
import 'package:eazyweigh/domain/entity/under_issue.dart';
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

class UnderIssueItemDetailsWidget extends StatefulWidget {
  final UnderIssue underIssue;
  final JobItem jobItem;
  final String jobCode;
  const UnderIssueItemDetailsWidget({
    Key? key,
    required this.jobItem,
    required this.underIssue,
    required this.jobCode,
  }) : super(key: key);

  @override
  State<UnderIssueItemDetailsWidget> createState() => _UnderIssueItemDetailsWidgetState();
}

class _UnderIssueItemDetailsWidgetState extends State<UnderIssueItemDetailsWidget> {
  bool isLoadingData = true;
  bool isCheckingCompletion = false;
  double currentWeight = 0;
  double taredWeight = 0;
  double actualWeight = 0;
  bool isVerified = true;
  double requiredQty = 0;
  bool isMaterialScanned = true;
  List<Terminal> terminals = [];
  List<Terminal> thisTerminal = [];
  double scaleFactor = 1;
  List<UnitOfMeasurementConversion> uomConversions = [];
  String back = "{'action':'back'}";
  String tare = "{'action':'tare'}";
  String preComplete = "{'action':'pre_complete'}";
  String cancel = "{'action':'cancel'}";
  String complete = "{'action':'complete'}";
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
    Map<String, dynamic> scannerData = jsonDecode(message.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
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
    Map<String, dynamic> scannerData = jsonDecode(data.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "back":
        Navigator.of(context).pop();
        break;
      case "complete":
        Map<String, dynamic> update = {
          "weighed": true,
          "weight": double.parse((currentWeight - taredWeight).toStringAsFixed(3)),
        };
        Map<String, dynamic> printingData = {
          "job_id": widget.jobItem.jobID,
          "weigher": currentUser.firstName + " " + currentUser.lastName,
          "material_code": widget.jobItem.material.code,
          "material_description": widget.jobItem.material.description,
          "weight": (currentWeight - taredWeight).toStringAsFixed(3),
          "uom": widget.jobItem.uom.code,
          "batch": scannedMaterialData["batch"],
          "job_item_id": widget.jobItem.id,
          "job_code": widget.jobCode,
          "under_issue_id": widget.underIssue.id,
        };
        if ((currentWeight - taredWeight) >= double.parse((requiredQty * .998).toStringAsFixed(4)) && (currentWeight - taredWeight) <= double.parse((1.002 * requiredQty).toStringAsFixed(4))) {
          await appStore.underIssueApp.update(widget.underIssue.id, update).then((value) async {
            if (value["status"]) {
              printingService.printJobItemLabel(printingData);
              setState(() {
                widget.jobItem.actualWeight += double.parse((currentWeight - taredWeight).toStringAsFixed(4));
                widget.jobItem.complete = true;
                requiredQty = double.parse((requiredQty - (currentWeight - taredWeight)).toStringAsFixed(4));
                currentWeight = 0;
              });
              Navigator.of(context).pop();
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
      case "pre_complete":
        setState(() {
          isCheckingCompletion = true;
        });
        break;
      case "cancel":
        setState(() {
          isCheckingCompletion = false;
        });
        break;
      case "tare":
        setState(() {
          taredWeight = currentWeight;
          currentWeight = 0;
        });
        break;
      case "logout":
        logout();
        break;
      default:
        verifyMaterial(data);
    }
  }

  Future<dynamic> verifyMaterial(String scannerData) async {
    Map<String, dynamic> jsonData = jsonDecode(scannerData.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));

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
    Map<String, dynamic> scannerData = jsonDecode(data.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
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
          currentWeight = double.parse((scannerData["data"]).toString()) * scaleFactor;
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
      // await getAPIKey();
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
      scaleFactor = getScaleFactor(thisTerminal[0].uom.code, widget.jobItem.uom.code);
    }
  }

  double getScaleFactor(String terminalCode, String jobItemCode) {
    if (terminalCode != jobItemCode) {
      for (var uomConversion in uomConversions) {
        if (uomConversion.unitOfMeasure1.code == terminalCode && uomConversion.unitOfMeasure2.code == jobItemCode) {
          return uomConversion.value2 / uomConversion.value1;
        }
        if (uomConversion.unitOfMeasure1.code == jobItemCode && uomConversion.unitOfMeasure2.code == terminalCode) {
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
    await appStore.unitOfMeasurementConversionApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          UnitOfMeasurementConversion unitOfMeasurementConversion = UnitOfMeasurementConversion.fromJSON(item);
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
            (widget.underIssue.req - widget.underIssue.actual).toString() + " " + widget.jobItem.uom.code,
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

  Widget checkCompletion() {
    Widget widget = Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 40.0),
          child: const Center(
            child: Text(
              "Sure to Complete?",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 - 50,
                  child: Center(
                    child: QrImageView(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isCheckingCompletion = false;
                      isVerified = true;
                    });
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3 - 50,
                    child: Center(
                      child: QrImageView(
                        data: cancel,
                        size: 200.0 * MediaQuery.of(context).size.width / 1920,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isCheckingCompletion = false;
                    });
                  },
                  child: const SizedBox(
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
    return widget;
  }

  Widget verifiedState() {
    if (isCheckingCompletion) {
      return checkCompletion();
    } else {
      JobItem jobItem = widget.jobItem;
      double upperLimit = (widget.underIssue.req - widget.underIssue.actual) * 1.01;
      requiredQty = widget.underIssue.req - widget.underIssue.actual;
      double lowerLimit = (widget.underIssue.req - widget.underIssue.actual) * 0.99;
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
                      child: QrImageView(
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
                      child: QrImageView(
                        data: preComplete,
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
                      child: QrImageView(
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
                              (currentWeight - taredWeight).toStringAsFixed(3),
                              style: TextStyle(
                                  fontSize: 300.0 * sizeInformation.screenSize.height / 1006,
                                  color: ((currentWeight - taredWeight) > upperLimit || (currentWeight - taredWeight) < lowerLimit) ? Colors.red : Colors.green),
                            ),
                            Icon(
                              (currentWeight - taredWeight) < lowerLimit
                                  ? Icons.arrow_circle_up
                                  : (currentWeight - taredWeight) > upperLimit
                                      ? Icons.arrow_circle_down
                                      : Icons.check_circle,
                              size: 200.0 * sizeInformation.screenSize.height / 1006,
                              color: ((currentWeight - taredWeight) < lowerLimit || (currentWeight - taredWeight) > upperLimit) ? Colors.red : Colors.green,
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
          QrImageView(
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
          QrImageView(
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
        "Under Weighing",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
