import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/material.dart';
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

class JobCreateWidget extends StatefulWidget {
  const JobCreateWidget({Key? key}) : super(key: key);

  @override
  State<JobCreateWidget> createState() => _JobCreateWidgetState();
}

class _JobCreateWidgetState extends State<JobCreateWidget> {
  bool isLoadingData = true;
  List<Factory> factories = [];
  List<UnitOfMeasure> uoms = [];
  List<Mat> materials = [];
  late FilePickerResult? file;

  late TextEditingController factoryController,
      uomController,
      materialController,
      quantityController,
      codeController,
      fileController;

  @override
  void initState() {
    super.initState();
    getFactories();
    uomController = TextEditingController();
    codeController = TextEditingController();
    factoryController = TextEditingController();
    fileController = TextEditingController();
    materialController = TextEditingController();
    quantityController = TextEditingController();
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

  String getUOMID(String code) {
    for (var uom in uoms) {
      if (uom.code == code) {
        return uom.id;
      }
    }
    return "";
  }

  Future<dynamic> getFactories() async {
    factories = [];
    Map<String, dynamic> conditions = {"company_id": companyID};
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

  void getBackendData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return loader(context);
      },
    );
    await Future.forEach([
      await getUOMs(),
    ], (element) {
      setState(() {
        isLoadingData = false;
      });
    }).then((value) {
      Navigator.of(context).pop();
    });
  }

  Future<dynamic> getUOMs() async {
    uoms = [];
    String factoryID = factoryController.text;
    Map<String, dynamic> condition = {
      "factory_id": factoryID,
    };
    await appStore.unitOfMeasurementApp.list(condition).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          UnitOfMeasure uom = UnitOfMeasure.fromJSON(item);
          uoms.add(uom);
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
  }

  String getMaterialID(String matCode) {
    for (var material in materials) {
      if (material.code == matCode) {
        return material.id;
      }
    }
    return "";
  }

  int getEmptyRows(Map<int, TextEditingController> controllers) {
    int empty = 0;
    controllers.forEach((key, value) {
      if (value.text.isEmpty || value.text == "") {
        empty++;
      }
    });
    return empty;
  }

  String getFactoryName(String factoryID) {
    for (var fact in factories) {
      if (fact.id == factoryID) {
        return fact.name;
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
                  "Create New Job",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textField(false, codeController, "Job Code", false),
                textField(false, materialController, "Material Code", false),
                textField(false, quantityController, "Quantity", false),
                DropDownWidget(
                  disabled: false,
                  hint: "Unit of Measurement",
                  controller: uomController,
                  itemList: uoms,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Divider(),
                const SizedBox(
                  height: 20.0,
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
                        var factoryID = factoryController.text;
                        var jobCode = codeController.text;
                        var uomID = uomController.text;
                        var quantity = quantityController.text;

                        if (jobCode.isEmpty || jobCode == "") {
                          errors += "Job Code Missing.\n";
                        }

                        if (materialController.text.isEmpty ||
                            materialController.text == "") {
                          errors += "Material Code Missing.\n";
                        }

                        if (quantity.isEmpty || quantity == "") {
                          errors += "Quantity Missing.\n";
                        }

                        if (uomID.isEmpty || uomID == "") {
                          errors += "Unit of Measurement Missing.\n";
                        }

                        if (errors.isEmpty && errors == "") {
                          Map<String, dynamic> job = {
                            "factory_id": factoryID,
                            "job_code": jobCode,
                            "quantity": double.parse(quantity),
                            "unit_of_measurement_id": uomID,
                          };
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return loader(context);
                            },
                          );

                          await appStore.jobApp.create(job).then(
                            (response) async {
                              if (response.containsKey("status")) {
                                if (response["status"]) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialog(
                                        message: "Job Created",
                                        title: "Info",
                                      );
                                    },
                                  );
                                  codeController.text = "";
                                  uomController.text = "";
                                  factoryController.text = "";
                                  materialController.text = "";
                                  quantityController.text = "";
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
                              } else {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CustomDialog(
                                      message: "Unable to Connect.",
                                      title: "Errors",
                                    );
                                  },
                                );
                              }
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                message: errors,
                                title: "Errors",
                              );
                            },
                          );
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
                        codeController.text = "";
                        uomController.text = "";
                        factoryController.text = "";
                        materialController.text = "";
                        quantityController.text = "";
                      },
                      child: clearButton(),
                    ),
                  ],
                ),
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
                  "Upload JOB Items",
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
                            fileController.text == "") {
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
                          if (factoryController.text == "" ||
                              factoryController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialog(
                                  message: "Factory Missing",
                                  title: "Errors",
                                );
                              },
                            );
                          } else {
                            List<Map<String, dynamic>> jobs = [];
                            // ignore: prefer_typing_uninitialized_variables
                            var csvData;
                            if (foundation.kIsWeb) {
                              final bytes =
                                  utf8.decode(file!.files.single.bytes!);
                              csvData =
                                  const CsvToListConverter().convert(bytes);
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
                                String uomID = getUOMID(element[3]);
                                if (uomID.isEmpty) {
                                  errors += "Unit of Measure: " +
                                      element[3] +
                                      " not created.\n";
                                } else {
                                  jobs.add(
                                    {
                                      "job_code": element[0].toString(),
                                      "factory_id": factoryController.text,
                                      "unit_of_measurement_id": uomID,
                                      "quantity":
                                          double.parse(element[2].toString()),
                                    },
                                  );
                                }
                              },
                            );

                            await appStore.jobApp.createMultiple(jobs).then(
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
                                            " job and found error in " +
                                            notCreated.toString() +
                                            " jobs.",
                                        title: "Errors",
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
              "Create Job",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
