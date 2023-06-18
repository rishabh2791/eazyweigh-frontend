import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/process.dart';
import 'package:eazyweigh/domain/entity/step_type.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/process_interface/details/details.dart';
import 'package:flutter/material.dart';

class ProcessDetailsWidget extends StatefulWidget {
  const ProcessDetailsWidget({Key? key}) : super(key: key);

  @override
  State<ProcessDetailsWidget> createState() => _ProcessDetailsWidgetState();
}

class _ProcessDetailsWidgetState extends State<ProcessDetailsWidget> {
  bool isLoadingData = true;
  bool isDataLoaded = false;
  List<Factory> factories = [];
  List<Mat> materials = [];
  List<StepType> stepTypes = [];
  List<Process> foundProcesses = [];
  late TextEditingController factoryController, materialController;

  @override
  void initState() {
    factoryController = TextEditingController();
    materialController = TextEditingController();
    getFactories();
    factoryController.addListener(() {
      getData();
    });
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

  Future<void> getData() async {
    setState(() {
      isLoadingData = true;
      isDataLoaded = false;
    });
    await Future.wait([
      getStepTypes(),
      getMaterials(),
    ]).then((value) {
      stepTypes.sort(((a, b) => a.name.compareTo(b.name)));
      materials.sort(((a, b) => a.code.compareTo(b.code)));
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Future<void> getStepTypes() async {
    stepTypes = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryController.text,
      }
    };
    await appStore.stepTypeApp.list(conditions).then((response) async {
      if (response["status"]) {
        await Future.forEach(response["payload"], (dynamic item) async {
          StepType stepType = await StepType.fromServer(Map<String, dynamic>.from(item));
          stepTypes.add(stepType);
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

  Future<void> getMaterials() async {
    materials = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryController.text,
      }
    };
    await appStore.materialApp.list(conditions).then((response) async {
      if (response["status"]) {
        await Future.forEach(response["payload"], (dynamic item) async {
          Mat material = await Mat.fromServer(Map<String, dynamic>.from(item));
          materials.add(material);
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

  Widget detailsWidget() {
    Widget widget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isDataLoaded
            ? foundProcesses.isEmpty
                ? const Text(
                    "No Process Steps Found.",
                    style: TextStyle(
                      color: formHintTextColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DetailsWidget(
                      process: foundProcesses.last,
                      factoryID: factoryController.text,
                      materials: materials,
                      stepTypes: stepTypes,
                    ),
                  )
            : Row(
                children: [
                  DropDownWidget(
                    disabled: false,
                    hint: "Select Factory",
                    controller: factoryController,
                    itemList: factories,
                  ),
                  textField(
                    false,
                    materialController,
                    "Material",
                    false,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                      elevation: MaterialStateProperty.all<double>(5.0),
                    ),
                    onPressed: () async {
                      String mainMaterial = materialController.text;
                      String materialType = "";
                      if (mainMaterial.isNotEmpty) {
                        try {
                          materialType = materials.firstWhere((element) => element.code == mainMaterial).type;
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                message: "Invalid Material Selected",
                                title: "Error",
                              );
                            },
                          );
                        }
                        if (materialType == "Bulk") {
                          String materialID = materials.firstWhere((element) => element.code == mainMaterial).id;
                          Map<String, dynamic> conditions = {
                            "EQUALS": {
                              "Field": "material_id",
                              "Value": materialID,
                            }
                          };
                          await appStore.processApp.list(conditions).then((response) async {
                            if (response.containsKey("status") && response["status"]) {
                              await Future.forEach(response["payload"], (dynamic item) async {
                                Process thisVersion = await Process.fromServer(Map<String, dynamic>.from(item));
                                foundProcesses.add(thisVersion);
                              }).then((value) {
                                foundProcesses.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                                setState(() {
                                  isDataLoaded = true;
                                });
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "Enable to Get Process Details",
                                    title: "Error",
                                  );
                                },
                              );
                            }
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                message: "Select Bulk Type Material to Proceed",
                                title: "Error",
                              );
                            },
                          );
                        }
                      } else {
                        if (mainMaterial.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                message: "Select Material to Proceed",
                                title: "Error",
                              );
                            },
                          );
                        }
                      }
                    },
                    child: checkButton(),
                  ),
                ],
              ),
      ],
    );
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        detailsWidget(),
        context,
        "Process Details",
        currentUser.userRole.role == "Processor"
            ? () {}
            : () {
                Navigator.of(context).pop();
              },
      ),
    );
  }
}
