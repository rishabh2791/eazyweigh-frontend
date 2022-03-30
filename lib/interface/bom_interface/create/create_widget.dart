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
import 'package:eazyweigh/interface/common/true_false_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

class BOMCreateWidget extends StatefulWidget {
  const BOMCreateWidget({Key? key}) : super(key: key);

  @override
  State<BOMCreateWidget> createState() => _BOMCreateWidgetState();
}

class _BOMCreateWidgetState extends State<BOMCreateWidget> {
  bool isLoadingData = true;
  List<Factory> factories = [];
  List<UnitOfMeasure> uoms = [];
  List<Mat> materials = [];
  late PlatformFile file;

  int rows = 0;
  Map<int, TextEditingController> codeControllers = {};
  Map<int, TextEditingController> uomControllers = {};
  Map<int, TextEditingController> qtyControllers = {};
  Map<int, TextEditingController> upperTolControllers = {};
  Map<int, TextEditingController> lowerTolControllers = {};
  Map<int, TextEditingController> overIssueControllers = {};
  Map<int, TextEditingController> underIssueControllers = {};

  late TextEditingController factoryController,
      uomController,
      codeController,
      fileController,
      unitSizeController,
      revisionController;

  @override
  void initState() {
    super.initState();
    getFactories();
    uomController = TextEditingController();
    codeController = TextEditingController();
    factoryController = TextEditingController();
    fileController = TextEditingController();
    unitSizeController = TextEditingController();
    revisionController = TextEditingController();
    factoryController.addListener(getBackendData);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFile(PlatformFile readFile) {
    setState(() {
      file = readFile;
      fileController.text = readFile.name;
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
      await getMaterials(),
      await getUOMs(),
    ], (element) {
      setState(() {
        isLoadingData = false;
      });
    }).then((value) {
      Navigator.of(context).pop();
    });
  }

  Future<dynamic> getMaterials() async {
    uoms = [];
    String factoryID = factoryController.text;
    Map<String, dynamic> condition = {
      "factory_id": factoryID,
    };
    await appStore.materialApp.list(condition).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          Mat material = Mat.fromJSON(item);
          materials.add(material);
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

  Widget bomItemRow(int i) {
    TextEditingController codeControl = TextEditingController();
    codeControllers[i] = codeControl;
    TextEditingController uomControl = TextEditingController();
    uomControllers[i] = uomControl;
    TextEditingController qtyControl = TextEditingController();
    qtyControllers[i] = qtyControl;
    TextEditingController upperTolControl = TextEditingController();
    upperTolControllers[i] = upperTolControl;
    TextEditingController lowerTolControl = TextEditingController();
    lowerTolControllers[i] = lowerTolControl;
    TextEditingController overIssueControl = TextEditingController();
    overIssueControllers[i] = overIssueControl;
    TextEditingController underIssueControl = TextEditingController();
    underIssueControllers[i] = underIssueControl;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 30,
          child: Text(
            (i + 1).toString(),
            style: const TextStyle(
              color: formHintTextColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: textField(false, codeControl, "", false),
        ),
        const VerticalDivider(),
        SizedBox(
          width: 200,
          child: DropDownWidget(
            disabled: false,
            hint: "",
            controller: uomControl,
            itemList: uoms,
          ),
        ),
        const VerticalDivider(),
        SizedBox(
          width: 200,
          child: textField(false, qtyControl, "", false),
        ),
        const VerticalDivider(),
        SizedBox(
          width: 200,
          child: textField(false, upperTolControl, "", false),
        ),
        const VerticalDivider(),
        SizedBox(
          width: 200,
          child: textField(false, lowerTolControl, "", false),
        ),
        const VerticalDivider(),
        SizedBox(
          width: 200,
          child: DropDownWidget(
            disabled: false,
            hint: "",
            controller: overIssueControl,
            itemList: trueFalse,
          ),
        ),
        const VerticalDivider(),
        SizedBox(
          width: 200,
          child: DropDownWidget(
            disabled: false,
            hint: "",
            controller: underIssueControl,
            itemList: trueFalse,
          ),
        ),
      ],
    );
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
                  "Create New Bill of Material",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textField(false, codeController, "Material Code", false),
                textField(false, unitSizeController, "Unit Size", false),
                textField(false, revisionController, "Revision", false),
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
                const Text(
                  "Pull from Syspro",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(menuItemColor),
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  onPressed: () async {
                    //TODO pull data from Syspro
                  },
                  child: const Tooltip(
                    decoration: BoxDecoration(
                      color: foregroundColor,
                    ),
                    message: "Pull",
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      child: Icon(
                        Icons.download,
                        color: backgroundColor,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Divider(),
                const Text(
                  "Add BOM Items",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Wrap(
                  children: const [
                    SizedBox(
                      width: 30,
                      child: Text(
                        "Sr. No.",
                        style: TextStyle(
                          color: formHintTextColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "Material Code",
                        style: TextStyle(
                          color: formHintTextColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "UOM",
                        style: TextStyle(
                          color: formHintTextColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Qty",
                        style: TextStyle(
                          color: formHintTextColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Upper Tol.",
                        style: TextStyle(
                          color: formHintTextColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Lower Tol.",
                        style: TextStyle(
                          color: formHintTextColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Over Issue",
                        style: TextStyle(
                          color: formHintTextColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Under Issue",
                        style: TextStyle(
                          color: formHintTextColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < rows; i++) bomItemRow(i),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(menuItemColor),
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  onPressed: () async {
                    setState(() {
                      rows += 1;
                    });
                  },
                  child: const Tooltip(
                    decoration: BoxDecoration(
                      color: foregroundColor,
                    ),
                    message: "Add More Rows",
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      child: Icon(
                        Icons.add,
                        color: backgroundColor,
                        size: 30.0,
                      ),
                    ),
                  ),
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
                  "Upload BOM Items",
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
                        List<Map<String, dynamic>> bomItems = [];

                        String factoryID = factoryController.text;
                        String materialCode = codeController.text;
                        String uom = uomController.text;
                        int revision = 1;
                        double unitSize = 1;

                        if (factoryID.isEmpty || factoryID == "") {
                          errors += "Factory Details Required.\n";
                        }

                        if (materialCode.isEmpty || materialCode == "") {
                          errors += "Material Details Required.\n";
                        }

                        if (unitSizeController.text.isEmpty ||
                            unitSizeController.text.toString() == "") {
                          errors += "Unit Size Required.\n";
                        } else {
                          unitSize =
                              double.parse(unitSizeController.text.toString());
                        }

                        if (revisionController.text.isEmpty ||
                            revisionController.text.toString() == "") {
                          errors += "Revision Required.\n";
                        } else {
                          revision =
                              int.parse(revisionController.text.toString());
                        }

                        if (uom.isEmpty || uom == "") {
                          errors += "Unit of Measure Required.\n";
                        }

                        if (errors.isEmpty) {
                          String bomMaterialID = getMaterialID(materialCode);

                          if (bomMaterialID.isEmpty || bomMaterialID == "") {
                            errors += "Material: " +
                                codeController.text +
                                " not created in Factory: " +
                                getFactoryName(factoryID) +
                                ".\n";
                          } else {
                            if (fileController.text.isNotEmpty ||
                                fileController.text != "") {
                              var csvData;
                              if (foundation.kIsWeb) {
                                //TODO Web Version
                              } else {
                                final csvFile =
                                    File(file.path.toString()).openRead();
                                csvData = await csvFile
                                    .transform(utf8.decoder)
                                    .transform(
                                      const CsvToListConverter(),
                                    )
                                    .toList();
                                csvData.forEach(
                                  (element) {
                                    String uomID = getUOMID(element[1]);
                                    if (uomID.isEmpty) {
                                      errors += "Unit of Measure: " +
                                          element[1] +
                                          " not created.\n";
                                    } else {
                                      String materialID =
                                          getMaterialID(element[0].toString());
                                      if (materialID.isEmpty ||
                                          materialID == "") {
                                        errors += "Material: " +
                                            element[0] +
                                            " not created.\n";
                                      } else {
                                        bomItems.add(
                                          {
                                            "bom_id": "",
                                            "material_id": getMaterialID(
                                                element[0].toString()),
                                            "unit_of_measurement_id":
                                                getUOMID(element[1]),
                                            "quantity": double.parse(
                                                element[2].toString()),
                                            "upper_tolerance": double.parse(
                                                element[3].toString()),
                                            "lower_tolerance": double.parse(
                                                element[4].toString()),
                                            "over_issue":
                                                element[5] == 1 ? true : false,
                                            "under_issue":
                                                element[6] == 1 ? true : false,
                                          },
                                        );
                                      }
                                    }
                                  },
                                );
                              }
                            } else {
                              if (getEmptyRows(codeControllers) == rows) {
                                errors += "No BOM Items Found.";
                              } else {
                                for (var j = 0;
                                    j < codeControllers.length;
                                    j++) {
                                  var thisCode =
                                      codeControllers[j]?.text.toString();
                                  var thisUOM =
                                      uomControllers[j]?.text.toString();
                                  var thisQty =
                                      qtyControllers[j]?.text.toString();
                                  var thisUpperTol =
                                      upperTolControllers[j]?.text.toString();
                                  var thisLowerTol =
                                      lowerTolControllers[j]?.text.toString();
                                  var thisOverIssue =
                                      overIssueControllers[j]?.text.toString();
                                  var thisUnderIssue =
                                      underIssueControllers[j]?.text.toString();
                                  String materialID =
                                      getMaterialID(thisCode.toString());

                                  if (thisCode!.isEmpty &&
                                      thisUOM!.isEmpty &&
                                      thisQty!.isEmpty &&
                                      thisUpperTol!.isEmpty &&
                                      thisLowerTol!.isEmpty &&
                                      thisOverIssue!.isEmpty &&
                                      thisUnderIssue!.isEmpty) {
                                    break;
                                  }

                                  if (materialID.isEmpty) {
                                    errors += "Material Code:" +
                                        thisCode.toString() +
                                        " not created in. " +
                                        getFactoryName(factoryController.text) +
                                        ".\n";
                                  } else {
                                    if (thisCode.isEmpty ||
                                        thisUOM!.isEmpty ||
                                        thisQty!.isEmpty ||
                                        thisUpperTol!.isEmpty ||
                                        thisLowerTol!.isEmpty ||
                                        thisOverIssue!.isEmpty ||
                                        thisUnderIssue!.isEmpty) {
                                      errors +=
                                          "Please check all entries in Sr. No. " +
                                              (j + 1).toString() +
                                              ".\n";
                                    } else {
                                      if (materialID.isEmpty) {
                                      } else {
                                        Map<String, dynamic> thisBOMItem = {
                                          "bom_id": "",
                                          "material_id":
                                              getMaterialID(thisCode),
                                          "unit_of_measurement_id": thisUOM,
                                          "quantity": double.parse(thisQty),
                                          "upper_tolerance":
                                              double.parse(thisUpperTol),
                                          "lower_tolerance":
                                              double.parse(thisLowerTol),
                                          "over_issue": thisOverIssue == "True"
                                              ? true
                                              : false,
                                          "under_issue":
                                              thisUnderIssue == "True"
                                                  ? true
                                                  : false,
                                        };
                                        bomItems.add(thisBOMItem);
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }

                        if (errors.isNotEmpty) {
                          bomItems = [];
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
                          Map<String, dynamic> bom = {
                            "factory_id": factoryID,
                            "material_id": getMaterialID(materialCode),
                            "unit_size": unitSize,
                            "unit_of_measurement_id": uom,
                            "revision": revision,
                          };
                          await appStore.bomApp
                              .create(bom)
                              .then((response) async {
                            if (response["status"]) {
                              String bomID = response["payload"]["id"];
                              for (var bomItem in bomItems) {
                                bomItem["bom_id"] = bomID;
                              }
                              await appStore.bomItemApp
                                  .createMultiple(bomItems)
                                  .then((value) async {
                                if (value["status"]) {
                                  if (value["payload"]["errors"].length > 0) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog(
                                          message: value["payload"]["errors"]
                                                  .length
                                                  .toString() +
                                              " bom items not created.",
                                          title: "Errors",
                                        );
                                      },
                                    );
                                  } else {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const CustomDialog(
                                          message: "Bom Created",
                                          title: "Info",
                                        );
                                      },
                                    );
                                    setState(() {});
                                  }
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
                        uomController.text = "";
                        factoryController.text = "";
                        unitSizeController.text = "";
                        codeControllers = {};
                        uomControllers = {};
                        qtyControllers = {};
                        upperTolControllers = {};
                        lowerTolControllers = {};
                        overIssueControllers = {};
                        underIssueControllers = {};
                        setState(() {
                          rows = 0;
                        });
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
        : SuperPage(
            childWidget: buildWidget(
              createWidget(),
              context,
              "Create Bill of Material",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
