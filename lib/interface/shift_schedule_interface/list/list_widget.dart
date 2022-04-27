import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/shift_schedule.dart';
import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/date_picker/date_picker.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/shift_schedule_interface/list/list.dart';
import 'package:flutter/material.dart';

class ShiftScheduleListWidget extends StatefulWidget {
  const ShiftScheduleListWidget({Key? key}) : super(key: key);

  @override
  State<ShiftScheduleListWidget> createState() =>
      _ShiftScheduleListWidgetState();
}

class _ShiftScheduleListWidgetState extends State<ShiftScheduleListWidget> {
  bool isLoadingData = true;
  bool isDataLoaded = false;
  List<Factory> factories = [];
  List<User> weighers = [];
  List<ShiftSchedule> shiftSchedules = [];
  late TextEditingController factoryController,
      startDateController,
      endDateController,
      userController;

  @override
  void initState() {
    getFactories();
    factoryController = TextEditingController();
    userController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    factoryController.addListener(() {
      getWeighers();
    });
    super.initState();
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
        setState(() {
          isLoadingData = false;
        });
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

  Future<dynamic> getWeighers() async {
    weighers = [];
    if (factoryController.text.isNotEmpty && factoryController.text != "") {
      Map<String, dynamic> conditions = {
        "EQUALS": {
          "Field": "factory_id",
          "Value": factoryController.text,
        }
      };
      try {
        await appStore.userFactoryApp.get(conditions).then((response) async {
          if (response["status"]) {
            for (var item in response["payload"]) {
              User user = User.fromJSON(item["user"]);
              if (user.userRole.role == "Operator") {
                weighers.add(user);
              }
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
      } catch (e) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              message: e.toString(),
              title: "Errors",
            );
          },
        );
      }
    }
  }

  Widget listWidget() {
    return isDataLoaded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shiftSchedules.isEmpty
                    ? "Not Shift Schedule Found"
                    : "Found Shift Schedules",
                style: TextStyle(
                  fontSize: 20.0,
                  color: themeChanged.value ? foregroundColor : backgroundColor,
                ),
              ),
              shiftSchedules.isEmpty
                  ? Container()
                  : ShiftScheduleList(shiftSchedules: shiftSchedules),
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
                hintText: "Start Date",
                labelText: "Start Date",
              ),
              DatePickerWidget(
                dateController: endDateController,
                hintText: "End Date",
                labelText: "End Date",
              ),
              isLoadingData
                  ? Container()
                  : DropDownWidget(
                      disabled: false,
                      hint: "Select Weigher",
                      controller: userController,
                      itemList: weighers,
                    ),
              const Divider(
                color: Colors.transparent,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(menuItemColor),
                  elevation: MaterialStateProperty.all<double>(5.0),
                ),
                onPressed: () async {
                  shiftSchedules = [];
                  String errors = "";
                  Map<String, dynamic> conditions = {};
                  Map<String, dynamic> startDateCondition = {};
                  Map<String, dynamic> endDateCondition = {};
                  var startDate = startDateController.text;
                  var endDate = endDateController.text;

                  if (startDate.isEmpty || startDate == "") {
                    errors += "Start Date Required.\n";
                  } else {
                    startDateCondition = {
                      "GREATEREQUAL": {
                        "Field": "created_at",
                        "Value": DateTime.parse(startDate)
                                .toString()
                                .substring(0, 10) +
                            "T00:00:00.0Z",
                      },
                    };
                  }

                  if (endDate.isEmpty || endDate == "") {
                    errors += "End Date Required.\n";
                  } else {
                    endDateCondition = {
                      "LESSEQUAL": {
                        "Field": "created_at",
                        "Value": DateTime.parse(endDate)
                                .add(const Duration(days: 1))
                                .toString()
                                .substring(0, 10) +
                            "T00:00:00.0Z",
                      },
                    };
                  }

                  conditions["AND"] = [
                    startDateCondition,
                    endDateCondition,
                  ];

                  if (userController.text.isNotEmpty ||
                      userController.text != "") {
                    conditions["AND"].add(
                      {
                        "EQUALS": {
                          "Field": "user_username",
                          "Value": userController.text,
                        },
                      },
                    );
                  }

                  if (errors.isNotEmpty || errors != "") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                          message: errors,
                          title: "Errors",
                        );
                      },
                    );
                  } else {
                    await appStore.shiftScheduleApp
                        .list(conditions)
                        .then((response) {
                      if (response.containsKey("status") &&
                          response["status"]) {
                        for (var item in response["payload"]) {
                          ShiftSchedule shiftSchedule =
                              ShiftSchedule.fromJSON(item);
                          shiftSchedules.add(shiftSchedule);
                        }
                      }
                    }).then((value) {
                      setState(() {
                        isLoadingData = false;
                        isDataLoaded = true;
                      });
                    });
                  }
                },
                child: checkButton(),
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
                  "Get Shift Schedules",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
