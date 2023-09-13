import 'dart:convert';
import 'dart:math';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/over_issue.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/date_picker/date_picker.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/home/operator_home_page.dart';
import 'package:eazyweigh/interface/over_issue_interface/details/over_issue_details_widget.dart';
import 'package:eazyweigh/interface/over_issue_interface/details/verifier_over_issue_details_widget.dart';
import 'package:eazyweigh/interface/over_issue_interface/list/hybrid_over_issue.dart';
import 'package:eazyweigh/interface/over_issue_interface/list/list.dart';
import 'package:eazyweigh/interface/over_issue_interface/over_issue_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OverIssueListWidget extends StatefulWidget {
  const OverIssueListWidget({Key? key}) : super(key: key);

  @override
  State<OverIssueListWidget> createState() => _OverIssueListWidgetState();
}

class _OverIssueListWidgetState extends State<OverIssueListWidget> {
  int start = 0;
  int end = 2;
  bool isLoadingData = true;
  bool isDataLoaded = false;
  ScrollController? scrollController;
  Map<String, Mat> materialMapping = {};
  Map<String, JobItem> jobItems = {};
  Map<String, Job> jobs = {};
  List<String> jobIDs = [];
  List<Factory> factories = [];
  String previous = '{"action":"navigation", "data":{"type":"previous"}}';
  String next = '{"action":"navigation", "data":{"type":"next"}}';
  String back = '{"action":"navigation", "data":{"type":"back"}}';
  Map<String, List<OverIssue>> jobMapping = {};
  Map<String, List<OverIssue>> passedJobMapping = {};
  List<HybridOverIssue> overIssues = [];
  late TextEditingController factoryController, startDateController, endDateController;

  @override
  void initState() {
    scannerListener.addListener(listenToScanner);
    currentUser.userRole.role == "Operator" ? checkWeigher() : getFactories();
    factoryController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    super.dispose();
  }

  void cleanJobMapping() {
    jobMapping.forEach((key, value) {
      if (value.isNotEmpty) {
        passedJobMapping[key] = value;
      }
    });
    setState(() {});
  }

