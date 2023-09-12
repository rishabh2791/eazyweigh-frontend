import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/job_interface/weighing/weighing_material_list.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:eazyweigh/interface/common/helper/mobile.dart' if (dart.library.html) 'package:eazyweigh/interface/common/helper/web.dart' as helper;

class MaterialWeighingDetailsWidget extends StatefulWidget {
  const MaterialWeighingDetailsWidget({Key? key}) : super(key: key);

  @override
  State<MaterialWeighingDetailsWidget> createState() => _MaterialWeighingDetailsWidgetState();
}

class _MaterialWeighingDetailsWidgetState extends State<MaterialWeighingDetailsWidget> {
  bool isLoadingData = true, isDataLoaded = false;
  late TextEditingController matCodeController, factoryController;
  List<Factory> factories = [];
  List<Mat> materials = [];
  late Mat chosenMaterial;
  List<MaterialWeighing> weighingMaterials = [];

  @override
  void initState() {
    super.initState();
    getFactories();
    factoryController = TextEditingController();
    matCodeController = TextEditingController();
    factoryController.addListener(getMaterials);
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

  Future<dynamic> getMaterials() async {
    materials = [];
    String factoryID = factoryController.text;
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryID,
      }
    };
    setState(() {
      isLoadingData = true;
    });
    await appStore.materialApp.list(conditions).then((response) async {
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
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Widget detailsWidget() {
    return isDataLoaded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              weighingMaterials.isEmpty
                  ? const Text(
                      "No Details Found",
                      style: TextStyle(
                        color: menuItemColor,
                        fontSize: 30.0,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Details Found for Material Code: " + matCodeController.text.toString(),
                          style: const TextStyle(
                            color: menuItemColor,
                            fontSize: 30.0,
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                            elevation: MaterialStateProperty.all<double>(5.0),
                          ),
                          onPressed: () async {
                            int start = 1;
                            final excel.Workbook workbook = excel.Workbook();
                            final excel.Worksheet sheet = workbook.worksheets[0];
                            sheet.getRangeByName("A1").setText("Job Code");
                            sheet.getRangeByName("B1").setText("Weight");
                            sheet.getRangeByName("C1").setText("Batch");
                            sheet.getRangeByName("D1").setText("Weighed By");
                            sheet.getRangeByName("E1").setText("Verified");
                            sheet.getRangeByName("F1").setText("Weighed On");
                            for (var weighingMaterial in weighingMaterials) {
                              start++;
                              sheet.getRangeByName("A" + start.toString()).setText(weighingMaterial.jobCode);
                              sheet.getRangeByName("B" + start.toString()).setText(weighingMaterial.weight.toStringAsFixed(3));
                              sheet.getRangeByName("C" + start.toString()).setText(weighingMaterial.batch.toUpperCase());
                              sheet.getRangeByName("D" + start.toString()).setText(weighingMaterial.updatedBy.toUpperCase());
                              sheet.getRangeByName("E" + start.toString()).setText(weighingMaterial.verified.toString());
                              sheet.getRangeByName("F" + start.toString()).setText(weighingMaterial.updatedAt.toLocal().toString());
                            }
                            final List<int> bytes = workbook.saveAsStream();
                            await helper.saveAndLaunchFile(bytes, 'JobWeighing.xlsx');
                            workbook.dispose();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Export",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: backgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              weighingMaterials.isEmpty
                  ? Container()
                  : MaterialWeighingListWidget(
                      weighingMaterials: weighingMaterials,
                    )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(minWidth: 300.0),
                    child: const Text(
                      "Factory:",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: formHintTextColor,
                      ),
                    ),
                  ),
                  DropDownWidget(
                    disabled: false,
                    hint: "Select Factory",
                    controller: factoryController,
                    itemList: factories,
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(minWidth: 300.0),
                    child: const Text(
                      "Material",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: formHintTextColor,
                      ),
                    ),
                  ),
                  textField(false, matCodeController, "Material Code", false),
                ],
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                  elevation: MaterialStateProperty.all<double>(5.0),
                ),
                onPressed: () async {
                  setState(() {
                    isLoadingData = true;
                  });
                  String factoryID = factoryController.text;
                  if (factoryID.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialog(
                          message: "Select Factory",
                          title: "Errors",
                        );
                      },
                    );
                  } else {
                    if (matCodeController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomDialog(
                            message: "Material Code Required",
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
                      weighingMaterials = [];

                      String materialID = "";

                      try {
                        chosenMaterial = materials.firstWhere((element) => element.code == matCodeController.text);
                        materialID = chosenMaterial.id;
                      } catch (e) {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const CustomDialog(
                              message: "Invalid Material",
                              title: "Errors",
                            );
                          },
                        );
                      }

                      if (materialID != "") {
                        await appStore.jobWeighingApp.materials(materialID).then((response) {
                          if (response.containsKey("status") && response["status"]) {
                            for (var item in response["payload"]) {
                              MaterialWeighing weighingBatch = MaterialWeighing.fromJSON(item);
                              weighingMaterials.add(weighingBatch);
                            }
                          }
                          Navigator.of(context).pop();
                          setState(() {
                            isDataLoaded = true;
                          });
                        });
                      }
                    }
                  }
                  setState(() {
                    isLoadingData = false;
                  });
                },
                child: checkButton(),
              ),
            ],
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
              detailsWidget(),
              context,
              "Get Material Batch Details",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}

class MaterialWeighing {
  final String jobItemID;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double weight;
  final String updatedBy;
  final String batch;
  final bool verified;
  final String materialID;
  final String jobID;
  final String jobCode;

  MaterialWeighing({
    required this.batch,
    required this.createdAt,
    required this.jobCode,
    required this.jobID,
    required this.jobItemID,
    required this.materialID,
    required this.updatedAt,
    required this.updatedBy,
    required this.verified,
    required this.weight,
  });

  factory MaterialWeighing.fromJSON(Map<String, dynamic> jsonObject) {
    MaterialWeighing weighing = MaterialWeighing(
      batch: jsonObject["batch"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      jobCode: jsonObject["job_code"].toString(),
      jobID: jsonObject["job_id"],
      jobItemID: jsonObject["job_item_id"],
      materialID: jsonObject["material_id"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: jsonObject["updated_by_username"],
      verified: jsonObject["verified"],
      weight: double.parse(jsonObject["weight"].toString()),
    );
    return weighing;
  }
}
