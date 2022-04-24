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
import 'package:eazyweigh/interface/material_interface/create/material_types.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

class MaterialCreateWidget extends StatefulWidget {
  const MaterialCreateWidget({Key? key}) : super(key: key);

  @override
  State<MaterialCreateWidget> createState() => _MaterialCreateWidgetState();
}

class _MaterialCreateWidgetState extends State<MaterialCreateWidget> {
  bool isLoadingData = true;
  List<Factory> factories = [];
  List<UnitOfMeasure> uoms = [];
  late FilePickerResult? file;

  late TextEditingController typeController,
      factoryController,
      uomController,
      codeController,
      descriptionController,
      barcodeController,
      fileController;

  @override
  void initState() {
    super.initState();
    getFactories();
    typeController = TextEditingController();
    uomController = TextEditingController();
    codeController = TextEditingController();
    descriptionController = TextEditingController();
    barcodeController = TextEditingController();
    factoryController = TextEditingController();
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

  Future<dynamic> getUOMs() async {
    uoms = [];
    String factoryID = factoryController.text;
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "company_id",
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
    await appStore.unitOfMeasurementApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          UnitOfMeasure uom = UnitOfMeasure.fromJSON(item);
          uoms.add(uom);
        }
        Navigator.of(context).pop();
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
                  "Create New Material",
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
                  hint: "Select Material Type",
                  controller: typeController,
                  itemList: materialTypes,
                ),
                textField(false, codeController, "Material Code", false),
                textField(false, descriptionController, "Material Name", false),
                textField(false, barcodeController, "Material Barcode", false),
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
                        backgroundColor:
                            MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () async {
                        var code = codeController.text;
                        var description = descriptionController.text;
                        var barcode = barcodeController.text;
                        var type = typeController.text;
                        var factoryName = factoryController.text;
                        var uom = uomController.text;

                        String errors = "";

                        if (code.isEmpty) {
                          errors += "Material Code Missing.\n";
                        }

                        if (description.isEmpty) {
                          errors += "Material Description Missing.\n";
                        }

                        if (factoryName.isEmpty) {
                          errors += "Factory Missing.\n";
                        }

                        if (type.isEmpty) {
                          errors += "Material Type Missing.\n";
                        }

                        if (uom.isEmpty) {
                          errors += "Unit of Measure Missing.\n";
                        }

                        if (barcode.isEmpty) {
                          errors += "Material Barcode Missing.\n";
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

                          Map<String, dynamic> material = {
                            "code": code,
                            "description": description,
                            "type": type,
                            "unit_of_measurement_id": uom,
                            "bar_code": barcode,
                            "factory_id": factoryName,
                          };

                          await appStore.materialApp
                              .create(material)
                              .then((response) async {
                            if (response["status"]) {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "Material Created",
                                    title: "Info",
                                  );
                                },
                              );
                              codeController.text = "";
                              descriptionController.text = "";
                              uomController.text = "";
                              typeController.text = "";
                              barcodeController.text = "";
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
                        backgroundColor:
                            MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () {
                        codeController.text = "";
                        descriptionController.text = "";
                        uomController.text = "";
                        typeController.text = "";
                        barcodeController.text = "";
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
                  "Create Multiple Materials",
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(menuItemColor),
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
                      List<Map<String, dynamic>> materials = [];
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
                        csvData.forEach(
                          (element) {
                            String uomID = getUOMID(uoms, element[2]);
                            if (uomID.isEmpty) {
                            } else {
                              materials.add(
                                {
                                  "code": element[0].toString(),
                                  "description": element[1],
                                  "factory_id": factoryName,
                                  "unit_of_measurement_id": uomID,
                                  "type": element[3],
                                  "bar_code": element[4].toString(),
                                },
                              );
                            }
                            if (errors.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                    message:
                                        errors + "\n Creating the Others Now.",
                                    title: "Errors",
                                  );
                                },
                              );
                            }
                          },
                        );
                        await appStore.materialApp
                            .createMultiple(materials)
                            .then(
                          (value) {
                            if (value["status"]) {
                              int created = value["payload"]["models"].length;
                              int notCreated =
                                  value["payload"]["errors"].length;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                    message: "Created " +
                                        created.toString() +
                                        " materials." +
                                        (notCreated != 0
                                            ? "Unable to create " +
                                                notCreated.toString() +
                                                " materials."
                                            : ""),
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
