import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
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
import 'package:eazyweigh/interface/home/operator_home_page.dart';
import 'package:eazyweigh/interface/job_interface/details/job_details_widget.dart';
import 'package:eazyweigh/interface/job_interface/job_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class JobListWidget extends StatefulWidget {
  const JobListWidget({Key? key}) : super(key: key);

  @override
  State<JobListWidget> createState() => _JobListWidgetState();
}

class _JobListWidgetState extends State<JobListWidget> {
  int start = 0;
  int end = 2;
  bool isLoadingData = true;
  List<JobItem> jobItems = [];
  ScrollController? scrollController;
  Map<String, List<JobItem>> jobMapping = {};
  String previous = '{"action":"navigation", "data":{"type":"previous"}}';
  String next = '{"action":"navigation", "data":{"type":"next"}}';
  String back = '{"action":"navigation", "data":{"type":"back"}}';
  Map<String, Job> jobsByID = {};

  @override
  void initState() {
    checkWeigher();
    scannerListener.addListener(listenToScanner);
    super.initState();
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    super.dispose();
  }

  Future<dynamic> checkWeigher() async {
    List<String> shiftIDs = [];
    List<String> jobIDs = [];
    if (currentUser.userRole.role == "Operator") {
      DateTime today = DateTime.now();
      Map<String, dynamic> condition = {
        "AND": [
          {
            "GREATEREQUAL": {
              "Field": "date",
              "Value": DateTime(today.year, today.month, today.day)
                  .subtract(const Duration(days: 7))
                  .toString(),
            },
          },
          {
            "LESSEQUAL": {
              "Field": "date",
              "Value": DateTime(today.year, today.month, today.day)
                  .add(const Duration(days: 7))
                  .toString(),
            },
          },
          {
            "EQUALS": {
              "Field": "user_username",
              "Value": currentUser.username,
            },
          },
        ],
      };

      await appStore.shiftScheduleApp.list(condition).then(
        (value) async {
          if (!value.containsKey("error")) {
            if (value["status"]) {
              for (var item in value["payload"]) {
                shiftIDs.add(item["id"]);
              }
              if (shiftIDs.isNotEmpty) {
                Map<String, dynamic> conditions = {
                  "IN": {
                    "Field": "shift_schedule_id",
                    "Value": shiftIDs,
                  },
                };
                await appStore.jobItemAssignmentApp
                    .list(conditions)
                    .then((response) async {
                  if (response["status"]) {
                    for (var item in response["payload"]) {
                      JobItem jobItem = JobItem.fromJSON(item["job_item"]);
                      if (!jobIDs.contains(item["job_item"]["job_id"])) {
                        jobIDs.add(item["job_item"]["job_id"]);
                        jobMapping[item["job_item"]["job_id"]] = [jobItem];
                      } else {
                        jobMapping[item["job_item"]["job_id"]]?.add(jobItem);
                      }
                    }
                    if (jobIDs.isNotEmpty) {
                      Map<String, dynamic> jobConditions = {
                        "IN": {
                          "Field": "id",
                          "Value": jobIDs,
                        },
                      };
                      await appStore.jobApp
                          .list(jobConditions)
                          .then((value) async {
                        if (value["status"]) {
                          for (var job in value["payload"]) {
                            Job thisJob = Job.fromJSON(job);
                            jobsByID[job["id"]] = thisJob;
                          }
                        } else {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                message: value["message"],
                                title: "Error",
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
                          message: response["message"],
                          title: "Error",
                        );
                      },
                    );
                  }
                });
              } else {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomDialog(
                      message: "No Shift Assignment Found.",
                      title: "Error",
                    );
                  },
                ).then((value) {
                  logout(context);
                });
              }
            } else {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    message: value["message"],
                    title: "Error",
                  );
                },
              );
            }
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  message: "Unable to Connect to Server.",
                  title: "Error",
                );
              },
            );
          }
        },
      ).then((value) {
        setState(() {
          isLoadingData = false;
        });
      });
    } else {
      setState(() {
        isLoadingData = false;
      });
    }
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
        String id = scannerData["data"]["data"].toString().replaceAll("_", "-");
        String jobCode = scannerData["data"]["job_code"].toString();
        // Selection to Navigate to Next Page
        navigationService.pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) => JobDetailsWidget(
              jobItems: (jobMapping[id])!,
              jobCode: jobCode,
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
          if (start + 3 <= jobsByID.length) {
            start += 3;
            if (end + 3 > jobsByID.length) {
              end = jobsByID.length - 1;
            } else {
              end += 3;
            }
          }
        });
        break;
      case "previous":
        setState(() {
          if (start - 3 >= 0) {
            if (end == jobsByID.length - 1) {
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
        currentUser.userRole.role == "Operator"
            ? navigationService.pushReplacement(
                CupertinoPageRoute(
                  builder: (BuildContext context) => const OperatorHomePage(),
                ),
              )
            : navigationService.pushReplacement(
                CupertinoPageRoute(
                  builder: (BuildContext context) => const JobWidget(),
                ),
              );
        break;
      default:
    }
  }

  List<Widget> getRowWidget(Job job, ScreenSizeInformation sizeInfo) {
    List<Widget> widgets = [];
    if (!job.complete) {
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
                    job.material.code + " - " + job.material.description,
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
                  "Job Size",
                  style: TextStyle(
                    fontSize: 9.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  job.quantity.toString() + " " + job.uom.code,
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
                  "Items",
                  style: TextStyle(
                    fontSize: 9.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  (jobMapping[job.id]?.length).toString(),
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
        '{"action": "selection","data": {"type": "job","job_code":"' +
            job.jobCode +
            '", "data": "' +
            job.id +
            '"}}';
    widgets.add(
      TextButton(
        onPressed: () {
          navigationService.pushReplacement(
            CupertinoPageRoute(
              builder: (BuildContext context) => JobDetailsWidget(
                jobItems: (jobMapping[job.id])!,
                jobCode: job.jobCode,
              ),
            ),
          );
        },
        child: QrImage(
          data: jobItemData,
          size: 250.0 * sizeInfo.screenSize.width / 1920,
          backgroundColor: Colors.green,
          foregroundColor: job.complete ? backgroundColor : Colors.black,
        ),
      ),
    );
    return widgets;
  }

  List<Widget> getJobs(ScreenSizeInformation sizeInfo) {
    List<Widget> widgets = [];
    jobsByID.forEach((key, value) {
      Widget widget = Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: getRowWidget(value, sizeInfo),
      );
      widgets.add(
        SizedBox(
          width: sizeInfo.screenSize.width / 3 - 20,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: widget,
          ),
        ),
      );
    });
    return widgets;
  }

  Widget weigherlistWidget() {
    Widget navigation = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            TextButton(
              onPressed: () {
                navigationService.pushReplacement(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => const OperatorHomePage(),
                  ),
                );
              },
              child: QrImage(
                data: back,
                size: 150,
                backgroundColor: Colors.green,
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
                    if (end == jobsByID.length) {
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
                backgroundColor: start == 0 ? Colors.transparent : Colors.green,
                foregroundColor: start == 0 ? backgroundColor : Colors.black,
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
                  if (start + 3 <= jobsByID.length) {
                    start += 3;
                    if (end + 3 >= jobsByID.length) {
                      end = jobsByID.length;
                    } else {
                      end += 3;
                    }
                  }
                });
              },
              child: QrImage(
                data: next,
                size: 150,
                backgroundColor:
                    (end == jobMapping.length - 1 || jobMapping.length < 3)
                        ? Colors.transparent
                        : Colors.green,
                foregroundColor:
                    (end == jobMapping.length - 1 || jobMapping.length < 3)
                        ? backgroundColor
                        : Colors.black,
              ),
            ),
            (end == jobMapping.length - 1 || jobMapping.length < 3)
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
    return BaseWidget(builder: (context, screenSizeInfo) {
      return jobMapping.isEmpty
          ? SizedBox(
              height: screenSizeInfo.screenSize.height - 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "No Jobs Found.",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  navigation,
                ],
              ),
            )
          : SizedBox(
              height: screenSizeInfo.screenSize.height - 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: getJobs(screenSizeInfo),
                  ),
                  navigation,
                ],
              ),
            );
    });
  }

  //TODO for non-operator users
  Widget listWidget() {
    return Column();
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingData
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: buildWidget(
              currentUser.userRole.role == "Operator"
                  ? weigherlistWidget()
                  : listWidget(),
              context,
              "All Jobs",
              currentUser.userRole.role == "Operator"
                  ? () {
                      navigationService.pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const OperatorHomePage(),
                        ),
                      );
                    }
                  : () {
                      Navigator.of(context).pop();
                    },
            ),
          );
  }
}
