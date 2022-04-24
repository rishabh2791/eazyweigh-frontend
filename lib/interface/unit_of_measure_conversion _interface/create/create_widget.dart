import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';

class UOMConversionCreateWidget extends StatefulWidget {
  const UOMConversionCreateWidget({Key? key}) : super(key: key);

  @override
  State<UOMConversionCreateWidget> createState() =>
      _UOMConversionCreateWidgetState();
}

class _UOMConversionCreateWidgetState extends State<UOMConversionCreateWidget> {
  bool isLoadingData = true;
  List<Factory> factories = [];
  List<UnitOfMeasure> uoms = [];

  late TextEditingController uom1Controller,
      uom2Controller,
      factoryController,
      valueController;

  @override
  void initState() {
    super.initState();
    getFactories();
    uom1Controller = TextEditingController();
    uom2Controller = TextEditingController();
    valueController = TextEditingController();
    factoryController = TextEditingController();
    factoryController.addListener(getUOMs);
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
                  "Create New Unit of Measurement Conversion",
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
                const Text(
                  "1 Unit of ",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select UOM 1",
                  controller: uom1Controller,
                  itemList: uoms,
                ),
                const Text(
                  "is ",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textField(false, valueController, "Value", false),
                const Text(
                  "units of",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select UOM 2",
                  controller: uom2Controller,
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
                        var uom1 = uom1Controller.text;
                        var uom2 = uom2Controller.text;
                        var value = valueController.text;
                        var factoryName = factoryController.text;

                        String errors = "";

                        if (uom1.isEmpty) {
                          errors += "UOM 1 Code Missing.\n";
                        }

                        if (uom2.isEmpty) {
                          errors += "UOM 2 Code Missing.\n";
                        }

                        if (factoryName.isEmpty) {
                          errors += "Factory Missing.\n";
                        }

                        if (uom1 == uom2) {
                          errors += "Both Units can not be same.\n";
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

                          Map<String, dynamic> uom = {
                            "unit1_id": uom1,
                            "unit2_id": uom2,
                            "value1": 1,
                            "value2": double.parse(value),
                            "factory_id": factoryName,
                          };

                          await appStore.unitOfMeasurementConversionApp
                              .create(uom)
                              .then((response) async {
                            if (response["status"]) {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "UOM Conversion Created",
                                    title: "Info",
                                  );
                                },
                              );
                              uom1Controller.text = "";
                              uom2Controller.text = "";
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
                        uom1Controller.text = "";
                        uom2Controller.text = "";
                        factoryController.text = "";
                      },
                      child: clearButton(),
                    ),
                  ],
                )
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
