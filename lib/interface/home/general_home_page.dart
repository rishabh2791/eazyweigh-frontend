import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/job_item_assignment.dart';
import 'package:eazyweigh/domain/entity/over_issue.dart';
import 'package:eazyweigh/domain/entity/scanned_data.dart';
import 'package:eazyweigh/domain/entity/under_issue.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/job_interface/list/jobs_list.dart';
import 'package:flutter/material.dart';

class GeneralHomeWidget extends StatefulWidget {
  const GeneralHomeWidget({Key? key}) : super(key: key);

  @override
  State<GeneralHomeWidget> createState() => _GeneralHomeWidgetState();
}

class _GeneralHomeWidgetState extends State<GeneralHomeWidget> {
  bool isLoadingPage = true;
  late DateTime thisWeekStart, thisMonthStart, thisWeekEnd, thisMonthEnd, today = DateTime.parse(DateTime.now().toString().substring(0, 10));
  Map<String, List<ScannedData>> weekIncorrectWeighing = {}, monthIncorrectWeighing = {};
  List<String> weekJobIDs = [], monthJobIDs = [];
  List<Job> weekJobs = [], monthJobs = [];
  double weekJobWeights = 0, monthJobWeights = 0;
  List<UnderIssue> weekUnderIssuedItem = [], monthUnderIssuedItem = [];
  List<OverIssue> weekOverIssuedItems = [], monthOverIssuedItems = [];
  int weekJobsCompleted = 0, monthJobsComplete = 0;
  int weekIncorrectScans = 0, monthIncorrectScans = 0;
  Map<String, double> weekOperatorWeight = {}, monthOperatorWeight = {};

