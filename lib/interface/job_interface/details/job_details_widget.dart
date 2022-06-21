import 'dart:convert';
import 'dart:math';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/terminals.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure_conversion.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/job_interface/details/jobs_items_list.dart';
import 'package:eazyweigh/interface/job_interface/list/job_list_widget.dart';
import 'package:eazyweigh/interface/job_item_interface/details/job_item_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class JobDetailsWidget extends StatefulWidget {
  final String jobCode;
  final List<JobItem> jobItems;
  const JobDetailsWidget({
    Key? key,
    required this.jobCode,
    required this.jobItems,
  }) : super(key: key);

  @override
  State<JobDetailsWidget> createState() => _JobDetailsWidgetState();
}

class _JobDetailsWidgetState extends State<JobDetailsWidget> {
  bool isLoadingData = true;
  int start = 0;
  int end = 3;
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
    scrollController = ScrollController();
    scannerListener.addListener(listenToScanner);
    if (currentUser.userRole.role == "Operator") {
      widget.jobItems.removeWhere((element) => element.complete);
    }
    end = min(3, widget.jobItems.length);
    widget.jobItems
        .sort((a, b) => a.complete.toString().compareTo(b.complete.toString()));
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
        terminals.sort((a, b) => a.description.compareTo(b.description));
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
      if (terminal.leastCount * scaleFactor < req &&
          terminal.capacity * scaleFactor > req) {
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
        late JobItem passedJobItem;
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
              jobCode: widget.jobCode,
              jobItem: passedJobItem,
              allJobItems: widget.jobItems,
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
          if (start + 3 <= widget.jobItems.length) {
            start += 3;
            if (end + 3 > widget.jobItems.length) {
              end = widget.jobItems.length - 1;
            } else {
              end += 3;
            }
          }
        });
        break;
      case "previous":
        setState(() {
          if (start - 3 >= 0) {
            if (end == widget.jobItems.length - 1) {
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

  List<Widget> getRowWidget(JobItem jobItem, ScreenSizeInformation sizeInfo) {
    List<Widget> widgets = [];
    bool isComplete = jobItem.actualWeight <= jobItem.upperBound &&
        jobItem.actualWeight >= jobItem.lowerBound;
    if (!isComplete) {
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
                    jobItem.material.code +
                        " - " +
                        jobItem.material.description,
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
                  (jobItem.requiredWeight - jobItem.actualWeight)
                      .toStringAsFixed(3),
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
                  assignTerminal(jobItem.requiredWeight, jobItem.upperBound,
                      jobItem.lowerBound, jobItem.uom.code),
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
    }

    String jobItemData =
        '{"action": "selection","data": {"type": "job_item", "data": "' +
            jobItem.id +
            '"}}';
    widgets.add(
      TextButton(
        onPressed: () {
          navigationService.pushReplacement(
            CupertinoPageRoute(
              builder: (BuildContext context) => JobItemDetailsWidget(
                jobCode: widget.jobCode,
                jobItem: jobItem,
                allJobItems: widget.jobItems,
              ),
            ),
          );
        },
        child: QrImage(
          data: jobItemData,
          size: 250.0 * sizeInfo.screenSize.width / 1920,
          backgroundColor: isComplete ? Colors.transparent : Colors.green,
          foregroundColor: isComplete ? Colors.transparent : Colors.black,
        ),
      ),
    );
    return widgets;
  }

  List<Widget> getJobItems(ScreenSizeInformation screenSizeInformation) {
    List<Widget> list = [];
    print(start);
    print(end);
    for (var i = start; i < end; i++) {
      JobItem jobItem = widget.jobItems[i];
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
            children: getRowWidget(jobItem, screenSizeInformation),
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
                    builder: (BuildContext context) => const JobListWidget(),
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
                  if (start - 3 >= 0) {
                    if (end == widget.jobItems.length) {
                      start -= 3;
                      end = start + 3;
                    } else {
                      end -= 3;
                      if (start - 3 < 0) {
                        start = 0;
                      } else {
                        start -= 3;
                      }
                    }
                  }
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
                  if (start + 3 < widget.jobItems.length) {
                    start += 3;
                    if (end + 3 > widget.jobItems.length) {
                      end = widget.jobItems.length;
                    } else {
                      end += 3;
                    }
                  }
                });
              },
              child: QrImage(
                data: next,
                size: 150,
                backgroundColor: (end == widget.jobItems.length ||
                        widget.jobItems.length < 3)
                    ? Colors.transparent
                    : Colors.red,
                foregroundColor: (end == widget.jobItems.length ||
                        widget.jobItems.length < 3)
                    ? Colors.transparent
                    : Colors.black,
              ),
            ),
            (end == widget.jobItems.length || widget.jobItems.length < 3)
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
    return currentUser.userRole.role == "Operator"
        ? BaseWidget(
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
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Job Items for Job: " + widget.jobCode,
                style: TextStyle(
                  color: themeChanged.value ? foregroundColor : backgroundColor,
                  fontSize: 50.0,
                ),
              ),
              JobItemsList(
                jobs: widget.jobItems,
                jobCode: widget.jobCode,
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeChanged,
      builder: (_, theme, child) {
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
                        builder: (BuildContext context) =>
                            const JobListWidget(),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
