import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/bom_item.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/process.dart';
import 'package:eazyweigh/domain/entity/step_type.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';

class ProcessUpdateWidget extends StatefulWidget {
  const ProcessUpdateWidget({Key? key}) : super(key: key);

  @override
  State<ProcessUpdateWidget> createState() => _ProcessUpdateWidgetState();
}

class _ProcessUpdateWidgetState extends State<ProcessUpdateWidget> {
  bool isLoadingData = true;
  bool isDataLoaded = false;
  int currentVersion = 0;
  Map<int, dynamic> process = {};
  List<Factory> factories = [];
  List<StepType> stepTypes = [];
  List<Mat> materials = [];
  List<Mat> bomMaterials = [], pendingMaterials = [];
  List<BomItem> bomItems = [], pendingBOMItems = [];
  String stepTypeSelected = "";
  Map<String, Map<String, String>> descriptions = {
    "Raw Material Addition": {
      "type": "General",
      "description": "Quantity Added",
    },
    "Agitation": {
      "type": "Time",
      "description": "Agitator Speed",
    },
    "Cooling": {
      "type": "General",
      "description": "Temperature",
    },
    "Heating": {
      "type": "General",
      "description": "Temperature",
    },
    "Emulsification/Homogenization": {
      "type": "Time",
      "description": "Emulsifier Speed",
    },
    "Vacuum Deaeration": {
      "type": "Time",
      "description": "Vacuum Pressure",
    },
  };
  late TextEditingController factoryController, stepTypeController, descriptionController, bomQuantityController, valueController, durationController, materialController, mainMaterialController;

