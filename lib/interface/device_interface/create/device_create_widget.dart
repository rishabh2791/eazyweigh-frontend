import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/file_picker/file_picker.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

class DeviceCreateWidget extends StatefulWidget {
  const DeviceCreateWidget({Key? key}) : super(key: key);

  @override
  State<DeviceCreateWidget> createState() => _DeviceCreateWidgetState();
}

class _DeviceCreateWidgetState extends State<DeviceCreateWidget> {
  bool isLoadingData = true;
  List<Factory> factories = [];
  List<Vessel> factoryVessels = [];
  late FilePickerResult? file;

  late TextEditingController nameController, factoryController, vesselController, fileController;

  @override
  void initState() {
    super.initState();
    getFactories();
    nameController = TextEditingController();
    factoryController = TextEditingController();
    vesselController = TextEditingController();
    fileController = TextEditingController();
    factoryController.addListener(getFactoryVessels);
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
    factories = [];
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
        }
      }
      setState(() {
        isLoadingData = false;
      });
    });
  }

  getFile(FilePickerResult? result) {
    setState(() {
      file = result;
      fileController.text = result!.files.single.name;
    });
  }

  Widget createWidget() {
    return Container(
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
                  "Create New Device",
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
                textField(false, nameController, "Device Name", false),
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
                        var name = nameController.text;
                        var vesselID = vesselController.text;

                        String errors = "";

                        if (name.isEmpty) {
                          errors += "Device Name Missing.\n";
                        }

                        if (vesselID.isEmpty) {
                          errors += "Vessel Missing.\n";
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
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return loader(context);
                            },
                          );

                          Map<String, dynamic> device = {
                            "name": name,
                            "vessel_id": vesselID,
                          };

                          await appStore.deviceApp.create(device).then((response) async {
                            if (response["status"]) {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "Device Created",
                                    title: "Info",
                                  );
                                },
                              );
                              nameController.text = "";
                              vesselController.text = "";
                              factoryController.text = "";
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
                        nameController.text = "";
                        factoryController.text = "";
                        vesselController.text = "";
                      },
                      child: clearButton(),
                    ),
                  ],
                ),
                const Divider(
                  height: 50.0,
                  color: Colors.transparent,
                ),
                const Text(
                  "Create Multiple New Devices",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
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
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  onPressed: () async {
                    List<Map<String, dynamic>> devices = [];
                    // ignore: prefer_typing_uninitialized_variables
                    var csvData;
                    final path = fileController.text;
                    if (path.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomDialog(
                            message: "Select File...",
                            title: "Errors",
                          );
                        },
                      );
                    } else {
                      if (foundation.kIsWeb) {
                        final bytes = utf8.decode(file!.files.single.bytes!);
                        csvData = const CsvToListConverter().convert(bytes);
                      } else {
                        final csvFile = File(file!.files.single.path.toString()).openRead();
                        csvData = await csvFile
                            .transform(utf8.decoder)
                            .transform(
                              const CsvToListConverter(),
                            )
                            .toList();
                      }
                      csvData.forEach((element) {
                        Map<String, dynamic> device = {
                          "name": element[1],
                          "vessel_id": element[0],
                        };
                        devices.add(device);
                      });
                      await appStore.deviceApp.createMultiple(devices).then((response) {
                        if (response.containsKey("status") && response["status"]) {
                          int created = response["payload"]["models"].length;
                          int notCreated = response["payload"]["errors"].length;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                message: "Created " +
                                    created.toString() +
                                    " devices." +
                                    (notCreated != 0 ? "Unable to create " + notCreated.toString() + " devices." : ""),
                                title: "Info",
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                message: "Unable to Create Devices",
                                title: "Errors",
                              );
                            },
                          );
                        }
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
        : SuperPage(
            childWidget: buildWidget(
              createWidget(),
              context,
              "Create Device",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
