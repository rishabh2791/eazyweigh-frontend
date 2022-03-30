import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/terminals.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure_conversion.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/job_interface/list/job_list_widget.dart';
import 'package:eazyweigh/interface/job_item_interface/details/job_item_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class JobDetailsWidget extends StatefulWidget {
  final List<JobItem> jobItems;
  const JobDetailsWidget({
    Key? key,
    required this.jobItems,
  }) : super(key: key);

  @override
  State<JobDetailsWidget> createState() => _JobDetailsWidgetState();
}

class _JobDetailsWidgetState extends State<JobDetailsWidget> {
  bool isLoadingData = true;
  int start = 0;
  int end = 2;
  bool isLoading = true;
  List<Map<String, dynamic>> jobItems = [];
  ScrollController? scrollController;
  List<Terminal> terminals = [];
  List<UnitOfMeasurementConversion> uomConversions = [];
  String previous = '{"action":"navigation", "data":{"type":"previous"}}';
  String next = '{"action":"navigation", "data":{"type":"next"}}';
  String back = '{"action":"navigation", "data":{"type":"back"}}';

  @override
  void initState() {
    getAllData();
    scrollController = ScrollController();
    scannerListener.addListener(listenToScanner);
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    scannerListener.removeListener(listenToScanner);
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
    });
  }

  Future<dynamic> getUOMConversions() async {
    uomConversions = [];
    Map<String, dynamic> conditions = {
      "factory_id": widget.jobItems[0].material.factoryID,
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
      "factory_id": widget.jobItems[0].material.factoryID,
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

  String assignTerminal(double req, String uomCode) {
    String scales = "";
    for (var terminal in terminals) {
      double scaleFactor = getScaleFactor(terminal.uom.code, uomCode);
      if (req <= 0.9 * terminal.capacity * scaleFactor &&
          req > terminal.leastCount * scaleFactor &&
          req > 0.1 * terminal.capacity * scaleFactor) {
        scales += terminal.description + "\n";
      }
    }
    return scales;
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
        var passedJobItem;
        String id = scannerData["data"]["data"].toString().replaceAll("_", "-");
        for (var jobItem in widget.jobItems) {
          if (jobItem.id == id) {
            passedJobItem = jobItem;
          }
        }
        // Selection to Navigate to Next Page
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => JobItemDetailsWidget(
              jobItem: passedJobItem,
              allJobItems: widget.jobItems,
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
            builder: (BuildContext context) => const JobListWidget(),
          ),
        );
        break;
      default:
    }
  }

  List<Widget> getRowWidget(JobItem jobItem) {
    List<Widget> widgets = [];
    bool isComplete = jobItem.actualWeight <= jobItem.upperBound &&
        jobItem.actualWeight >= jobItem.lowerBound;
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
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
            "Quantity",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          Text(
            jobItem.requiredWeight.toString(),
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
            "Suggestes Scales",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          Text(
            assignTerminal(jobItem.requiredWeight, jobItem.uom.code),
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
    if (isComplete) {
      widgets.add(
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 50.0,
        ),
      );
    }

    String jobItemData =
        '{"action": "selection","data": {"type": "job_item", "data": "' +
            jobItem.id +
            '"}}';
    widgets.add(
      QrImage(
        data: jobItemData,
        size: 200.0,
        backgroundColor: isComplete ? Colors.transparent : Colors.green,
        foregroundColor: isComplete ? Colors.transparent : Colors.black,
      ),
    );
    return widgets;
  }

  List<Widget> getJobItems() {
    List<Widget> list = [];
    for (var jobItem in widget.jobItems) {
      Widget widget = Padding(
        padding: const EdgeInsets.fromLTRB(
          0.0,
          0.0,
          0.0,
          10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: getRowWidget(jobItem),
        ),
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
              backgroundColor: Colors.green,
            ),
            const Text(
              "Back",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Column(
          children: [
            QrImage(
              data: previous,
              size: 150,
              backgroundColor: start == 0 ? Colors.transparent : Colors.green,
              foregroundColor: start == 0 ? Colors.transparent : Colors.black,
            ),
            start == 0
                ? Container()
                : const Text(
                    "Previous",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
        Column(
          children: [
            QrImage(
              data: next,
              size: 150,
              backgroundColor:
                  (end == jobItems.length - 1 || widget.jobItems.length < 3)
                      ? Colors.transparent
                      : Colors.green,
              foregroundColor:
                  (end == jobItems.length - 1 || widget.jobItems.length < 3)
                      ? Colors.transparent
                      : Colors.black,
            ),
            (end == jobItems.length - 1 || widget.jobItems.length < 3)
                ? Container()
                : const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ],
    );

    list.add(navigation);
    return list;
  }

  Widget listWidget() {
    return Column(
      children: getJobItems(),
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
              listWidget(),
              context,
              "All Job Items",
              () {
                navigationService.pushReplacement(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => const JobListWidget(),
                  ),
                );
              },
            ),
          );
  }
}