  @override
  void initState() {
    getAllDetails();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> getAllDetails() async {
    var dayOfWeek = today.weekday;
    thisWeekStart = DateTime.parse(today.subtract(Duration(days: dayOfWeek - 1)).toString().substring(0, 10));
    thisWeekEnd = DateTime.parse(today.add(Duration(days: 7 - dayOfWeek)).toString().substring(0, 10));
    thisMonthStart = DateTime.parse(DateTime(today.year, today.month, 1, 0, 0, 0, 0, 0).toString().substring(0, 10));
    DateTime nextMonth = DateTime(today.year, today.month + 1, today.day);
    int daysLeftInMonth = nextMonth.difference(today).inDays - today.day;
    thisMonthEnd = DateTime.parse(DateTime(today.year, today.month, today.day + daysLeftInMonth, 0, 0, 0, 0, 0).toString().substring(0, 10));
    Future.wait([
      getWeekSummary(),
      getMonthSummary(),
    ]).then((value) {
      weekIncorrectWeighing.forEach(((key, value) {
        weekIncorrectScans += value.length;
      }));
      monthIncorrectWeighing.forEach(((key, value) {
        monthIncorrectScans += value.length;
      }));
    }).then((value) async {
      await getJobs();
    }).then((value) {
      setState(() {
        isLoadingPage = false;
      });
    });
  }

  Future<dynamic> getJobs() async {
    Set ids = {...weekJobIDs};
    ids.addAll(monthJobIDs);
    Map<String, dynamic> conditions = {
      "IN": {
        "Field": "id",
        "Value": ids.toList(),
      }
    };
    await appStore.jobApp.list(conditions).then((response) {
      if (response.containsKey("status") && response["status"]) {
        for (var item in response["payload"]) {
          Job job = Job.fromJSON(item);
          if (weekJobIDs.contains(job.id)) {
            weekJobs.add(job);
            if (job.complete) {
              weekJobsCompleted += 1;
            }
          }
          if (monthJobIDs.contains(job.id)) {
            monthJobs.add(job);
            if (job.complete) {
              monthJobsComplete += 1;
            }
          }
        }
      }
    });
    weekJobs.sort(((a, b) => a.jobCode.compareTo(b.jobCode)));
    monthJobs.sort(((a, b) => a.jobCode.compareTo(b.jobCode)));
  }

  Future<dynamic> getIncorrectWeighing(String period) async {
    Map<String, dynamic> dateConditions = {};

    switch (period) {
      case "month":
        dateConditions = {
          "AND": [
            {
              "GREATEREQUAL": {
                "Field": "created_at",
                "Value": thisMonthStart.toString() + "T00:00:00.0Z",
              },
            },
            {
              "LESSEQUAL": {
                "Field": "created_at",
                "Value": DateTime.parse(thisMonthEnd.add(const Duration(days: 1)).toString().substring(0, 10)).toString() + "T00:00:00.0Z",
              },
            }
          ]
        };
        break;
      case "week":
        dateConditions = {
          "AND": [
            {
              "GREATEREQUAL": {
                "Field": "created_at",
                "Value": thisWeekStart.toString() + "T00:00:00.0Z",
              },
            },
            {
              "LESSEQUAL": {
                "Field": "created_at",
                "Value": DateTime.parse(thisWeekEnd.add(const Duration(days: 1)).toString().substring(0, 10)).toString() + "T00:00:00.0Z",
              },
            }
          ]
        };
        break;
      default:
    }
    Map<String, List<ScannedData>> incorrectWeighing = {};
    await appStore.scannedDataApp.list(dateConditions).then((response) async {
      if (response.containsKey("status") && response["status"]) {
        for (var item in response["payload"]) {
          ScannedData scannedData = ScannedData.fromJSON(item);
          if (incorrectWeighing.containsKey(scannedData.weigher.firstName + " " + scannedData.weigher.lastName)) {
            incorrectWeighing[scannedData.weigher.firstName + " " + scannedData.weigher.lastName]!.add(scannedData);
          } else {
            incorrectWeighing[scannedData.weigher.firstName + " " + scannedData.weigher.lastName] = [scannedData];
          }
        }
      }
    });
    return incorrectWeighing;
  }

  Future<dynamic> getUnderIssues(List<String> jobs) async {
    List<UnderIssue> underIssues = [];
    for (var job in jobs) {
      await appStore.underIssueApp.list(job).then((response) async {
        if (response.containsKey("status") && response["status"]) {
          for (var item in response["payload"]) {
            UnderIssue underIssue = UnderIssue.fromJSON(item);
            underIssues.add(underIssue);
          }
        }
      });
    }
    return underIssues;
  }

  Future<dynamic> getOverIssues(List<String> jobs) async {
    List<OverIssue> overIssues = [];
    for (var job in jobs) {
      await appStore.overIssueApp.list(job).then((response) async {
        if (response.containsKey("status") && response["status"]) {
          for (var item in response["payload"]) {
            OverIssue overIssue = OverIssue.fromJSON(item);
            overIssues.add(overIssue);
          }
        }
      });
    }
    return overIssues;
  }

  Future<dynamic> getWeekSummary() async {
    List<String> shiftScheduleIDs = [];
    Map<String, dynamic> dateConditions = {
      "AND": [
        {
          "GREATEREQUAL": {
            "Field": "date",
            "Value": thisWeekStart.toUtc().toString().substring(0, 10) + "T00:00:00.0Z",
          },
        },
        {
          "LESSEQUAL": {
            "Field": "date",
            "Value": DateTime.parse(thisWeekEnd.add(const Duration(days: 1)).toString()).toUtc().toString().substring(0, 10) + "T00:00:00.0Z",
          },
        }
      ]
    };
    await appStore.shiftScheduleApp.list(dateConditions).then((response) async {
      if (response.containsKey("status") && response["status"]) {
        for (var item in response["payload"]) {
          if (!shiftScheduleIDs.contains(item["id"])) {
            shiftScheduleIDs.add(item["id"]);
          }
        }
        Map<String, dynamic> shiftCondition = {
          "IN": {
            "Field": "shift_schedule_id",
            "Value": shiftScheduleIDs,
          }
        };
        if (shiftScheduleIDs.isNotEmpty) {
          await appStore.jobItemAssignmentApp.list(shiftCondition).then((response) {
            if (response.containsKey("status") && response["status"]) {
              for (var item in response["payload"]) {
                JobItemAssignment jobItemAssignment = JobItemAssignment.fromJSON(item);
                if (!weekJobIDs.contains(jobItemAssignment.jobItem.jobID)) {
                  weekJobIDs.add(jobItemAssignment.jobItem.jobID);
                }
                weekJobWeights += jobItemAssignment.jobItem.requiredWeight;
                if (weekOperatorWeight
                    .containsKey(jobItemAssignment.shiftSchedule.weigher.firstName + " " + jobItemAssignment.shiftSchedule.weigher.lastName)) {
                  weekOperatorWeight[jobItemAssignment.shiftSchedule.weigher.firstName + " " + jobItemAssignment.shiftSchedule.weigher.lastName] =
                      weekOperatorWeight[
                              jobItemAssignment.shiftSchedule.weigher.firstName + " " + jobItemAssignment.shiftSchedule.weigher.lastName]! +
                          jobItemAssignment.jobItem.requiredWeight;
                } else {
                  weekOperatorWeight[jobItemAssignment.shiftSchedule.weigher.firstName + " " + jobItemAssignment.shiftSchedule.weigher.lastName] =
                      jobItemAssignment.jobItem.requiredWeight;
                }
              }
            }
          });
        }
      }
    }).then((value) async {
      weekIncorrectWeighing = await getIncorrectWeighing("week");
      weekUnderIssuedItem = await getUnderIssues(weekJobIDs);
      weekOverIssuedItems = await getOverIssues(weekJobIDs);
    });
  }

  Future<dynamic> getMonthSummary() async {
    List<String> shiftScheduleIDs = [];
    Map<String, dynamic> dateConditions = {
      "AND": [
        {
          "GREATEREQUAL": {
            "Field": "date",
            "Value": thisMonthStart.toString().substring(0, 10) + "T00:00:00.0Z",
          },
        },
        {
          "LESSEQUAL": {
            "Field": "date",
            "Value": DateTime.parse(thisMonthEnd.add(const Duration(days: 1)).toString()).toUtc().toString() + "T00:00:00.0Z",
          },
        }
      ]
    };
    await appStore.shiftScheduleApp.list(dateConditions).then((response) async {
      if (response.containsKey("status") && response["status"]) {
        for (var item in response["payload"]) {
          if (!shiftScheduleIDs.contains(item["id"])) {
            shiftScheduleIDs.add(item["id"]);
          }
        }
        Map<String, dynamic> shiftCondition = {
          "IN": {
            "Field": "shift_schedule_id",
            "Value": shiftScheduleIDs,
          }
        };
        if (shiftScheduleIDs.isNotEmpty) {
          await appStore.jobItemAssignmentApp.list(shiftCondition).then((response) {
            if (response.containsKey("status") && response["status"]) {
              for (var item in response["payload"]) {
                JobItemAssignment jobItemAssignment = JobItemAssignment.fromJSON(item);
                monthJobWeights += jobItemAssignment.jobItem.requiredWeight;
                if (!monthJobIDs.contains(jobItemAssignment.jobItem.jobID)) {
                  monthJobIDs.add(jobItemAssignment.jobItem.jobID);
                }
                if (monthOperatorWeight
                    .containsKey(jobItemAssignment.shiftSchedule.weigher.firstName + " " + jobItemAssignment.shiftSchedule.weigher.lastName)) {
                  monthOperatorWeight[jobItemAssignment.shiftSchedule.weigher.firstName + " " + jobItemAssignment.shiftSchedule.weigher.lastName] =
                      monthOperatorWeight[
                              jobItemAssignment.shiftSchedule.weigher.firstName + " " + jobItemAssignment.shiftSchedule.weigher.lastName]! +
                          jobItemAssignment.jobItem.requiredWeight;
                } else {
                  monthOperatorWeight[jobItemAssignment.shiftSchedule.weigher.firstName + " " + jobItemAssignment.shiftSchedule.weigher.lastName] =
                      jobItemAssignment.jobItem.requiredWeight;
                }
              }
            }
          });
        }
      }
    }).then((value) async {
      monthIncorrectWeighing = await getIncorrectWeighing("month");
      monthUnderIssuedItem = await getUnderIssues(monthJobIDs);
      monthOverIssuedItems = await getOverIssues(monthJobIDs);
    });
  }

  Widget cardWidget(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 5 - 40,
        height: 200,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Color(0xFFF1DDBF),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 5,
              spreadRadius: 5,
              color: shadowColor,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            value.contains(" of ")
                ? RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: value.split(" of ")[0].toString(),
                          style: TextStyle(
                            fontSize: 60.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: " of ",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: value.split(" of ")[1].toString(),
                          style: TextStyle(
                            fontSize: 60.0,
                            color: formHintTextColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 60.0,
                      color: formHintTextColor,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(10, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                color: formHintTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget homeWidget() {
    return ValueListenableBuilder(
      valueListenable: themeChanged,
      builder: (_, theme, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            20.0,
            50,
            20.0,
            50.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "EazyWeigh",
                style: TextStyle(
                  fontSize: 120.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: formHintTextColor,
                  shadows: [
                    Shadow(
                      color: themeChanged.value ? foregroundColor.withOpacity(0.25) : backgroundColor.withOpacity(0.5),
                      offset: const Offset(10, 10),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.transparent,
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        "Week Summary",
                        style: TextStyle(
                          fontSize: 30.0,
                          color: themeChanged.value ? foregroundColor : backgroundColor,
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 100,
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                weekJobs.isNotEmpty
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return JobList(jobs: weekJobs);
                                        })
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const CustomDialog(title: "Info", message: "No Jobs Found");
                                        });
                              },
                              child: cardWidget(
                                "Jobs Completed",
                                weekJobsCompleted.toString() + " of " + weekJobIDs.length.toString(),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                List<OperatorWeighing> weighings = [];
                                weekOperatorWeight.forEach((key, value) {
                                  OperatorWeighing operatorWeighing = OperatorWeighing(name: key, weight: value);
                                  weighings.add(operatorWeighing);
                                });
                                weighings.isNotEmpty
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return OperatorWeighingList(
                                            weighings: weighings,
                                            label: "Weight",
                                          );
                                        })
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const CustomDialog(
                                            title: "Info",
                                            message: "No Data Found.",
                                          );
                                        });
                              },
                              child: cardWidget(
                                  "Weight of Jobs", weekJobWeights.toStringAsFixed(0).replaceAllMapped(reg, (Match match) => '${match[1]},')),
                            ),
                            cardWidget("Over Issued Items", weekOverIssuedItems.length.toString()),
                            cardWidget("Under Issued Items", weekUnderIssuedItem.length.toString()),
                            TextButton(
                              onPressed: () {
                                List<OperatorWeighing> weighings = [];
                                weekIncorrectWeighing.forEach((key, value) {
                                  OperatorWeighing operatorWeighing = OperatorWeighing(
                                    name: key,
                                    weight: value.length.toDouble(),
                                  );
                                  weighings.add(operatorWeighing);
                                });
                                weighings.isNotEmpty
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return OperatorWeighingList(
                                            weighings: weighings,
                                            label: "Scans",
                                          );
                                        })
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const CustomDialog(
                                            title: "Info",
                                            message: "No Data Found.",
                                          );
                                        });
                              },
                              child: cardWidget("Incorrect Scans", weekIncorrectScans.toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Month Summary",
                        style: TextStyle(
                          fontSize: 30.0,
                          color: themeChanged.value ? foregroundColor : backgroundColor,
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 100,
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  monthJobs.isNotEmpty
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return JobList(jobs: monthJobs);
                                          })
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const CustomDialog(title: "Info", message: "No Jobs Found");
                                          });
                                },
                                child: cardWidget("Jobs Completed", monthJobsComplete.toString() + " of " + monthJobIDs.length.toString())),
                            TextButton(
                                onPressed: () {
                                  List<OperatorWeighing> weighings = [];
                                  monthOperatorWeight.forEach((key, value) {
                                    OperatorWeighing operatorWeighing = OperatorWeighing(name: key, weight: value);
                                    weighings.add(operatorWeighing);
                                  });
                                  weighings.isNotEmpty
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return OperatorWeighingList(
                                              weighings: weighings,
                                              label: "Weight",
                                            );
                                          })
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const CustomDialog(
                                              title: "Info",
                                              message: "No Data Found.",
                                            );
                                          });
                                },
                                child: cardWidget(
                                    "Weight of Jobs", monthJobWeights.toStringAsFixed(0).replaceAllMapped(reg, (Match match) => '${match[1]},'))),
                            cardWidget("Over Issued Items", monthOverIssuedItems.length.toString()),
                            cardWidget("Under Issued Items", monthUnderIssuedItem.length.toString()),
                            TextButton(
                              onPressed: () {
                                List<OperatorWeighing> weighings = [];
                                monthIncorrectWeighing.forEach((key, value) {
                                  OperatorWeighing operatorWeighing = OperatorWeighing(
                                    name: key,
                                    weight: value.length.toDouble(),
                                  );
                                  weighings.add(operatorWeighing);
                                });
                                weighings.isNotEmpty
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return OperatorWeighingList(
                                            weighings: weighings,
                                            label: "Scans",
                                          );
                                        })
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const CustomDialog(
                                            title: "Info",
                                            message: "No Data Found.",
                                          );
                                        });
                              },
                              child: cardWidget("Incorrect Scans", monthIncorrectScans.toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Colors.transparent,
                height: 50.0,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingPage
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: homeWidget(),
          );
  }
}

