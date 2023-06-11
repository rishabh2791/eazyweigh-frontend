import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/device_type.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/device_type_interface/list/list_widget.dart';
import 'package:flutter/material.dart';

class DeviceTypeListWidget extends StatefulWidget {
  const DeviceTypeListWidget({Key? key}) : super(key: key);

  @override
  State<DeviceTypeListWidget> createState() => _DeviceTypeListWidgetState();
}

class _DeviceTypeListWidgetState extends State<DeviceTypeListWidget> {
  bool isLoadingData = true;
  bool isDataLoaded = false;
  List<Factory> factories = [];
  List<DeviceType> deviceTypes = [];

  late TextEditingController factoryController;

  @override
  void initState() {
    factoryController = TextEditingController();
    getFactories();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  Widget listWidget() {
    return isDataLoaded
        ? deviceTypes.isEmpty
            ? Text(
                "No Device Types Found",
                style: TextStyle(
                  fontSize: 24.0,
                  color: themeChanged.value ? foregroundColor : backgroundColor,
                ),
              )
            : DeviceTypeList(deviceTypes: deviceTypes)
        : Container(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      DropDownWidget(
                        disabled: false,
                        hint: "Select Factory",
                        controller: factoryController,
                        itemList: factories,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                          elevation: MaterialStateProperty.all<double>(5.0),
                        ),
                        onPressed: () async {
                          deviceTypes = [];
                          var factoryID = factoryController.text;

                          String errors = "";

                          if (factoryID.isEmpty) {
                            errors += "Factory Missing.\n";
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
                            Map<String, dynamic> conditions = {
                              "EQUALS": {
                                "Field": "factory_id",
                                "Value": factoryID,
                              }
                            };
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return loader(context);
                              },
                            );
                            await appStore.deviceTypeApp.list(conditions).then((response) {
                              Navigator.of(context).pop();
                              if (response.containsKey("status") && response["status"]) {
                                for (var item in response["payload"]) {
                                  DeviceType deviceType = DeviceType.fromJSON(item);
                                  deviceTypes.add(deviceType);
                                }
                                deviceTypes.sort((a, b) => a.description.compareTo(b.description));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CustomDialog(
                                      message: "Unable to Get Device Types",
                                      title: "Errors",
                                    );
                                  },
                                );
                              }
                              setState(() {
                                isDataLoaded = true;
                              });
                            });
                          }
                        },
                        child: checkButton(),
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
        : ValueListenableBuilder(
            valueListenable: themeChanged,
            builder: (context, theme, widget) {
              return SuperPage(
                childWidget: buildWidget(
                  listWidget(),
                  context,
                  "Device Type List",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            });
  }
}