  Future<dynamic> getFactories() async {
    factories = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "company_id",
        "Value": companyID,
      }
    };
    await appStore.factoryApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          Factory fact = Factory.fromJSON(item);
          factories.add(fact);
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
    }).then((value) {
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Future<dynamic> checkWeigher() async {
    List<String> shiftIDs = [];
    if (currentUser.userRole.role == "Operator") {
      DateTime today = DateTime.now();
      Map<String, dynamic> condition = {
        "AND": [
          {
            "GREATEREQUAL": {
              "Field": "date",
              "Value": DateTime(today.year, today.month, today.day).subtract(const Duration(days: 7)).toString(),
            },
          },
          {
            "LESSEQUAL": {
              "Field": "date",
              "Value": DateTime(today.year, today.month, today.day).add(const Duration(days: 7)).toString(),
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
                await appStore.jobItemAssignmentApp.list(conditions).then((response) async {
                  if (response["status"]) {
                    for (var item in response["payload"]) {
                      JobItem jobItem = JobItem.fromJSON(item["job_item"]);
                      jobItems[jobItem.id] = jobItem;
                      if (!jobMapping.containsKey(item["job_item"]["job_id"])) {
                        jobMapping[item["job_item"]["job_id"]] = [];
                        jobIDs.add(item["job_item"]["job_id"]);
                      }
                    }
                    if (jobMapping.isNotEmpty) {
                      Map<String, dynamic> jobConditions = {
                        "IN": {
                          "Field": "id",
                          "Value": jobIDs,
                        },
                      };
                      await appStore.jobApp.list(jobConditions).then((value) async {
                        if (value["status"]) {
                          for (var job in value["payload"]) {
                            Job thisJob = Job.fromJSON(job);
                            jobs[job["id"]] = thisJob;
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                message: value["message"],
                                title: "Error",
                              );
                            },
                          );
                          Future.delayed(const Duration(seconds: 3)).then((value) {
                            Navigator.of(context).pop();
                          });
                        }
                      }).then((value) async {
                        List<String> jobIDs = [];
                        jobMapping.forEach((key, value) async {
                          jobIDs.add(key);
                        });
                        Map<String, dynamic> conditions = {
                          "IN": {
                            "Field": "job_id",
                            "Value": jobIDs,
                          }
                        };
                        await appStore.overIssueApp.list(conditions).then((overIssueReposnse) {
                          if (overIssueReposnse.containsKey("status")) {
                            if (overIssueReposnse["status"]) {
                              for (var item in overIssueReposnse["payload"]) {
                                OverIssue overIssue = OverIssue.fromJSON(item);
                                if (!overIssue.weighed) {
                                  jobMapping[overIssue.jobItem.jobID]!.add(overIssue);
                                }
                              }
                              cleanJobMapping();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                    message: overIssueReposnse["message"],
                                    title: "Error",
                                  );
                                },
                              );
                              Future.delayed(const Duration(seconds: 3)).then((value) {
                                Navigator.of(context).pop();
                              });
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialog(
                                  message: "Unable to Connect.",
                                  title: "Error",
                                );
                              },
                            );
                            Future.delayed(const Duration(seconds: 3)).then((value) {
                              Navigator.of(context).pop();
                            });
                          }
                        });
                      });
                    } else {}
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                          message: response["message"],
                          title: "Error",
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
                      message: "No Shift Assignment Found.",
                      title: "Error",
                    );
                  },
                );
                Future.delayed(const Duration(seconds: 3)).then((value) {
                  Navigator.of(context).pop();
                });
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    message: value["message"],
                    title: "Error",
                  );
                },
              );
              Future.delayed(const Duration(seconds: 3)).then((value) {
                Navigator.of(context).pop();
              });
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
            Future.delayed(const Duration(seconds: 3)).then((value) {
              Navigator.of(context).pop();
            });
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
    Map<String, dynamic> scannerData = jsonDecode(data.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));

    if (scannerData.containsKey("action")) {
      switch (scannerData["action"]) {
        case "selection":
          String id = scannerData["data"]["data"].toString().replaceAll("_", "-");
          String jobCode = scannerData["data"]["job_code"].toString();
          // Selection to Navigate to Next Page
          navigationService.pushReplacement(
            CupertinoPageRoute(
              builder: (BuildContext context) => OverIssueDetailsWidget(
                jobCode: jobCode,
                overIssueItems: passedJobMapping[id]!,
                jobItems: jobItems,
              ),
            ),
          );
          break;
        case "navigation":
          navigate(scannerData["data"]);
          break;
        case "logout":
          logout();
          break;
        default:
      }
    } else {
      String jobID = scannerData["job_id"];
      navigationService.pushReplacement(
        CupertinoPageRoute(
          builder: (BuildContext context) => VerifierOverIssueDetailsWidget(
            job: jobs[jobID]!,
            jobID: jobID,
          ),
        ),
      );
    }
  }

  void navigate(Map<String, dynamic> data) {
    switch (data["type"]) {
      case "next":
        setState(() {
          if (start + 3 <= passedJobMapping.length - 1) {
            start = start + 3;
          }
          if (end + 3 <= passedJobMapping.length - 1) {
            end = end + 3;
          } else {
            end = passedJobMapping.length - 1;
          }
        });
        break;
      case "previous":
        setState(() {
          start = 0;
          end = min(2, passedJobMapping.length - 1);
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
                  builder: (BuildContext context) => const OverIssueWidget(),
                ),
              );
        break;
      default:
    }
  }

  List<Widget> getRowWidget(Job job, ScreenSizeInformation sizeInfo) {
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
                  job.material.code + " - " + job.material.description,
                  style: const TextStyle(
                    fontSize: 15.0,
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
                (passedJobMapping[job.id]?.length).toString(),
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

    String jobItemData = '{"action": "selection","data": {"type": "job","job_code":"' + job.jobCode + '", "data": "' + job.id + '"}}';
    widgets.add(
      TextButton(
        onPressed: () {
          navigationService.pushReplacement(
            CupertinoPageRoute(
              builder: (BuildContext context) => OverIssueDetailsWidget(jobCode: job.jobCode, overIssueItems: passedJobMapping[job.id]!, jobItems: jobItems),
            ),
          );
        },
        child: QrImageView(
          data: jobItemData,
          size: 250.0 * sizeInfo.screenSize.width / 1920,
          backgroundColor: Colors.green,
          foregroundColor: Colors.black,
        ),
      ),
    );
    return widgets;
  }

  List<Widget> getJobs(ScreenSizeInformation sizeInfo) {
    List<Widget> widgets = [];
    passedJobMapping.forEach((key, value) {
      Widget widget = Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: getRowWidget(jobs[key]!, sizeInfo),
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

  Widget operatorWidget() {
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
              child: QrImageView(
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
                  end = min(2, passedJobMapping.length - 1);
                });
              },
              child: QrImageView(
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
                  if (start + 3 <= passedJobMapping.length - 1) {
                    start = start + 3;
                  }
                  if (end + 3 <= passedJobMapping.length - 1) {
                    end = end + 3;
                  } else {
                    end = passedJobMapping.length - 1;
                  }
                });
              },
              child: QrImageView(
                data: next,
                size: 150,
                backgroundColor: (end == jobMapping.length - 1 || jobMapping.length < 3) ? Colors.transparent : Colors.red,
                foregroundColor: (end == jobMapping.length - 1 || jobMapping.length < 3) ? Colors.transparent : Colors.black,
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
                  Text(
                    "No Over Issues Found.",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: themeChanged.value ? foregroundColor : backgroundColor,
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

  Widget generalWidget() {
    return isDataLoaded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              overIssues.isEmpty
                  ? Text(
                      "No Over Issued Found",
                      style: TextStyle(
                        color: themeChanged.value ? foregroundColor : backgroundColor,
                        fontSize: 20.0,
                      ),
                    )
                  : Text(
                      "Over Issued Items",
                      style: TextStyle(
                        color: themeChanged.value ? foregroundColor : backgroundColor,
                        fontSize: 20.0,
                      ),
                    ),
              overIssues.isNotEmpty ? OverIssueList(overIssues: overIssues) : Container(),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropDownWidget(
                disabled: false,
                hint: "Select Factory",
                controller: factoryController,
                itemList: factories,
              ),
              DatePickerWidget(
                dateController: startDateController,
                hintText: "Created After",
                labelText: "Created After",
              ),
              DatePickerWidget(
                dateController: endDateController,
                hintText: "Created Before",
                labelText: "Created Before",
              ),
              const Divider(
                color: Colors.transparent,
              ),
              Row(
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                      elevation: MaterialStateProperty.all<double>(5.0),
                    ),
                    onPressed: () async {
                      overIssues = [];
                      String errors = "";
                      var factoryID = factoryController.text;
                      var startDate = startDateController.text;
                      var endDate = endDateController.text;
                      Map<String, dynamic> conditions = {};

                      if (factoryID.isEmpty || factoryID == "") {
                        errors += "Factory Required.\n";
                      }

                      if (errors.isEmpty && errors == "") {
                        Map<String, dynamic> factoryCondition = {
                          "EQUALS": {
                            "Field": "factory_id",
                            "Value": factoryID,
                          }
                        };
                        Map<String, dynamic> startDateCondition = {};
                        Map<String, dynamic> endDateCondition = {};
                        if (startDate.isNotEmpty) {
                          startDateCondition = {
                            "GREATEREQUAL": {
                              "Field": "created_at",
                              "Value": DateTime.parse(startDate).toString().substring(0, 10) + "T00:00:00.0Z",
                            }
                          };
                        }
                        if (startDate.isNotEmpty) {
                          endDateCondition = {
                            "LESSEQUAL": {
                              "Field": "created_at",
                              "Value": DateTime.parse(endDate).toString().substring(0, 10) + "T00:00:00.0Z",
                            }
                          };
                        }
                        if (startDateCondition.isNotEmpty || endDateCondition.isNotEmpty) {
                          conditions["AND"] = [factoryCondition];
                          if (startDateCondition.isNotEmpty) {
                            conditions["AND"].add(startDateCondition);
                          }
                          if (endDateCondition.isNotEmpty) {
                            conditions["AND"].add(endDateCondition);
                          }
                        }

                        setState(() {
                          isLoadingData = true;
                        });
                        await appStore.jobApp.list(conditions).then((value) async {
                          if (value.containsKey("status") && value["status"]) {
                            for (var item in value["payload"]) {
                              Job job = Job.fromJSON(item);
                              Map<String, dynamic> conditions = {
                                "EQUALS": {
                                  "Field": "job_id",
                                  "Value": job.id,
                                }
                              };
                              await appStore.overIssueApp.list(conditions).then((response) {
                                if (response.containsKey("status") && response["status"]) {
                                  if (response["payload"].length != 0) {
                                    for (var under in response["payload"]) {
                                      OverIssue overIssue = OverIssue.fromJSON(under);
                                      overIssues.add(HybridOverIssue(
                                        job: job,
                                        overIssue: overIssue,
                                      ));
                                    }
                                  }
                                }
                              });
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialog(
                                  message: "Unable to Get Data.",
                                  title: "Info",
                                );
                              },
                            );
                          }
                        }).then((value) {
                          setState(() {
                            isLoadingData = false;
                            isDataLoaded = true;
                          });
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              message: errors,
                              title: "Errors",
                            );
                          },
                        );
                      }
                    },
                    child: checkButton(),
                  ),
                  const VerticalDivider(
                    color: Colors.transparent,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                      elevation: MaterialStateProperty.all<double>(5.0),
                    ),
                    onPressed: () {
                      navigationService.pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => const OverIssueListWidget(),
                        ),
                      );
                    },
                    child: clearButton(),
                  ),
                ],
              ),
            ],
          );
  }

  Widget verifierlistWidget() {
    return Center(
      child: Column(
        children: [
          Text(
            "Please Scan Job Code to Proceed.",
            style: TextStyle(
              color: themeChanged.value ? foregroundColor : backgroundColor,
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

  Widget homeWidget() {
    return currentUser.userRole.role == "Operator"
        ? operatorWidget()
        : currentUser.userRole.role == "Verifier"
            ? verifierlistWidget()
            : generalWidget();
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
                  homeWidget(),
                  context,
                  "Over Issue Materials",
                  currentUser.userRole.role == "Operator" || currentUser.userRole.role == "Verifier"
                      ? () {
                          navigationService.pushReplacement(
                            CupertinoPageRoute(
                              builder: (BuildContext context) => const OperatorHomePage(),
                            ),
                          );
                        }
                      : () {
                          Navigator.of(context).pop();
                        },
                ),
              );
      },
    );
  }
}
