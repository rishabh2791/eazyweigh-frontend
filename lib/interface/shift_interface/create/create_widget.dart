import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
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

class ShiftCreateWidget extends StatefulWidget {
  const ShiftCreateWidget({Key? key}) : super(key: key);

  @override
  State<ShiftCreateWidget> createState() => _ShiftCreateWidgetState();
}

class _ShiftCreateWidgetState extends State<ShiftCreateWidget> {
  bool isLoadingData = true;
  late TextEditingController codeController,
      descriptionController,
      startTimeController,
      endTimeController,
      factoryController;
  List<Factory> factories = [];

  @override
  void initState() {
    codeController = TextEditingController();
    descriptionController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
    factoryController = TextEditingController();
    getFactories();
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
                  "Create Shift",
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
                textField(false, codeController, "Shift Code", false),
                textField(
                    false, descriptionController, "Shift Description", false),
                textField(
                    false, startTimeController, "Start Time (HH:MM)", false),
                textField(false, endTimeController, "End Time (HH:MM)", false),
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
                        var startTime = startTimeController.text;
                        var endTime = endTimeController.text;
                        var factoryID = factoryController.text;

                        String errors = "";

                        if (code.isEmpty) {
                          errors += "Shift Missing.\n";
                        }

                        if (description.isEmpty) {
                          errors += "Shift Description Missing.\n";
                        }

                        if (startTime.isEmpty) {
                          errors += "Start Time Missing.\n";
                        }

                        if (endTime.isEmpty) {
                          errors += "End Time Missing.\n";
                        }

                        if (factoryID.isEmpty) {
                          errors += "Factory Selection Missing.\n";
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
                          Map<String, dynamic> shift = {
                            "code": code,
                            "description": description,
                            "factory_id": factoryID,
                            "start_time": startTime,
                            "end_time": endTime,
                          };
                          await appStore.shiftApp
                              .create(shift)
                              .then((response) async {
                            if (response["status"]) {
                              codeController.text = "";
                              descriptionController.text = "";
                              startTimeController.text = "";
                              endTimeController.text = "";
                              factoryController.text = "";
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "Shift Created.",
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
                        startTimeController.text = "";
                        endTimeController.text = "";
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
              "Create Shift",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
