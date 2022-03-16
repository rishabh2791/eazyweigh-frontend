import 'dart:convert';

import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/interface/job_interface/details/description_row.dart';
import 'package:eazyweigh/interface/job_interface/list/job_list_page.dart';
import 'package:eazyweigh/interface/job_item_interface/details/job_item_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class JobDetailsPage extends StatefulWidget {
  final String jobID;
  const JobDetailsPage({
    Key? key,
    required this.jobID,
  }) : super(key: key);

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  int start = 0;
  int end = 2;
  bool isLoading = true;
  List<Map<String, dynamic>> jobItems = [];
  ScrollController? scrollController;
  String previous = '{"action":"navigation", "data":{"type":"previous"}}';
  String next = '{"action":"navigation", "data":{"type":"next"}}';
  String back = '{"action":"navigation", "data":{"type":"back"}}';
  var jobDetails = {
    "123456": {
      "material": "MAT001",
      "size": 1000,
      "uom": "KG",
      "job_items": [
        {
          "material": "RM001",
          "barcode": "987654321",
          "required": "200",
          "upper_limit": "201",
          "lower_limit": "199",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM002",
          "barcode": "987654322",
          "required": "100",
          "upper_limit": "101",
          "lower_limit": "99",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM003",
          "barcode": "987654323",
          "required": "500",
          "upper_limit": "505",
          "lower_limit": "495",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM004",
          "barcode": "987654324",
          "required": "50",
          "upper_limit": "51",
          "lower_limit": "49",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM005",
          "barcode": "987654325",
          "required": "150",
          "upper_limit": "151",
          "lower_limit": "149",
          "complete": false,
          "uom": "KG",
        },
      ],
    },
    "234567": {
      "material": "MAT002",
      "size": 100,
      "uom": "KG",
      "job_items": [
        {
          "material": "RM001",
          "barcode": "987654321",
          "required": "20",
          "upper_limit": "20.5",
          "lower_limit": "19.5",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM004",
          "barcode": "987654324",
          "required": "2",
          "upper_limit": "2.1",
          "lower_limit": "1.9",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM006",
          "barcode": "987654326",
          "required": "1",
          "upper_limit": "1.1",
          "lower_limit": "0.9",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM007",
          "barcode": "987654327",
          "required": "50",
          "upper_limit": "51",
          "lower_limit": "49",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM008",
          "barcode": "987654328",
          "required": "17",
          "upper_limit": "17.1",
          "lower_limit": "16.9",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM009",
          "barcode": "987654329",
          "required": "9",
          "upper_limit": "9.1",
          "lower_limit": "8.9",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM010",
          "barcode": "987654330",
          "required": "1",
          "upper_limit": "1.1",
          "lower_limit": "0.9",
          "complete": false,
          "uom": "KG",
        },
      ],
    },
    "345678": {
      "material": "MAT003",
      "size": 500,
      "uom": "KG",
      "job_items": [
        {
          "material": "RM001",
          "barcode": "987654321",
          "required": "400",
          "upper_limit": "402",
          "lower_limit": "398",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM002",
          "barcode": "987654322",
          "required": "98",
          "upper_limit": "98.5",
          "lower_limit": "97.5",
          "complete": false,
          "uom": "KG",
        },
        {
          "material": "RM011",
          "barcode": "987654331",
          "required": "2",
          "upper_limit": "2.1",
          "lower_limit": "1.9",
          "complete": false,
          "uom": "KG",
        },
      ],
    },
  };

  @override
  void initState() {
    scrollController = ScrollController();
    getAllData();
    scannerListener.addListener(listenToScanner);
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    scannerListener.removeListener(listenToScanner);
    super.dispose();
  }

  Future<dynamic> getAllData() async {
    await Future.forEach([getJobDetails(widget.jobID)], (element) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<dynamic> getJobDetails(String jobID) async {
    //TODO get Job Details from Backend Server
    jobItems = (jobDetails[widget.jobID]?["job_items"] ?? [])
        as List<Map<String, dynamic>>;
  }

  dynamic listenToScanner(String data) {
    Map<String, dynamic> scannerData = jsonDecode(data
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "selection":
        // Selection to Navigate to Next Page
        Map<String, dynamic> jobItem = scannerData["data"]["data"];
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => JobItemDetailsPage(
              jobItem: jobItem,
              jobID: widget.jobID,
            ),
          ),
        );
        break;
      case "navigation":
        navigate(scannerData["data"]);
        break;
      default:
    }
  }

  void navigate(Map<String, dynamic> data) {
    switch (data["type"]) {
      case "next":
        setState(() {
          start += 3;
          if (end + 3 >= jobItems.length) {
            end = jobItems.length - 1;
          } else {
            end += 3;
          }
        });
        break;
      case "previous":
        setState(() {
          if (end == jobItems.length - 1) {
            start -= 3;
            end = start + 2;
          } else {
            end -= 3;
            if (start - 3 < 0) {
              start = 0;
            } else {
              start -= 3;
            }
          }
        });
        break;
      case "back":
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => const JobListPage(),
          ),
        );
        break;
      default:
    }
  }

  String convertJSONtoString(Map<String, dynamic> jsonData) {
    String data = "{";
    jsonData.forEach((key, value) {
      data += '"' + key + '":"' + value.toString() + '",';
    });
    data = data.substring(0, data.length - 1);
    data += "}";
    return data;
  }

  List<Widget> getRowWidget(Map<String, dynamic> jobItem) {
    List<Widget> widgets = [];
    jobItem.forEach((key, value) {
      if (key != "complete") {
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
      }
    });

    String jobItemData =
        '{"action": "selection","data": {"type": "job_item", "data": ' +
            convertJSONtoString(jobItem) +
            '}}';
    widgets.add(
      QrImage(
        data: jobItemData,
        size: 200.0,
        foregroundColor: jobItem["complete"] ? Colors.white : Colors.black,
      ),
    );
    return widgets;
  }

  List<Widget> getJobItems(String jobID) {
    List<Widget> list = [];
    for (int iterator = start; iterator <= end; iterator++) {
      var jobItem = jobItems[iterator];
      Widget widget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: getRowWidget(jobItem),
      );
      list.add(widget);
    }

    Widget navigation = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            QrImage(
              data: back,
              size: 150,
            ),
            const Text("Back"),
          ],
        ),
        Column(
          children: [
            QrImage(
              data: previous,
              size: 150,
              foregroundColor: start == 0 ? Colors.white : Colors.black,
            ),
            start == 0 ? Container() : const Text("Previous"),
          ],
        ),
        Column(
          children: [
            QrImage(
              data: next,
              size: 150,
              foregroundColor:
                  end == jobItems.length - 1 ? Colors.white : Colors.black,
            ),
            end == jobItems.length - 1 ? Container() : const Text("Next"),
          ],
        ),
      ],
    );
    list.add(navigation);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Job ID: " + widget.jobID),
      ),
      body: isLoading
          ? Container()
          : Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DescriptionRow(
                    item: "Material",
                    description: (jobDetails[widget.jobID]?["material"] ?? "")
                        .toString(),
                  ),
                  DescriptionRow(
                    item: "Job Size",
                    description:
                        (jobDetails[widget.jobID]?["size"] ?? "").toString(),
                  ),
                  DescriptionRow(
                    item: "Unit of ",
                    description:
                        (jobDetails[widget.jobID]?["uom"] ?? "").toString(),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: getJobItems(widget.jobID),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
