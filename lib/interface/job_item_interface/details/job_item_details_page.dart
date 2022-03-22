import 'dart:convert';

import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/socket_utility.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/job_interface/details/job_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class JobItemDetailsPage extends StatefulWidget {
  final Map<String, dynamic> jobItem;
  final String jobID;
  const JobItemDetailsPage({
    Key? key,
    required this.jobItem,
    required this.jobID,
  }) : super(key: key);

  @override
  State<JobItemDetailsPage> createState() => _JobItemDetailsPageState();
}

class _JobItemDetailsPageState extends State<JobItemDetailsPage> {
  double currentWeight = 200.5;
  double taredWeight = 0;
  bool isVerified = false;
  bool isMaterialScanned = false;
  String back = '{"action":"back"}';
  String tare = '{"action":"tare"}';
  String complete = '{"action":"complete"}';

  @override
  void initState() {
    super.initState();
    scannerListener.addListener(listenToScanner);
    socketUtility.addListener(listenToWeighingScale);
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    socketUtility.removeListener(listenToWeighingScale);
    super.dispose();
  }

  dynamic listenToScanner(String data) {
    if (!data.contains("[") || !data.contains("]")) {
      verifyMaterial(data);
    } else {
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
              builder: (BuildContext context) => JobDetailsPage(
                jobID: widget.jobID,
              ),
            ),
          );
          break;
        case "complete":
          //TODO post to backend and go back to previous page if post is successful.
          break;
        case "tare":
          setState(() {
            taredWeight = currentWeight;
            currentWeight = 0;
          });
          break;
        default:
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
      setState(() {
        currentWeight = double.parse(scannerData["data"].toString());
      });
    } catch (e) {
      //TODO logging service
      print(e);
    }
  }

  Future<dynamic> verifyMaterial(String scannerData) async {
    String itemBarcode = widget.jobItem["barcode"];
    if (!isMaterialScanned) {
      setState(() {
        isMaterialScanned = true;
      });
    }
    if (itemBarcode == scannerData) {
      setState(() {
        isVerified = true;
      });
    }
  }

  List<Widget> getRowWidget(Map<String, dynamic> jobItem) {
    List<Widget> widgets = [];
    jobItem.forEach((key, value) {
      widgets.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              key.toUpperCase().replaceAll("_", " "),
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            Text(
              value.toString().toUpperCase(),
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
    return widgets;
  }

  Widget verifiedState() {
    Map<String, dynamic> jobItem = widget.jobItem;
    double upperLimit = double.parse(jobItem["upper_limit"]);
    double requiredQty = double.parse(jobItem["required"]);
    double lowerLimit = double.parse(jobItem["lower_limit"]);
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
          height: 20.0,
        ),
        Expanded(
          child: BaseWidget(
            builder: (context, sizeInformation) {
              return SizedBox(
                height: sizeInformation.screenSize.height - 120,
                child: Row(
                  children: [
                    SizedBox(
                      width: sizeInformation.screenSize.width * 0.6,
                      height: sizeInformation.screenSize.height - 120,
                      child: Column(
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
                    ),
                    SizedBox(
                      width: sizeInformation.screenSize.width * 0.4,
                      height: sizeInformation.screenSize.height - 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: sizeInformation.screenSize.width * 0.2,
                                child: Center(
                                  child: QrImage(
                                    data: tare,
                                    size: 200.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: sizeInformation.screenSize.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    "Tare",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.white,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: sizeInformation.screenSize.width * 0.2,
                                child: Center(
                                  child: QrImage(
                                    data: "Complete",
                                    size: 200.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: sizeInformation.screenSize.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    "Complete",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.white,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: sizeInformation.screenSize.width * 0.2,
                                child: Center(
                                  child: QrImage(
                                    data: back,
                                    size: 200.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: sizeInformation.screenSize.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    "Back",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget unScannedState() {
    return const Center(
      child: Text("Please Scan Material Barcode."),
    );
  }

  Widget unVerifiedState() {
    return const Center(
      child: Text("Incorrect Material. Please Scan Correct Material."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isMaterialScanned
          ? isVerified
              ? verifiedState()
              : unVerifiedState()
          : unScannedState(),
    );
  }
}
