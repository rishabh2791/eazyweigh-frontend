import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/job_item_assignment.dart';
import 'package:eazyweigh/domain/entity/shift.dart';
import 'package:eazyweigh/domain/entity/shift_schedule.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/date_picker/date_picker.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/job_interface/list/jobs_list.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:eazyweigh/interface/common/helper/mobile.dart'
    if (dart.library.html) 'package:eazyweigh/interface/common/helper/web.dart'
    as helper;

class JobWeighingWidget extends StatefulWidget {
  const JobWeighingWidget({Key? key}) : super(key: key);

  @override
  State<JobWeighingWidget> createState() => _JobWeighingWidgetState();
}

class _JobWeighingWidgetState extends State<JobWeighingWidget> {
  bool isLoadingData = true;
  bool isDataLoaded = false;
  List<Shift> shifts = [];
  List<Factory> factories = [];
  List<ShiftSchedule> shiftSchedules = [];
  List<String> shiftScheduleIDs = [];
  List<JobItemAssignment> jobItemAssignments = [];
  Map<String, dynamic> jobMapping = {};
  List<Job> jobs = [];
  List<String> jobIDs = [];
  late TextEditingController startDateController,
      endDateController,
      shiftController,
      factoryController;

  @override
  void initState() {
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    shiftController = TextEditingController();
    factoryController = TextEditingController();
    factoryController.addListener(getShifts);
    getFactories();
    super.initState();
  }

  Future<void> getFactories() async {
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
        setState(() {
          isLoadingData = false;
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
    });
  }

  Future<void> getBackendData() async {}

