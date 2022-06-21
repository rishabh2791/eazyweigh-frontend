import 'dart:convert';
import 'dart:math';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/terminals.dart';
import 'package:eazyweigh/domain/entity/under_issue.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure_conversion.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/under_issue_interface/details/under_issue_item_details_page.dart';
import 'package:eazyweigh/interface/under_issue_interface/list/under_issue_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UnderIssueDetailsWidget extends StatefulWidget {
  final String jobCode;
  final List<UnderIssue> underIssueItems;
  final Map<String, JobItem> jobItems;
  const UnderIssueDetailsWidget({
    Key? key,
    required this.jobCode,
    required this.jobItems,
    required this.underIssueItems,
  }) : super(key: key);

  @override
  State<UnderIssueDetailsWidget> createState() => _UnderIssueDetailsWidgetState();
}

class _UnderIssueDetailsWidgetState extends State<UnderIssueDetailsWidget> {
  bool isLoadingData = true;
  int start = 0;
  int end = 2;
  bool isLoading = true;
  ScrollController? scrollController;
  List<Terminal> terminals = [];
  List<UnitOfMeasurementConversion> uomConversions = [];
  String previous = '{"action":"navigation", "data":{"type":"previous"}}';
  String next = '{"action":"navigation", "data":{"type":"next"}}';
  String back = '{"action":"navigation", "data":{"type":"back"}}';

