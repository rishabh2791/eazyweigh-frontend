import 'dart:convert';
import 'dart:math';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/under_issue.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/date_picker/date_picker.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/home/operator_home_page.dart';
import 'package:eazyweigh/interface/under_issue_interface/details/under_issue_details_widget.dart';
import 'package:eazyweigh/interface/under_issue_interface/details/verifier_under_issue_details_widget.dart';
import 'package:eazyweigh/interface/under_issue_interface/list/hybrid_under_issue.dart';
import 'package:eazyweigh/interface/under_issue_interface/list/list.dart';
import 'package:eazyweigh/interface/under_issue_interface/under_issue_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UnderIssueListWidget extends StatefulWidget {
  const UnderIssueListWidget({Key? key}) : super(key: key);

  @override
  State<UnderIssueListWidget> createState() => _UnderIssueListWidgetState();
}

class _UnderIssueListWidgetState extends State<UnderIssueListWidget> {
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
  Map<String, List<UnderIssue>> jobMapping = {};
  Map<String, List<UnderIssue>> passedJobMapping = {};
  List<HybridUnderIssue> underIssues = [];
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
        await Future.forEach(response["payload"], (dynamic item) async {
          Factory factory = await Factory.fromServer(Map<String, dynamic>.from(item));
          factories.add(factory);
        }).then((value) {
          setState(() {
            isLoadingData = false;
          });
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              message: response["message"],
              title: "Errors",
            );
          },
        );
        Future.delayed(const Duration(seconds: 3)).then((value) {
          Navigator.of(context).pop();
        });
      }
    }).then((value) {
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Future<dynamic> checkWeigher() async {
    List<String> shiftIDs = [];
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
                  await Future.forEach(response["payload"], (dynamic item) async {
                    JobItem jobItem = await JobItem.fromServer(Map<String, dynamic>.from(item["job_item"]));
                    jobItems[jobItem.id] = jobItem;
                    if (!jobMapping.containsKey(item["job_item"]["job_id"])) {
                      jobMapping[item["job_item"]["job_id"]] = [];
                      jobIDs.add(item["job_item"]["job_id"]);
                    }
                  }).then((value) async {
                    if (jobMapping.isNotEmpty) {
                      Map<String, dynamic> jobConditions = {
                        "IN": {
                          "Field": "id",
                          "Value": jobIDs,
                        },
                      };
                      await appStore.jobApp.list(jobConditions).then((value) async {
                        if (value["status"]) {
                          await Future.forEach(value["payload"], (dynamic job) async {
                            Job thisJob = await Job.fromServer(Map<String, dynamic>.from(job));
                            jobs[job["id"]] = thisJob;
                          });
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
                        jobMapping.forEach((key, value) async {
                          await appStore.overIssueApp.list(key).then((underIssueReposnse) async {
                            if (underIssueReposnse.containsKey("status")) {
                              if (underIssueReposnse["status"]) {
                                await Future.forEach(underIssueReposnse["payload"], (dynamic item) async {
                                  UnderIssue underIssue = await UnderIssue.fromServer(Map<String, dynamic>.from(item));
                                  if (!underIssue.weighed) {
                                    jobMapping[key]!.add(underIssue);
                                  }
                                }).then((value) {
                                  cleanJobMapping();
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                      message: underIssueReposnse["message"],
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
                      });
                    } else {}
                  });
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
              builder: (BuildContext context) => UnderIssueDetailsWidget(
                jobCode: jobCode,
                jobItems: jobItems,
                underIssueItems: passedJobMapping[id]!,
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
          builder: (BuildContext context) => VerifierUnderIssueDetailsWidget(
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
                  builder: (BuildContext context) => const UnderIssueWidget(),
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
              builder: (BuildContext context) => UnderIssueDetailsWidget(jobCode: job.jobCode, underIssueItems: passedJobMapping[job.id]!, jobItems: jobItems),
            ),
          );
        },
        child: QrImageView(
          data: jobItemData,
          size: 250.0 * sizeInfo.screenSize.width / 1920,
          backgroundColor: Colors.green,
          eyeStyle: const QrEyeStyle(color: Colors.black),
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
                eyeStyle: QrEyeStyle(color: start == 0 ? backgroundColor : Colors.black),
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
                backgroundColor: (end == passedJobMapping.length - 1 || passedJobMapping.length < 3) ? Colors.transparent : Colors.red,
                eyeStyle: QrEyeStyle(color: (end == passedJobMapping.length - 1 || passedJobMapping.length < 3) ? backgroundColor : Colors.black),
              ),
            ),
            (end == passedJobMapping.length - 1 || passedJobMapping.length < 3)
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
      return passedJobMapping.isEmpty
          ? SizedBox(
              height: screenSizeInfo.screenSize.height - 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "No Under Issues Found.",
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

  Widget verifierlistWidget() {
    return Center(
      child: Column(
        children: [
          const Text(
            "Please Scan Job Code to Proceed.",
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

  Widget generalWidget() {
    return isDataLoaded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              underIssues.isEmpty
                  ? const Text(
                      "No Under Issued Found",
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 20.0,
                      ),
                    )
                  : const Text(
                      "Under Issued Items",
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 20.0,
                      ),
                    ),
              UnderIssueList(underIssues: underIssues),
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
                      underIssues = [];
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
                            await Future.forEach(value["payload"], (dynamic item) async {
                              Job job = await Job.fromServer(Map<String, dynamic>.from(item));
                              await appStore.overIssueApp.list(job.id).then((response) async {
                                if (response.containsKey("status") && response["status"]) {
                                  if (response["payload"].length != 0) {
                                    await Future.forEach(response["payload"], (dynamic over) async {
                                      underIssues.add(await HybridUnderIssue.fromServer({
                                        "job_id": job.id,
                                        "over_issue_id": over["id"],
                                      }));
                                    });
                                  }
                                }
                              });
                            });
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
                          builder: (BuildContext context) => const UnderIssueListWidget(),
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

  Widget homeWidget() {
    return currentUser.userRole.role == "Operator"
        ? operatorWidget()
        : currentUser.userRole.role == "Verifier"
            ? verifierlistWidget()
            : generalWidget();
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingData
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: buildWidget(
              homeWidget(),
              context,
              "Under Issue Materials",
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
  }
}
