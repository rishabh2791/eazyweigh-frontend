import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job_item_weighing.dart';
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
import 'package:eazyweigh/interface/job_interface/weighing/weighing_batch_list.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:eazyweigh/interface/common/helper/mobile.dart'
    if (dart.library.html) 'package:eazyweigh/interface/common/helper/web.dart'
    as helper;

class WeighingBatchDetailsWidget extends StatefulWidget {
  const WeighingBatchDetailsWidget({Key? key}) : super(key: key);

  @override
  State<WeighingBatchDetailsWidget> createState() =>
      _WeighingBatchDetailsWidgetState();
}

class _WeighingBatchDetailsWidgetState
    extends State<WeighingBatchDetailsWidget> {
  bool isLoadingData = true, isDataLoaded = false;
  late TextEditingController batchController, factoryController;
  List<Factory> factories = [];
  List<Mat> materials = [];
  List<WeighingBatch> weighingBatches = [];

  @override
  void initState() {
    super.initState();
    getFactories();
    factoryController = TextEditingController();
    batchController = TextEditingController();
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
              weighingBatches.isEmpty
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
                        const Text(
                          "Details Found",
                          style: TextStyle(
                            color: menuItemColor,
                            fontSize: 30.0,
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(menuItemColor),
                            elevation: MaterialStateProperty.all<double>(5.0),
                          ),
                          onPressed: () async {
                            int start = 1;
                            final excel.Workbook workbook = excel.Workbook();
                            final excel.Worksheet sheet =
                                workbook.worksheets[0];
                            sheet.getRangeByName("A1").setText("Job Code");
                            sheet.getRangeByName("B1").setText("Material Code");
                            sheet
                                .getRangeByName("C1")
                                .setText("Material Description");
                            sheet
                                .getRangeByName("D1")
                                .setText("Required Weight (KG)");
                            sheet
                                .getRangeByName("E1")
                                .setText("Actual Weight (KG)");
                            sheet.getRangeByName("F1").setText("Weighed By");
                            sheet.getRangeByName("G1").setText("Weighed On");
                            for (var weighingBatch in weighingBatches) {
                              start++;
                              sheet
                                  .getRangeByName("A" + start.toString())
                                  .setText(weighingBatch.jobCode);
                              sheet
                                  .getRangeByName("B" + start.toString())
                                  .setText(materials
                                      .firstWhere((element) =>
                                          element.id ==
                                          weighingBatch.jobMaterialID)
                                      .code);
                              sheet
                                  .getRangeByName("C" + start.toString())
                                  .setText(materials
                                      .firstWhere((element) =>
                                          element.id ==
                                          weighingBatch.jobMaterialID)
                                      .description);
                              sheet
                                  .getRangeByName("D" + start.toString())
                                  .setText(weighingBatch.requiredWeight
                                      .toStringAsFixed(3));
                              sheet
                                  .getRangeByName("E" + start.toString())
                                  .setText(weighingBatch.actualWeight
                                      .toStringAsFixed(3));
                              sheet
                                  .getRangeByName("F" + start.toString())
                                  .setText(weighingBatch.createdByUsername
                                      .toUpperCase());
                              sheet
                                  .getRangeByName("G" + start.toString())
                                  .setText(weighingBatch.createdAt
                                      .toLocal()
                                      .toString()
                                      .substring(0, 10));
                            }
                            final List<int> bytes = workbook.saveAsStream();
                            await helper.saveAndLaunchFile(
                                bytes, 'JobWeighing.xlsx');
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
              weighingBatches.isEmpty
                  ? Container()
                  : WeighingBatchList(
                      weighingBatches: weighingBatches,
                      materials: materials,
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
                      "RM Batch",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: formHintTextColor,
                      ),
                    ),
                  ),
                  textField(false, batchController, "RM Batch", false),
                ],
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(menuItemColor),
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
                    if (batchController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomDialog(
                            message: "Batch Number Required",
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
                      weighingBatches = [];

                      Map<String, dynamic> conditions = {
                        "EQUALS": {
                          "Field": "batch",
                          "Value": batchController.text,
                        }
                      };
                      await appStore.jobWeighingApp
                          .details(conditions)
                          .then((response) {
                        if (response.containsKey("status") &&
                            response["status"]) {
                          for (var item in response["payload"]) {
                            WeighingBatch weighingBatch =
                                WeighingBatch.fromJSON(item);
                            weighingBatches.add(weighingBatch);
                          }
                        }
                        Navigator.of(context).pop();
                        setState(() {
                          isDataLoaded = true;
                        });
                      });
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
