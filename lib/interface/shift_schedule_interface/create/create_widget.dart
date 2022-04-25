import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/shift.dart';
import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/date_picker/date_picker.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/file_picker/file_picker.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

class ShiftScheduleCreateWidget extends StatefulWidget {
  const ShiftScheduleCreateWidget({Key? key}) : super(key: key);

  @override
  State<ShiftScheduleCreateWidget> createState() =>
      _ShiftScheduleCreateWidgetState();
}

class _ShiftScheduleCreateWidgetState extends State<ShiftScheduleCreateWidget> {
  bool isLoadingData = true;
  late TextEditingController dateController,
      shiftController,
      userController,
      factoryController,
      fileController;
  List<Factory> factories = [];
  List<User> users = [];
  List<Shift> shifts = [];
  late FilePickerResult? file;

  @override
  void initState() {
    dateController = TextEditingController();
    shiftController = TextEditingController();
    userController = TextEditingController();
    factoryController = TextEditingController();
    fileController = TextEditingController();
    getFactories();
    super.initState();
    factoryController.addListener(getBackendData);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFile(FilePickerResult? result) {
    setState(() {
      file = result;
      fileController.text = result!.files.single.name;
    });
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

  Future<dynamic> getBackendData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return loader(context);
      },
    );
    await Future.forEach([await getUsers(), await getShifts()],
        (element) async {
      setState(() {
        isLoadingData = false;
      });
    }).then((value) {
      Navigator.of(context).pop();
    });
  }

  Future<dynamic> getUsers() async {
    users = [];
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
              users.add(user);
            }
          }
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

  Future<dynamic> getShifts() async {
    shifts = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryController.text,
      }
    };
    try {
      await appStore.shiftApp.list(conditions).then((response) async {
        if (response["status"]) {
          for (var item in response["payload"]) {
            Shift shift = Shift.fromJSON(item);
            shifts.add(shift);
          }
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

  String getShiftID(String shiftCode) {
    for (var shift in shifts) {
      if (shift.code == shiftCode) {
        return shift.id;
      }
    }
    return "";
  }

  Widget createWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Shift Schedule",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Factory",
                  controller: factoryController,
                  itemList: factories,
                ),
                DatePickerWidget(
                  dateController: dateController,
                  hintText: "Date",
                  labelText: "Date",
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select User",
                  controller: userController,
                  itemList: users,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Shift",
                  controller: shiftController,
                  itemList: shifts,
                ),
                const SizedBox(
                  height: 10.0,
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
                        var shiftID = shiftController.text;
                        var username = userController.text;
                        var date = dateController.text;
                        var factoryID = factoryController.text;

                        String errors = "";

                        if (shiftID.isEmpty || shiftID == "") {
                          errors += "Shift Missing.\n";
                        }

                        if (username.isEmpty || username == "") {
                          errors += "Shift Description Missing.\n";
                        }

                        if (date.isEmpty || date == "") {
                          errors += "Start Time Missing.\n";
                        }

                        if (factoryID.isEmpty) {
                          errors += "Factory Selection Missing.\n";
                        }

                        if (errors.isNotEmpty) {
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
                          setState(() {
                            isLoadingData = true;
                          });
                          Map<String, dynamic> shiftSchedule = {
                            "shift_id": shiftID,
                            "date": DateTime.parse(dateController.text)
                                    .toString()
                                    .substring(0, 10) +
                                "T00:00:00.0Z",
                            "user_username": username,
                          };

                          await appStore.shiftScheduleApp
                              .create(shiftSchedule)
                              .then(
                            (response) async {
                              if (response["status"]) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CustomDialog(
                                      message: "Shift Schedule Created",
                                      title: "Info",
                                    );
                                  },
                                );
                                setState(() {
                                  isLoadingData = false;
                                });
                              } else {
                                setState(() {
                                  isLoadingData = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String message = response["message"]
                                            .toString()
                                            .contains("Duplicate")
                                        ? "Job Already Assigned."
                                        : response["message"];
                                    return CustomDialog(
                                      message: message,
                                      title: "Info",
                                    );
                                  },
                                );
                              }
                            },
                          );
                        }
                      },
                      child: checkButton(),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () {
                        userController.text = "";
                        shiftController.text = "";
                        dateController.text = "";
                        factoryController.text = "";
                        factoryController.text = "";
                      },
                      child: clearButton(),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Upload Shift Schedule",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilePickerer(
                  hint: "Select File",
                  label: "Select File",
                  updateParent: getFile,
                  controller: fileController,
                ),
                const SizedBox(
                  height: 10.0,
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
                        String errors = "";
                        if (fileController.text.isEmpty ||
                            fileController.text != "") {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                message: "File Missing",
                                title: "Errors",
                              );
                            },
                          );
                        } else {
                          List<Map<String, dynamic>> shiftSchedules = [];
                          // ignore: prefer_typing_uninitialized_variables
                          var csvData;
                          if (foundation.kIsWeb) {
                            final bytes =
                                utf8.decode(file!.files.single.bytes!);
                            csvData = const CsvToListConverter().convert(bytes);
                          } else {
                            final csvFile =
                                File(file!.files.single.path.toString())
                                    .openRead();
                            csvData = await csvFile
                                .transform(utf8.decoder)
                                .transform(
                                  const CsvToListConverter(),
                                )
                                .toList();
                          }
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return loader(context);
                            },
                          );
                          csvData.forEach(
                            (element) {
                              String username = element[1];
                              if (username.isEmpty) {
                                errors += "Username " +
                                    element[1] +
                                    " not created.\n";
                              } else {
                                String shiftId =
                                    getShiftID(element[2].toString());
                                if (shiftId.isEmpty || shiftId == "") {
                                  errors += "Shift: " +
                                      element[0] +
                                      " not created.\n";
                                } else {
                                  shiftSchedules.add(
                                    {
                                      "date": DateTime.parse(element[0])
                                              .toString()
                                              .substring(0, 10) +
                                          "T00:00:00.0Z",
                                      "user_username": username,
                                      "shift_id": shiftId,
                                    },
                                  );
                                }
                              }
                            },
                          );
                          await appStore.shiftScheduleApp
                              .createMultiple(shiftSchedules)
                              .then(
                            (response) async {
                              if (response["status"]) {
                                int created =
                                    response["payload"]["models"].length;
                                int notCreated =
                                    response["payload"]["errors"].length +
                                        errors.length;
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                      message: "Created " +
                                          created.toString() +
                                          " Shift Schedules and found error in " +
                                          notCreated.toString() +
                                          " schedules.",
                                      title: "Info",
                                    );
                                  },
                                );
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
                            },
                          );
                        }
                      },
                      child: checkButton(),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
              createWidget(),
              context,
              "Create Shift Schedule",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
