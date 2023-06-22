import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/scanned_data.dart';
import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/date_picker/date_picker.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/scanned_data/list/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScannedDataListWidget extends StatefulWidget {
  const ScannedDataListWidget({Key? key}) : super(key: key);

  @override
  State<ScannedDataListWidget> createState() => _ScannedDataListWidgetState();
}

class _ScannedDataListWidgetState extends State<ScannedDataListWidget> {
  bool isLoadingData = true;
  bool isDataLoaded = false;
  List<ScannedData> scannedData = [];
  List<Factory> factories = [];
  List<User> weighers = [];
  List<Mat> materials = [];
  late TextEditingController factoryController, userController, startDateController, endDateController;

  @override
  void initState() {
    factoryController = TextEditingController();
    userController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    getBackendData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getBackendData() async {
    await Future.forEach([
      await getFactories(),
      await getWeighers(),
    ], (element) async {
      setState(() {
        isLoadingData = false;
      });
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
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "company_id",
        "Value": companyID,
      }
    };
    await appStore.userCompanyApp.get(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          User weigher = User.fromJSON(item["user"]);
          if (weigher.userRole.role == "Operator") {
            weighers.add(weigher);
          }
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

  String getUserDetails(String username) {
    String details = "";
    for (var user in weighers) {
      if (user.username == username) {
        details = user.firstName + " " + user.lastName;
      }
    }
    return details;
  }

  Future<void> getMaterial(String factoryID) async {
    materials = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryID,
      }
    };
    await appStore.materialApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          Mat mat = Mat.fromJSON(item);
          materials.add(mat);
        }
      }
    });
  }

  Widget listWidget() {
    return isDataLoaded
        ? scannedData.isEmpty
            ? Text(
                "No Scanned Data Records Found.",
                style: TextStyle(
                  fontSize: 20.0,
                  color: themeChanged.value ? foregroundColor : backgroundColor,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scannedData.length.toString() + " instances of incorrect weighing in the period for " + getUserDetails(userController.text) + ".",
                    style: TextStyle(
                      color: themeChanged.value ? foregroundColor : backgroundColor,
                      fontSize: 20.0,
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  ScannedDataList(
                    scannedData: scannedData,
                    materials: materials,
                  ),
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
              DropDownWidget(
                disabled: false,
                hint: "Select Weigher",
                controller: userController,
                itemList: weighers,
              ),
              DatePickerWidget(
                hintText: "Date After",
                labelText: "Date After",
                dateController: startDateController,
              ),
              DatePickerWidget(
                hintText: "Date Before",
                labelText: "Date Before",
                dateController: endDateController,
              ),
              const Divider(
                color: Colors.transparent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                      elevation: MaterialStateProperty.all<double>(5.0),
                    ),
                    onPressed: () async {
                      String errors = "";
                      var factoryID = factoryController.text;
                      var username = userController.text;
                      var startDate = startDateController.text;
                      var endDate = endDateController.text;

                      if (factoryID.isEmpty || factoryID == "") {
                        errors += "Factory Required.\n";
                      }

                      if (username.isEmpty || username == "") {
                        errors += "Weigher Required.\n";
                      }

                      if (errors.isEmpty) {
                        Map<String, dynamic> conditions = {
                          "AND": [
                            {
                              "EQUALS": {
                                "Field": "user_username",
                                "Value": username,
                              },
                            },
                          ]
                        };
                        if (startDate.isNotEmpty) {
                          conditions["AND"].add(
                            {
                              "GREATEREQUAL": {
                                "Field": "created_at",
                                "Value": DateTime.parse(startDate).toString().substring(0, 10) + "T00:00:00.0Z",
                              }
                            },
                          );
                        }
                        if (endDate.isNotEmpty) {
                          conditions["AND"].add(
                            {
                              "LESSEQUAL": {
                                "Field": "created_at",
                                "Value": DateTime.parse(endDate).toString().substring(0, 10) + "T00:00:00.0Z",
                              }
                            },
                          );
                        }
                        setState(() {
                          isLoadingData = true;
                        });
                        await getMaterial(factoryID).then((value) async {
                          await appStore.scannedDataApp.list(conditions).then((response) {
                            setState(() {
                              isLoadingData = false;
                            });
                            if (response.containsKey("status") && response["status"]) {
                              for (var item in response["payload"]) {
                                ScannedData thisScannedData = ScannedData.fromJSON(item);
                                scannedData.add(thisScannedData);
                              }
                              setState(() {
                                isDataLoaded = true;
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
                          });
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              message: errors,
                              title: "Error",
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
                          builder: (BuildContext context) => const ScannedDataListWidget(),
                        ),
                      );
                    },
                    child: clearButton(),
                  ),
                ],
              )
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
                  "Get Scanned Data",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