class OperatorWeighing {
  final String name;
  final double weight;

  OperatorWeighing({
    required this.name,
    required this.weight,
  });
}

class OperatorWeighingList extends StatefulWidget {
  final List<OperatorWeighing> weighings;
  final String label;
  const OperatorWeighingList({
    Key? key,
    required this.weighings,
    required this.label,
  }) : super(key: key);

  @override
  State<OperatorWeighingList> createState() => _OperatorWeighingList();
}

class _OperatorWeighingList extends State<OperatorWeighingList> {
  bool sort = true, ascending = true;
  int sortingColumnIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onSortColum(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        if (ascending) {
          widget.weighings.sort((a, b) => a.name.compareTo(b.name));
        } else {
          widget.weighings.sort((a, b) => b.name.compareTo(a.name));
        }
        break;
      case 1:
        if (ascending) {
          widget.weighings.sort((a, b) => a.weight.compareTo(b.weight));
        } else {
          widget.weighings.sort((a, b) => b.weight.compareTo(a.weight));
        }
        break;
      default:
        break;
    }
  }

  Widget listDetailsWidget() {
    return BaseWidget(
      builder: (context, sizeInfo) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          width: sizeInfo.screenSize.width,
          height: sizeInfo.screenSize.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    cardColor: themeChanged.value ? backgroundColor : foregroundColor,
                    dividerColor: themeChanged.value ? foregroundColor : backgroundColor,
                    textTheme: TextTheme(caption: TextStyle(color: themeChanged.value ? foregroundColor : backgroundColor)),
                  ),
                  child: ListView(
                    children: [
                      PaginatedDataTable(
                        showCheckboxColumn: false,
                        showFirstLastButtons: true,
                        sortAscending: sort,
                        sortColumnIndex: sortingColumnIndex,
                        columnSpacing: 20.0,
                        columns: [
                          DataColumn(
                            label: Text(
                              "Operator",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: Text(
                              widget.label,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                        ],
                        source: _DataSource(context, widget.weighings),
                        rowsPerPage: widget.weighings.length > 25 ? 25 : widget.weighings.length,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return listDetailsWidget();
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this._weighings) {
    _weighings = _weighings;
  }

  final BuildContext context;
  List<OperatorWeighing> _weighings;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final weighing = _weighings[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            weighing.name,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            weighing.weight.toStringAsFixed(3),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _weighings.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
