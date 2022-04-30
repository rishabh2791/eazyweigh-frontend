import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';

class FactoryCreateWidget extends StatefulWidget {
  const FactoryCreateWidget({Key? key}) : super(key: key);

  @override
  State<FactoryCreateWidget> createState() => _FactoryCreateWidgetState();
}

class _FactoryCreateWidgetState extends State<FactoryCreateWidget> {
  late TextEditingController line1Controller,
      line2Controller,
      cityController,
      stateController,
      zipController,
      countryController,
      factoryNameController;

  @override
  void initState() {
    super.initState();
    line1Controller = TextEditingController();
    line2Controller = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    zipController = TextEditingController();
    countryController = TextEditingController();
    factoryNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
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
                  "Create New Factory",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textField(false, factoryNameController, "Factory Name", false),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  "Address Details",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textField(false, line1Controller, "Address Line 1", false),
                textField(false, line2Controller, "Address LIne 2", false),
                textField(false, cityController, "City", false),
                textField(false, stateController, "State", false),
                textField(false, zipController, "ZIP Code", false),
                textField(false, countryController, "Country", false),
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
                        var line1 = line1Controller.text;
                        var line2 = line2Controller.text;
                        var city = cityController.text;
                        var state = stateController.text;
                        var zip = zipController.text;
                        var country = countryController.text;
                        var factoryName = factoryNameController.text;

                        String errors = "";

                        if (line1.isEmpty) {
                          errors += "Address Line 1 Missing.\n";
                        }

                        if (line2.isEmpty) {
                          errors += "Address Line 2 Missing.\n";
                        }

                        if (city.isEmpty) {
                          errors += "City Missing.\n";
                        }

                        if (state.isEmpty) {
                          errors += "State Missing.\n";
                        }

                        if (zip.isEmpty) {
                          errors += "Zip Missing.\n";
                        }

                        if (country.isEmpty) {
                          errors += "Country Missing.\n";
                        }

                        if (factoryName.isEmpty) {
                          errors += "Factory Name Missing.\n";
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
                          Map<String, dynamic> address = {
                            "line1": line1,
                            "line2": line2,
                            "city": city,
                            "state": state,
                            "zip": zip,
                            "country": country,
                            "company_id": companyID,
                          };

                          await appStore.addressApp.create(address).then(
                            (response) async {
                              if (response["status"]) {
                                String addressID = response["payload"]["id"];
                                Map<String, dynamic> fact = {
                                  "name": factoryName,
                                  "company_id": companyID,
                                  "address_id": addressID,
                                };
                                await appStore.factoryApp.create(fact).then(
                                  (value) async {
                                    if (value["status"]) {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const CustomDialog(
                                            message: "Factory Created.",
                                            title: "Info",
                                          );
                                        },
                                      );
                                      line1Controller.text = "";
                                      line2Controller.text = "";
                                      cityController.text = "";
                                      stateController.text = "";
                                      zipController.text = "";
                                      countryController.text = "";
                                      factoryNameController.text = "";
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
                        line1Controller.text = "";
                        line2Controller.text = "";
                        cityController.text = "";
                        stateController.text = "";
                        zipController.text = "";
                        countryController.text = "";
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
    return SuperPage(
      childWidget: buildWidget(
        createWidget(),
        context,
        "Create Factory",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
