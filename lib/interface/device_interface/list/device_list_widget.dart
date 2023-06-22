import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/device.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/device_interface/list/list_widget.dart';
import 'package:flutter/material.dart';

class DeviceListWidget extends StatefulWidget {
  const DeviceListWidget({Key? key}) : super(key: key);

  @override
  State<DeviceListWidget> createState() => _DeviceListWidgetState();
}

class _DeviceListWidgetState extends State<DeviceListWidget> {
  bool isLoadingData = true;
  bool isDataLoaded = false;
  List<Factory> factories = [];
  List<Vessel> factoryVessels = [];
  List<Device> devices = [];
  List<String> vesselIDs = [];

  late TextEditingController factoryController, vesselController;

  @override
  void initState() {
    factoryController = TextEditingController();
    vesselController = TextEditingController();
    factoryController.addListener(getFactoryVessels);
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

  Future<dynamic> getFactoryVessels() async {
    factoryVessels = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryController.text,
      }
    };
    setState(() {
      isLoadingData = true;
    });
    await appStore.vesselApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          Vessel vessel = Vessel.fromJSON(item);
          factoryVessels.add(vessel);
          vesselIDs.add(vessel.id);
        }
      }
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Widget listWidget() {
    return isDataLoaded
        ? devices.isEmpty
            ? Text(
                "No Devices Found",
                style: TextStyle(
                  fontSize: 24.0,
                  color: themeChanged.value ? foregroundColor : backgroundColor,
                ),
              )
            : DeviceList(devices: devices)
        : Container(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "List Devices",
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
                      DropDownWidget(
                        disabled: false,
                        hint: "Select Vessel",
                        controller: vesselController,
                        itemList: factoryVessels,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                              elevation: MaterialStateProperty.all<double>(5.0),
                            ),
                            onPressed: () async {
                              devices = [];
                              var factoryID = factoryController.text;
                              var vesselID = vesselController.text;

                              String errors = "";
                              Map<String, dynamic> conditions = {};

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
                                if (vesselID.isNotEmpty) {
                                  conditions = {
                                    "EQUALS": {
                                      "Field": "vessel_id",
                                      "Value": vesselID,
                                    }
                                  };
                                } else {
                                  conditions = {
                                    "IN": {
                                      "Field": "vessel_id",
                                      "Value": vesselIDs,
                                    }
                                  };
                                }
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return loader(context);
                                  },
                                );
                                await appStore.deviceApp.list(conditions).then((response) {
                                  Navigator.of(context).pop();
                                  if (response.containsKey("status") && response["status"]) {
                                    for (var item in response["payload"]) {
                                      Device device = Device.fromJSON(item);
                                      devices.add(device);
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const CustomDialog(
                                          message: "Unable to Get Vessels",
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
                          const SizedBox(
                            width: 10.0,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                              elevation: MaterialStateProperty.all<double>(5.0),
                            ),
                            onPressed: () {
                              factoryController.text = "";
                              vesselController.text = "";
                            },
                            child: clearButton(),
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
        : ValueListenableBuilder(
            valueListenable: themeChanged,
            builder: (context, theme, widget) {
              return SuperPage(
                childWidget: buildWidget(
                  listWidget(),
                  context,
                  "Device List",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            });
  }
}