  Future<void> getShifts() async {
    shifts = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryController.text,
      }
    };
    await appStore.shiftApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          Shift shift = Shift.fromJSON(item);
          shifts.add(shift);
        }
        setState(() {});
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
      }
    });
  }

  Widget selectionWidget() {
    Widget widget = Column(
      children: [
        Row(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 300.0),
              child: const Text(
                "Factory:",
                style: TextStyle(
                  fontSize: 30.0,
                  color: formHintTextColor,
                ),
              ),
            ),
            DropDownWidget(
              disabled: false,
              hint: "Select Factory",
              controller: factoryController,
              itemList: factories,
            )
          ],
        ),
        Row(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 300.0),
              child: const Text(
                "Start Date:",
                style: TextStyle(
                  fontSize: 30.0,
                  color: formHintTextColor,
                ),
              ),
            ),
            DatePickerWidget(
              dateController: startDateController,
              hintText: "Date",
              labelText: "Date",
            ),
          ],
        ),
        Row(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 300.0),
              child: const Text(
                "End Date:",
                style: TextStyle(
                  fontSize: 30.0,
                  color: formHintTextColor,
                ),
              ),
            ),
            DatePickerWidget(
              dateController: endDateController,
              hintText: "Date",
              labelText: "Date",
            ),
          ],
        ),
        Row(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 300.0),
              child: const Text(
                "Shift:",
                style: TextStyle(
                  fontSize: 30.0,
                  color: formHintTextColor,
                ),
              ),
            ),
            DropDownWidget(
              disabled: false,
              hint: "Select Shift",
              controller: shiftController,
              itemList: shifts,
            )
          ],
        ),
        Row(
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () async {
                var factoryID = factoryController.text;
                var startDate = startDateController.text;
                var endDate = endDateController.text;
                var shift = shiftController.text;
                Map<String, dynamic> conditions = {};
                List<Map<String, dynamic>> listOfConditions = [];
                Map<String, dynamic> startDateCondition = {};
                Map<String, dynamic> endDateCondition = {};
                Map<String, dynamic> shiftCondition = {};

                if (factoryID.isEmpty || factoryID == "") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const CustomDialog(
                        message: "Factory Required",
                        title: "Error",
                      );
                    },
                  );
                } else {
                  if (startDate.isNotEmpty && startDate != "") {
                    startDateCondition = {
                      "GREATEREQUAL": {
                        "Field": "date",
                        "Value": startDate.toString().substring(0, 10) +
                            "T00:00:00.0Z",
                      }
                    };
                    listOfConditions.add(startDateCondition);
                  }
                  if (endDate.isNotEmpty && endDate != "") {
                    endDateCondition = {
                      "LESSEQUAL": {
                        "Field": "date",
                        "Value": endDate.toString().substring(0, 10) +
                            "T00:00:00.0Z",
                      }
                    };
                    listOfConditions.add(endDateCondition);
                  }
                  if (shift.isNotEmpty && shift != "") {
                    shiftCondition = {
                      "EQUALS": {
                        "Field": "shift_id",
                        "Value": shifts
                            .firstWhere((element) => element.id == shift)
                            .id,
                      }
                    };
                    listOfConditions.add(shiftCondition);
                  } else {
                    List<String> shiftIDs = [];
                    for (var thisShift in shifts) {
                      shiftIDs.add(thisShift.id);
                    }
                    shiftCondition = {
                      "IN": {
                        "Field": "shift_id",
                        "Value": shiftIDs,
                      }
                    };
                    listOfConditions.add(shiftCondition);
                  }
                  conditions =
                      listOfConditions.isEmpty ? {} : {"AND": listOfConditions};
                  setState(() {
                    isLoadingData = true;
                  });
                  await appStore.shiftScheduleApp
                      .list(conditions)
                      .then((response) async {
                    if (response.containsKey("status") && response["status"]) {
                      for (var item in response["payload"]) {
                        ShiftSchedule shiftSchedule =
                            ShiftSchedule.fromJSON(item);
                        shiftSchedules.add(shiftSchedule);
                        shiftScheduleIDs.add(shiftSchedule.id);
                      }
                      Map<String, dynamic> shiftScheduleCondition = {
                        "IN": {
                          "Field": "shift_schedule_id",
                          "Value": shiftScheduleIDs,
                        }
                      };
                      await appStore.jobItemAssignmentApp
                          .list(shiftScheduleCondition)
                          .then((value) async {
                        if (value.containsKey("status") && value["status"]) {
                          for (var item in value["payload"]) {
                            JobItemAssignment jobItemAssignment =
                                JobItemAssignment.fromJSON(item);
                            jobItemAssignments.add(jobItemAssignment);
                            if (!jobIDs
                                .contains(jobItemAssignment.jobItem.jobID)) {
                              jobIDs.add(jobItemAssignment.jobItem.jobID);
                            }
                          }
                        }
                        Map<String, dynamic> jobCondition = {
                          "IN": {
                            "Field": "id",
                            "Value": jobIDs,
                          }
                        };
                        await appStore.jobApp
                            .list(jobCondition)
                            .then((jobResponse) async {
                          if (jobResponse.containsKey("status") &&
                              jobResponse["status"]) {
                            for (var item in jobResponse["payload"]) {
                              Job job = Job.fromJSON(item);
                              jobs.add(job);
                            }
                            jobs.sort(
                                ((a, b) => a.jobCode.compareTo(b.jobCode)));
                          }
                        });
                      });
                      setState(() {
                        isLoadingData = false;
                        isDataLoaded = true;
                      });
                      // navigationService.push(
                      //   CupertinoPageRoute(
                      //     builder: (BuildContext context) => JobWeighingList(jobs: jobs),
                      //   ),
                      // );
                    } else {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomDialog(
                            message: "Unable to Get Weighing Data",
                            title: "Error",
                          );
                        },
                      );
                    }
                  });
                }
              },
              child: checkButton(),
            ),
            const VerticalDivider(),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () {
                factoryController.text = "";
                startDateController.text = "";
                endDateController.text = "";
                shiftController.text = "";
              },
              child: clearButton(),
            ),
          ],
        )
      ],
    );
    return widget;
  }

  Widget displayWidget() {
    Widget widget = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Jobs Found",
              style: TextStyle(
                color: menuItemColor,
                fontSize: 30.0,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () async {
                int start = 1;
                final excel.Workbook workbook = excel.Workbook();
                final excel.Worksheet sheet = workbook.worksheets[0];
                sheet.getRangeByName("A1").setText("Job Code");
                sheet.getRangeByName("B1").setText("Material Code");
                sheet.getRangeByName("C1").setText("Material Description");
                sheet.getRangeByName("D1").setText("Job Size (KG)");
                sheet.getRangeByName("E1").setText("Job Items");
                sheet.getRangeByName("F1").setText("Completed");
                for (var job in jobs) {
                  start++;
                  sheet
                      .getRangeByName("A" + start.toString())
                      .setText(job.jobCode);
                  sheet
                      .getRangeByName("B" + start.toString())
                      .setText(job.material.code);
                  sheet
                      .getRangeByName("C" + start.toString())
                      .setText(job.material.description);
                  sheet
                      .getRangeByName("D" + start.toString())
                      .setText(job.quantity.toString() + job.uom.code);
                  sheet
                      .getRangeByName("E" + start.toString())
                      .setText(job.jobItems.length.toString());
                  sheet
                      .getRangeByName("F" + start.toString())
                      .setText(job.complete.toString().toUpperCase());
                }
                final List<int> bytes = workbook.saveAsStream();
                await helper.saveAndLaunchFile(bytes, 'JobWeighing.xlsx');
                workbook.dispose();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Export",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: backgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        JobList(jobs: jobs),
      ],
    );
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingData
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: buildWidget(
              isDataLoaded ? displayWidget() : selectionWidget(),
              context,
              "Job Weighings",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