  @override
  void initState() {
    getAllData();
    end = min(end, widget.underIssueItems.length - 1);
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
      "factory_id": (widget.jobItems[widget.underIssueItems[0].jobItem.id])!.material.factoryID,
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
      "factory_id": (widget.jobItems[widget.underIssueItems[0].jobItem.id])!.material.factoryID,
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

  String assignTerminal(
    double req,
    double upperBound,
    double lowerBound,
    String uomCode,
  ) {
    String scales = "";
    double precision = min(upperBound - req, req - lowerBound);
    for (var terminal in terminals) {
      double scaleFactor = getScaleFactor(terminal.uom.code, uomCode);
      if (terminal.leastCount < precision && req > 0.1 * terminal.capacity * scaleFactor) {
        scales += terminal.description + "\n";
      }
    }
    return scales.split("\n")[0];
  }

  dynamic listenToScanner(String data) {
    Map<String, dynamic> scannerData =
        jsonDecode(data.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "selection":
        late UnderIssue passedUnderIssueItem;
        String id = scannerData["data"]["data"].toString().replaceAll("_", "-");
        for (var underIssueItem in widget.underIssueItems) {
          if (underIssueItem.id == id) {
            passedUnderIssueItem = underIssueItem;
          }
        }
        // Selection to Navigate to Next Page
        navigationService.push(
          CupertinoPageRoute(
            builder: (BuildContext context) => UnderIssueItemDetailsWidget(
              underIssue: passedUnderIssueItem,
              jobItem: widget.jobItems[passedUnderIssueItem.jobItem.id]!,
              jobCode: widget.jobCode,
            ),
          ),
        );
        break;
      case "navigation":
        navigate(scannerData["data"]);
        break;
      case "logout":
        logout(context);
        break;
      default:
    }
  }

  void navigate(Map<String, dynamic> data) {
    switch (data["type"]) {
      case "next":
        setState(() {
          if (start + 3 <= widget.underIssueItems.length - 1) {
            start = start + 3;
          }
          if (end + 3 <= widget.underIssueItems.length - 1) {
            end = end + 3;
          } else {
            end = widget.underIssueItems.length - 1;
          }
        });
        break;
      case "previous":
        setState(() {
          start = 0;
          end = min(2, widget.underIssueItems.length - 1);
        });
        break;
      case "back":
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => const UnderIssueListWidget(),
          ),
        );
        break;
      default:
    }
  }

  List<Widget> getRowWidget(JobItem jobItem, UnderIssue underIssue, ScreenSizeInformation sizeInfo) {
    List<Widget> widgets = [];

    widgets.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: sizeInfo.screenSize.width - 1200,
            child: Column(
              children: [
                const Text(
                  "Material",
                  style: TextStyle(
                    fontSize: 9.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  jobItem.material.code + " - " + jobItem.material.description,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.transparent,
            height: 10.0,
          ),
          Column(
            children: [
              const Text(
                "Required",
                style: TextStyle(
                  fontSize: 9.0,
                  color: Colors.white,
                ),
              ),
              Text(
                (underIssue.req - underIssue.actual).toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.transparent,
            height: 10.0,
          ),
          Column(
            children: [
              const Text(
                "Suggested Scale",
                style: TextStyle(
                  fontSize: 9.0,
                  color: Colors.white,
                ),
              ),
              Text(
                assignTerminal(jobItem.requiredWeight, jobItem.upperBound, jobItem.lowerBound, jobItem.uom.code),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.transparent,
            height: 10.0,
          ),
        ],
      ),
    );

    String jobItemData = '{"action": "selection","data": {"type": "under_issue_item", "data": "' + underIssue.id + '"}}';
    widgets.add(
      TextButton(
        onPressed: () {
          navigationService.push(
            CupertinoPageRoute(
              builder: (BuildContext context) => UnderIssueItemDetailsWidget(
                underIssue: underIssue,
                jobItem: widget.jobItems[underIssue.jobItem.id]!,
                jobCode: widget.jobCode,
              ),
            ),
          );
        },
        child: QrImage(
          data: jobItemData,
          size: 250.0 * sizeInfo.screenSize.width / 1920,
          backgroundColor: Colors.green,
          foregroundColor: Colors.black,
        ),
      ),
    );
    return widgets;
  }

  List<Widget> getJobItems(ScreenSizeInformation screenSizeInformation) {
    List<Widget> list = [];
    for (var i = start; i <= end; i++) {
      UnderIssue underIssueItem = widget.underIssueItems[i];
      Widget wid = SizedBox(
        width: screenSizeInformation.screenSize.width / 3 - 20,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            0.0,
            0.0,
            0.0,
            10.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getRowWidget(widget.jobItems[underIssueItem.jobItem.id]!, underIssueItem, screenSizeInformation),
          ),
        ),
      );
      list.add(wid);
    }
    return list;
  }

  Widget listWidget() {
    Widget navigation = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            TextButton(
              onPressed: () {
                navigationService.pushReplacement(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => const UnderIssueListWidget(),
                  ),
                );
              },
              child: QrImage(
                data: back,
                size: 150,
                backgroundColor: Colors.red,
              ),
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
            TextButton(
              onPressed: () {
                setState(() {
                  start = 0;
                  end = min(2, widget.underIssueItems.length - 1);
                });
              },
              child: QrImage(
                data: previous,
                size: 150,
                backgroundColor: start == 0 ? Colors.transparent : Colors.red,
                foregroundColor: start == 0 ? Colors.transparent : Colors.black,
              ),
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
            TextButton(
              onPressed: () {
                setState(() {
                  if (start + 3 <= widget.underIssueItems.length - 1) {
                    start = start + 3;
                  }
                  if (end + 3 <= widget.underIssueItems.length - 1) {
                    end = end + 3;
                  } else {
                    end = widget.underIssueItems.length - 1;
                  }
                });
              },
              child: QrImage(
                data: next,
                size: 150,
                backgroundColor: (end == widget.underIssueItems.length - 1 || widget.underIssueItems.length < 3) ? Colors.transparent : Colors.red,
                foregroundColor: (end == widget.underIssueItems.length - 1 || widget.underIssueItems.length < 3) ? Colors.transparent : Colors.black,
              ),
            ),
            (end == widget.underIssueItems.length - 1 || widget.underIssueItems.length < 3)
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
    return BaseWidget(
      builder: (context, screenSizeInfo) {
        return SizedBox(
          height: screenSizeInfo.screenSize.height - 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: getJobItems(screenSizeInfo),
              ),
              navigation
            ],
          ),
        );
      },
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
              "Under Issue Materials",
              () {
                navigationService.pushReplacement(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => const UnderIssueListWidget(),
                  ),
                );
              },
            ),
          );
  }
}
