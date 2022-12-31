import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/terminals.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure_conversion.dart';
import 'package:eazyweigh/infrastructure/printing_service.dart';
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
import 'package:f_logs/model/flog/flog.dart';
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
  bool isCheckingCompletion = false;
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
  String preComplete = '{"action":"pre_complete"}';
  String cancel = '{"action":"cancel"}';
  String complete = '{"action":"complete"}';
  Map<String, dynamic> scannedMaterialData = {};
  late DateTime startTime, endTime;
  bool isPosting = false;

  @override
  void initState() {
    super.initState();
    getAllData();
    requiredQty = widget.jobItem.requiredWeight;
    actualWeight = widget.jobItem.actualWeight;
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
    Map<String, dynamic> scannerData = jsonDecode(message);
    if (!(scannerData.containsKey("status") && scannerData["status"] == "done")) {
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

  bool checkAllComplete() {
    bool isComplete = true;
    for (var item in widget.allJobItems) {
      isComplete = isComplete & item.complete;
    }
    return isComplete;
  }

  dynamic listenToScanner(String data) async {
    Map<String, dynamic> scannerData = jsonDecode(
        data.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "back":
        widget.allJobItems.sort((a, b) => a.complete.toString().compareTo(b.complete.toString()));
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => JobDetailsWidget(
              jobCode: widget.jobCode,
              jobItems: widget.allJobItems,
            ),
          ),
        );
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
      case "complete":
        Map<String, dynamic> jobItemWeighing = {
          "job_code": widget.jobCode,
          "job_item_id": widget.jobItem.id,
          "material_code": widget.jobItem.material.code,
          "material_description": widget.jobItem.material.description,
          "weight": double.parse((currentWeight - taredWeight).toStringAsFixed(3)),
          "uom": widget.jobItem.uom.code,
          "batch": scannedMaterialData["batch"],
          "start_time": startTime.toLocal().toIso8601String() + "Z",
          "end_time": DateTime.now().toLocal().toIso8601String() + "Z",
        };
        Map<String, dynamic> printingData = {
          "job_code": widget.jobCode,
          "job_id": widget.jobItem.jobID,
          "weigher": currentUser.firstName + " " + currentUser.lastName,
          "material_code": widget.jobItem.material.code,
          "material_description": widget.jobItem.material.description,
          "weight": (currentWeight - taredWeight).toStringAsFixed(3),
          "uom": widget.jobItem.uom.code,
          "batch": scannedMaterialData["batch"],
          "job_item_id": widget.jobItem.id,
        };
        if ((currentWeight - taredWeight) > 0 &&
            double.parse((actualWeight + (currentWeight - taredWeight)).toStringAsFixed(4)) <=
                double.parse(widget.jobItem.upperBound.toStringAsFixed(4))) {
          if (!isPosting) {
            setState(() {
              isPosting = true;
            });
            await appStore.jobWeighingApp.create(jobItemWeighing).then((value) async {
              if (value["status"]) {
                String id = value["payload"]["id"];
                printingData["job_item_weighing_id"] = id;
                if (double.parse((actualWeight + (currentWeight - taredWeight)).toStringAsFixed(4)) >=
                    double.parse(widget.jobItem.lowerBound.toStringAsFixed(4))) {
                  printingData["complete"] = true;
                }

                printingService.printJobItemLabel(printingData);

                if (double.parse((actualWeight + (currentWeight - taredWeight)).toStringAsFixed(4)) >=
                    double.parse(widget.jobItem.lowerBound.toStringAsFixed(4))) {
                  setState(() {
                    widget.allJobItems.firstWhere((element) => element.id == widget.jobItem.id).complete = true;
                  });
                }

                setState(() {
                  widget.allJobItems.firstWhere((element) => element.id == widget.jobItem.id).actualWeight +=
                      (currentWeight - taredWeight);
                  currentWeight = 0;
                });

                if (checkAllComplete()) {
                  Map<String, dynamic> update = {
                    "complete": true,
                  };

                  await appStore.jobApp.update(widget.jobItem.jobID, update).then((updateResponse) {
                    navigationService.pushReplacement(
                      CupertinoPageRoute(
                        builder: (BuildContext context) => JobDetailsWidget(
                          jobCode: widget.jobCode,
                          jobItems: widget.allJobItems,
                        ),
                      ),
                    );
                  });
                } else {
                  navigationService.pushReplacement(
                    CupertinoPageRoute(
                      builder: (BuildContext context) => JobDetailsWidget(
                        jobCode: widget.jobCode,
                        jobItems: widget.allJobItems,
                      ),
                    ),
                  );
                }
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
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomDialog(
                message: "Invalid Weighing.",
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

  dynamic listenToWeighingScale(String data) {
    Map<String, dynamic> scannerData = jsonDecode(
        data.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
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

  Future<void> playAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    String audioAsset = "audio/siren.wav";
    await audioPlayer.play(AssetSource(audioAsset));
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
        playAudio();
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
            requiredQty.toStringAsFixed(3) + " " + jobItem.uom.code,
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
    if (isCheckingCompletion) {
      return checkCompletion();
    } else {
      JobItem jobItem = widget.jobItem;
      double upperLimit = double.parse(jobItem.upperBound.toStringAsFixed(3));
      requiredQty = double.parse((jobItem.requiredWeight - jobItem.actualWeight).toStringAsFixed(3));
      double lowerLimit = double.parse(jobItem.lowerBound.toStringAsFixed(3));
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
                        data: preComplete,
                        size: 200.0 * MediaQuery.of(context).size.width / 1920,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isCheckingCompletion = true;
                      });
                    },
                    child: const SizedBox(
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
                              (currentWeight - taredWeight).toStringAsFixed(3),
                              style: TextStyle(
                                  fontSize: 300.0 * sizeInformation.screenSize.height / 1006,
                                  color: ((currentWeight - taredWeight) + widget.jobItem.actualWeight > upperLimit ||
                                          (currentWeight - taredWeight) + widget.jobItem.actualWeight < lowerLimit)
                                      ? Colors.red
                                      : Colors.green),
                            ),
                            Icon(
                              (currentWeight - taredWeight) + widget.jobItem.actualWeight < lowerLimit
                                  ? Icons.arrow_circle_up
                                  : (currentWeight - taredWeight) + widget.jobItem.actualWeight > upperLimit
                                      ? Icons.arrow_circle_down
                                      : Icons.check_circle,
                              size: 200.0 * sizeInformation.screenSize.height / 1006,
                              color: ((currentWeight - taredWeight) + widget.jobItem.actualWeight < lowerLimit ||
                                      (currentWeight - taredWeight) + widget.jobItem.actualWeight > upperLimit)
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
  }

  Widget unScannedState(JobItem jobItem) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Now Weighing",
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
              const VerticalDivider(
                width: 20,
                color: Colors.transparent,
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
                      child: QrImage(
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

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        isMaterialScanned
            ? isVerified
                ? verifiedState()
                : unVerifiedState()
            : unScannedState(widget.jobItem),
        context,
        "Job Item Weighing",
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
