import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
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

class TerminalCreateWidget extends StatefulWidget {
  const TerminalCreateWidget({Key? key}) : super(key: key);

  @override
  State<TerminalCreateWidget> createState() => _TerminalCreateWidgetState();
}

class _TerminalCreateWidgetState extends State<TerminalCreateWidget> {
  bool isLoadingData = true;
  List<Factory> factories = [];
  List<UnitOfMeasure> uoms = [];
  late FilePickerResult? file;

  late TextEditingController descriptionController, factoryController, uomController, macAddressController, capacityController, leastCountController, fileController;

  @override
  void initState() {
    super.initState();
    getFactories();
    descriptionController = TextEditingController();
    factoryController = TextEditingController();
    uomController = TextEditingController();
    macAddressController = TextEditingController();
    capacityController = TextEditingController();
    leastCountController = TextEditingController();
    fileController = TextEditingController();
    factoryController.addListener(getUOMs);
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

  String getUOMID(List<UnitOfMeasure> uoms, String code) {
    for (var uom in uoms) {
      if (uom.code == code) {
        return uom.id;
      }
    }
    return "";
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

  Future<dynamic> getUOMs() async {
    uoms = [];
    String factoryID = factoryController.text;
    Map<String, dynamic> condition = {
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
    await appStore.unitOfMeasurementApp.list(condition).then((response) async {
      if (response["status"]) {
        await Future.forEach(response["payload"], (dynamic item) async {
          UnitOfMeasure uom = await UnitOfMeasure.fromServer(Map<String, dynamic>.from(item));
          uoms.add(uom);
        }).then((value) {
          Navigator.of(context).pop();
          setState(() {
            isLoadingData = false;
          });
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
                  "Select Factory",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Factory",
                  controller: factoryController,
                  itemList: factories,
                ),
                const Text(
                  "Create New Terminal",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textField(false, descriptionController, "Terminal Description", false),
                textField(false, capacityController, "Maximum Capacity", false),
                textField(false, leastCountController, "Least Count", false),
                textField(false, macAddressController, "MAC Address", false),
                DropDownWidget(
                  disabled: false,
                  hint: "Unit of Measurement",
                  controller: uomController,
                  itemList: uoms,
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
                        var description = descriptionController.text;
                        var capacity = capacityController.text;
                        var leastCount = leastCountController.text;
                        var factoryName = factoryController.text;
                        var uom = uomController.text;
                        var macAddress = macAddressController.text;

                        String errors = "";

                        if (description.isEmpty || description == "") {
                          errors += "Terminal Description Missing.\n";
                        }

                        if (capacity.isEmpty || capacity == "") {
                          errors += "Terminal Capacity Missing.\n";
                        }

                        if (factoryName.isEmpty || factoryName == "") {
                          errors += "Factory Missing.\n";
                        }

                        if (leastCount.isEmpty || leastCount == "") {
                          errors += "Least Count Missing.\n";
                        }

                        if (uom.isEmpty) {
                          errors += "Unit of Measure Missing.\n";
                        }

                        if (macAddress.isEmpty || macAddress == "") {
                          errors += "MAC Address Missing.\n";
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

                          Map<String, dynamic> terminal = {
                            "description": description,
                            "capacity": double.parse(capacity),
                            "unit_of_measurement_id": uom,
                            "least_count": double.parse(leastCount),
                            "factory_id": factoryName,
                            "mac_address": macAddress,
                          };

                          await appStore.terminalApp.create(terminal).then((response) async {
                            if (response["status"]) {
                              String apiKey = response["payload"]["api_key"].toString();
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                    message: "Terminal Created with API Key: " + apiKey,
                                    title: "Info",
                                  );
                                },
                              );
                              capacityController.text = "";
                              descriptionController.text = "";
                              uomController.text = "";
                              leastCountController.text = "";
                              macAddressController.text = "";
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
                        capacityController.text = "";
                        descriptionController.text = "";
                        uomController.text = "";
                        leastCountController.text = "";
                        macAddressController.text = "";
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
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Multiple Terminals",
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
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  onPressed: () async {
                    String factoryName = factoryController.text;
                    String errors = "";

                    if (factoryName.isEmpty) {
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
                      List<Map<String, dynamic>> terminals = [];
                      // ignore: prefer_typing_uninitialized_variables
                      var csvData;
                      if (foundation.kIsWeb) {
                        final bytes = utf8.decode(file!.files.single.bytes!);
                        csvData = const CsvToListConverter().convert(bytes);
                      } else {
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
                          final csvFile = File(file!.files.single.path.toString()).openRead();
                          // ignore: prefer_typing_uninitialized_variables
                          csvData = await csvFile
                              .transform(utf8.decoder)
                              .transform(
                                const CsvToListConverter(),
                              )
                              .toList();
                        }
                        for (var element in csvData) {
                          String uomID = getUOMID(uoms, element[1]);
                          if (uomID.isEmpty) {
                          } else {
                            terminals.add(
                              {
                                "description": element[1],
                                "factory_id": factoryName,
                                "unit_of_measurement_id": uomID,
                                "capacity": element[2],
                                "least_count": element[3].toString(),
                                "mac_address": element[4],
                              },
                            );
                          }
                          if (errors.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  message: errors + "\n Creating the Others Now.",
                                  title: "Errors",
                                );
                              },
                            );
                          }
                        }
                        await appStore.terminalApp.createMultiple(terminals).then(
                          (value) {
                            if (value["status"]) {
                              int created = value["payload"]["models"].length;
                              int notCreated = value["payload"]["errors"].length;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                    message: "Created " + created.toString() + " terminals." + (notCreated != 0 ? "Unable to create " + notCreated.toString() + " terminals." : ""),
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
                                    message: value["message"],
                                    title: "Errors",
                                  );
                                },
                              );
                            }
                          },
                        );
                      }
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
              "Create Unit Of Measure",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
