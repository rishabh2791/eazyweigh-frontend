import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
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

class StepTypeCreateWidget extends StatefulWidget {
  const StepTypeCreateWidget({Key? key}) : super(key: key);

  @override
  State<StepTypeCreateWidget> createState() => _StepTypeCreateWidgetState();
}

class _StepTypeCreateWidgetState extends State<StepTypeCreateWidget> {
  bool isLoadingData = true;
  List<Factory> factories = [];
  late FilePickerResult? file;

  late TextEditingController nameController,
      factoryController,
      fileController,
      titleController,
      bodyController,
      footerController;

  @override
  void initState() {
    super.initState();
    getFactories();
    nameController = TextEditingController();
    factoryController = TextEditingController();
    fileController = TextEditingController();
    titleController = TextEditingController();
    bodyController = TextEditingController();
    footerController = TextEditingController();
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
                  "Create New Step Type",
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
                textField(false, nameController, "Step Type Name", false),
                textField(false, titleController, "Display Title", false),
                textField(false, bodyController, "Display Body", false),
                textField(false, footerController, "Display Footer", false),
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
                        var factoryName = factoryController.text;
                        var title = titleController.text;
                        var body = bodyController.text;
                        var footer = footerController.text;

                        String errors = "";

                        if (name.isEmpty) {
                          errors += "UOM Code Missing.\n";
                        }

                        if (factoryName.isEmpty) {
                          errors += "Factory Missing.\n";
                        }

                        if (title.isEmpty) {
                          errors += "Display Title Missing.\n";
                        }

                        if (body.isEmpty) {
                          errors += "Display Body Missing.\n";
                        }

                        if (footer.isEmpty) {
                          errors += "Display Footer Missing.\n";
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

                          Map<String, dynamic> stepType = {
                            "description": name,
                            "factory_id": factoryName,
                            "title": title,
                            "body": body,
                            "footer": footer,
                          };

                          await appStore.stepTypeApp.create(stepType).then((response) async {
                            if (response["status"]) {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "Step Type Created",
                                    title: "Info",
                                  );
                                },
                              );
                              nameController.text = "";
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
                  "Create Multiple New Step Types",
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
                      List<Map<String, dynamic>> stepTypes = [];
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
                          Map<String, dynamic> stepType = {
                            "description": element[0],
                            "factory_id": factoryController.text,
                            "title": element[1],
                            "body": element[2],
                            "footer": element[3],
                          };
                          stepTypes.add(stepType);
                        });
                        await appStore.stepTypeApp.createMultiple(stepTypes).then((response) {
                          if (response.containsKey("status") && response["status"]) {
                            int created = response["payload"]["models"].length;
                            int notCreated = response["payload"]["errors"].length;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  message: "Created " +
                                      created.toString() +
                                      " step types." +
                                      (notCreated != 0
                                          ? "Unable to create " + notCreated.toString() + " materials."
                                          : ""),
                                  title: "Info",
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialog(
                                  message: "Unable to Create Step Types",
                                  title: "Errors",
                                );
                              },
                            );
                          }
                        });
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
              "Create Step Types",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