  @override
  void initState() {
    factoryController = TextEditingController();
    stepTypeController = TextEditingController();
    descriptionController = TextEditingController();
    bomQuantityController = TextEditingController();
    valueController = TextEditingController();
    durationController = TextEditingController();
    materialController = TextEditingController();
    mainMaterialController = TextEditingController();
    getFactories();
    factoryController.addListener(() {
      getData();
    });
    materialController.addListener(() {
      try {
        BomItem selectedBomItem = bomItems.firstWhere((element) => materialController.text == element.material.id);
        bomQuantityController.text = (selectedBomItem.quantity * 100).toStringAsFixed(3);
      } catch (e) {
        FLog.info(text: e.toString());
      }
    });
    stepTypeController.addListener(() {
      try {
        StepType stepType = stepTypes.firstWhere((element) => element.id == stepTypeController.text);
        stepTypeSelected = stepType.name;
        setState(() {});
      } catch (e) {
        FLog.info(text: e.toString());
      }
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
        for (var item in response["payload"]) {
          StepType stepType = StepType.fromJSON(item);
          stepTypes.add(stepType);
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
        for (var item in response["payload"]) {
          Mat material = Mat.fromJSON(item);
          materials.add(material);
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

  Widget stepWidget() {
    Map<String, String> descriptor = descriptions.containsKey(stepTypeSelected)
        ? descriptions[stepTypeSelected]!
        : {
            "type": "General",
            "description": "Value",
          };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create New Step",
          style: TextStyle(
            color: formHintTextColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 250,
              child: Text(
                "Step Type",
                style: TextStyle(
                  color: formHintTextColor,
                  fontSize: 30.0,
                ),
              ),
            ),
            DropDownWidget(
              disabled: false,
              hint: "Select Step Type",
              controller: stepTypeController,
              itemList: stepTypes,
            ),
          ],
        ),
        stepTypeSelected == "Raw Material Addition" || stepTypeSelected.contains("Raw Material Addition")
            ? Row(
                children: [
                  const SizedBox(
                    width: 250,
                    child: Text(
                      "Material Added",
                      style: TextStyle(
                        color: formHintTextColor,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  DropDownWidget(
                    disabled: false,
                    hint: "Material",
                    controller: materialController,
                    itemList: pendingMaterials,
                  ),
                ],
              )
            : Container(),
        stepTypeSelected == "Raw Material Addition" || stepTypeSelected.contains("Raw Material Addition")
            ? Row(
                children: [
                  const SizedBox(
                    width: 250,
                    child: Text(
                      "BOM Quantity Left",
                      style: TextStyle(
                        color: formHintTextColor,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  textField(
                    false,
                    bomQuantityController,
                    "BOM Quantity Left",
                    false,
                  ),
                ],
              )
            : Container(),
        Row(
          children: [
            SizedBox(
              width: 250,
              child: Text(
                descriptor["description"] ?? "Value",
                style: const TextStyle(
                  color: formHintTextColor,
                  fontSize: 30.0,
                ),
              ),
            ),
            textField(
              false,
              valueController,
              "",
              false,
            ),
          ],
        ),
        descriptor["type"] == "Time"
            ? Row(
                children: [
                  const SizedBox(
                    width: 250,
                    child: Text(
                      "Duration",
                      style: TextStyle(
                        color: formHintTextColor,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  textField(
                    false,
                    durationController,
                    "Duration (min)",
                    false,
                  ),
                ],
              )
            : Container(),
        const Divider(
          height: 30.0,
          color: Colors.transparent,
        ),
        Row(
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () async {
                if (stepTypeController.text.isNotEmpty) {
                  double value = valueController.text.isNotEmpty ? double.parse(valueController.text) : 0;
                  Map<String, dynamic> currentStep = {
                    "step_type_id": stepTypeController.text,
                    "description": stepTypeSelected,
                    "value": value,
                    "duration": durationController.text.isNotEmpty ? int.parse(durationController.text) : 0,
                    "sequence": process.length + 1,
                  };
                  if (stepTypeSelected.contains("Raw Material")) {
                    currentStep["material_id"] = materialController.text;
                    BomItem thisBOMItem = pendingBOMItems.firstWhere((element) => element.material.id == currentStep["material_id"]);
                    if (double.parse((thisBOMItem.quantity * 100).toStringAsFixed(3)) < double.parse(value.toStringAsFixed(3))) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomDialog(
                            message: "Quantity is more for BOM Quantity Left.",
                            title: "Error",
                          );
                        },
                      );
                    } else {
                      if (value == 0) {
                        value = thisBOMItem.quantity * 100;
                        currentStep["value"] = value;
                      }

                      if (double.parse((thisBOMItem.quantity * 100).toStringAsFixed(3)) == double.parse(value.toStringAsFixed(3))) {
                        pendingMaterials.removeWhere((element) => element.id == currentStep["material_id"]);
                      }
                      pendingBOMItems.firstWhere((element) => element.material.id == currentStep["material_id"]).quantity =
                          (double.parse((pendingBOMItems.firstWhere((element) => element.material.id == currentStep["material_id"]).quantity * 100).toStringAsFixed(3)) -
                                  double.parse(value.toStringAsFixed(3))) /
                              100;
                      bomQuantityController.text = (pendingBOMItems.firstWhere((element) => element.material.id == currentStep["material_id"]).quantity * 100).toStringAsFixed(3);
                    }
                  }
                  valueController.text = "";
                  durationController.text = "";
                  process[process.length + 1] = currentStep;
                  setState(() {});
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const CustomDialog(
                        message: "Step Type Required",
                        title: "Error",
                      );
                    },
                  );
                }
              },
              child: checkButton(),
            ),
            const VerticalDivider(
              width: 20.0,
              color: Colors.transparent,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () {
                materialController.text = "";
                valueController.text = "";
                durationController.text = "";
                stepTypeController.text = "";
              },
              child: clearButton(),
            ),
          ],
        )
      ],
    );
  }

  List<Widget> currentStepWidget() {
    List<Widget> widget = [];
    process.forEach((key, value) {
      StepType currentStepStype = stepTypes.firstWhere((element) => element.id == value["step_type_id"]);
      String material = value.containsKey("material_id") && value["material_id"].isNotEmpty
          ? materials.firstWhere((element) => element.id == value["material_id"]).code + " - " + materials.firstWhere((element) => element.id == value["material_id"]).description
          : "";
      widget.add(
        Container(
          key: Key("key_$key"),
          margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 20.0, 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: foregroundColor,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  print(key);
                  print(process[key]);
                  if (value.containsKey("material_id") && value["material_id"].isNotEmpty) {
                    Mat removedMaterial = materials.firstWhere((element) => element.id == process[key]["material_id"]);
                    try {
                      pendingMaterials.firstWhere((element) => element.id == removedMaterial.id);
                    } catch (e) {
                      pendingMaterials.add(removedMaterial);
                    }
                    pendingMaterials.sort((a, b) => a.code.compareTo(b.code));
                    pendingBOMItems.firstWhere((element) => element.material.id == removedMaterial.id).quantity =
                        (pendingBOMItems.firstWhere((element) => element.material.id == removedMaterial.id).quantity + value["value"] / 100);
                    bomQuantityController.text = (pendingBOMItems.firstWhere((element) => element.material.id == removedMaterial.id).quantity * 100).toStringAsFixed(3);
                  }
                  process.remove(key);
                  int sequence = int.parse(value["sequence"].toString());
                  if (process.length > 1) {
                    for (int i = sequence + 1; i <= process.length; i++) {
                      process[i]["sequence"] = process[i]["sequence"] - 1;
                    }
                  }
                  setState(() {});
                },
                child: crossButton(),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 250,
                child: Text(
                  currentStepStype.name + " - " + material + " - " + value["value"].toString() + " - " + value["duration"].toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: formHintTextColor,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
    return widget;
  }

  Widget processWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "Process Step",
            style: TextStyle(
              color: formHintTextColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(
            height: 20.0,
            color: Colors.transparent,
          ),
          SizedBox(
            height: 100 * process.length.toDouble() + 20,
            width: (MediaQuery.of(context).size.width - 180) / 2,
            child: ReorderableListView(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              physics: const ClampingScrollPhysics(),
              footer: process.isNotEmpty
                  ? Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                            elevation: MaterialStateProperty.all<double>(5.0),
                          ),
                          onPressed: () async {
                            List<Map<String, dynamic>> processSteps = [];
                            process.forEach((key, value) {
                              value["created_by_username"] = currentUser.username;
                              value["updated_by_username"] = currentUser.username;
                              processSteps.add(value);
                            });
                            Map<String, dynamic> createdProcess = {
                              "material_id": materials.firstWhere((element) => element.code == mainMaterialController.text).id,
                              "steps": processSteps,
                              "created_by_username": currentUser.username,
                              "updated_by_username": currentUser.username,
                              "version": currentVersion + 1,
                            };
                            if (pendingMaterials.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "Not all BOM Items have been included in process.",
                                    title: "Error",
                                  );
                                },
                              );
                            } else {
                              await appStore.processApp.create(createdProcess).then((response) {
                                if (response.containsKey("status") && response["status"]) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialog(
                                        message: "Process Created",
                                        title: "Info",
                                      );
                                    },
                                  );
                                  process.clear();
                                  setState(() {});
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialog(
                                        message: "Unable to create process.",
                                        title: "Error",
                                      );
                                    },
                                  );
                                }
                              });
                            }
                          },
                          child: checkButton(),
                        ),
                        const VerticalDivider(
                          width: 20.0,
                          color: Colors.transparent,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                            elevation: MaterialStateProperty.all<double>(5.0),
                          ),
                          onPressed: () {
                            process.clear();
                            setState(() {});
                          },
                          child: clearButton(),
                        ),
                      ],
                    )
                  : Container(),
              children: currentStepWidget(),
              onReorder: (int start, int current) {
                start += 1;
                int startPos = 1;
                int endPos = process.length;
                if (start > current) {
                  current = current >= process.length ? process.length : current + 1;
                  startPos = current;
                  endPos = start - 1;
                  Map<String, dynamic> movedItem = process[start];
                  for (int i = endPos; i >= startPos; i--) {
                    process[i + 1] = process[i];
                    process[i + 1]["sequence"] = i + 1;
                  }
                  movedItem["sequence"] = current;
                  process[current] = movedItem;
                }
                if (start < current) {
                  current = current >= process.length ? process.length : current;
                  startPos = start + 1;
                  endPos = current;
                  Map<String, dynamic> movedItem = process[start];
                  for (int i = startPos; i <= endPos; i++) {
                    process[i - 1] = process[i];
                    process[i - 1]["sequence"] = i - 1;
                  }
                  movedItem["sequence"] = current;
                  process[current] = movedItem;
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget creationWidget() {
    Widget widget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isDataLoaded
            ? Row(
                children: [
                  const Text(
                    "Creating Process at ",
                    style: TextStyle(
                      color: formHintTextColor,
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    factories.firstWhere((element) => element.id == factoryController.text).name,
                    style: const TextStyle(
                      color: formHintTextColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    " for ",
                    style: TextStyle(
                      color: formHintTextColor,
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    materials.firstWhere((element) => element.code == mainMaterialController.text).code +
                        " - " +
                        materials.firstWhere((element) => element.code == mainMaterialController.text).description,
                    style: const TextStyle(
                      color: formHintTextColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Container(),
        const Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        isDataLoaded
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 200) / 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: stepWidget(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: processWidget(),
                  ),
                ],
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
                    mainMaterialController,
                    "Material",
                    false,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                      elevation: MaterialStateProperty.all<double>(5.0),
                    ),
                    onPressed: () async {
                      String mainMaterial = mainMaterialController.text;
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
                              if (response["payload"].isNotEmpty) {
                                var currentProcess = Process.fromJSON(response["payload"][response["payload"].length - 1]);
                                currentVersion = currentProcess.version;
                                for (var step in currentProcess.steps) {
                                  Map<String, dynamic> currentStep = {
                                    "step_type_id": step.stepType.id,
                                    "description": step.stepType.name,
                                    "value": step.value,
                                    "duration": step.duration,
                                    "sequence": step.sequence,
                                    "material_id": step.materialID,
                                  };
                                  process[process.length + 1] = currentStep;
                                }
                                setState(() {
                                  isLoadingData = false;
                                  isDataLoaded = true;
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CustomDialog(
                                      message: "Unable to Get Process.",
                                      title: "Error",
                                    );
                                  },
                                );
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "Unable to Process Data",
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
    return isLoadingData
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: buildWidget(
              creationWidget(),
              context,
              "Create Process",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
