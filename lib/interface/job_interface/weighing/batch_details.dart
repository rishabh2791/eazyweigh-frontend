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
                  : const Text(
                      "Details Found",
                      style: TextStyle(
                        color: menuItemColor,
                        fontSize: 30.0,
                      ),
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
