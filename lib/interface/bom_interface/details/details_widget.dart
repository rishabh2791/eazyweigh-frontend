import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/bom_item.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/bom_interface/details/list.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';

class BOMDetailsWidget extends StatefulWidget {
  const BOMDetailsWidget({Key? key}) : super(key: key);

  @override
  State<BOMDetailsWidget> createState() => _BOMDetailsWidgetState();
}

class _BOMDetailsWidgetState extends State<BOMDetailsWidget> {
  bool isLoadingData = true;
  bool isBomItemsLoaded = false;
  List<Factory> factories = [];
  List<BomItem> bomItems = [];
  late TextEditingController materialCodeController, revisionController, factoryController;

  @override
  void initState() {
    getFactories();
    materialCodeController = TextEditingController();
    revisionController = TextEditingController();
    factoryController = TextEditingController();
    revisionController.text = "1";
    super.initState();
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

  @override
  void dispose() {
    super.dispose();
  }

  Widget detailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Get BOM Details",
          style: TextStyle(
            color: formHintTextColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DropDownWidget(disabled: false, hint: "Factory", controller: factoryController, itemList: factories),
            textField(false, materialCodeController, "Material Code", false),
            textField(false, revisionController, "Revision", false),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () async {
                setState(() {
                  isBomItemsLoaded = false;
                  bomItems = [];
                });
                String errors = "";
                var factoryID = factoryController.text;
                var materialCode = materialCodeController.text;
                var revision = revisionController.text;

                if (factoryID == "" || factoryID.isEmpty) {
                  errors += "Facrory Required. \n";
                }

                if (materialCode == "" || materialCode.isEmpty) {
                  errors += "Material Required. \n";
                }

                if (factoryID == "" || factoryID.isEmpty) {
                  errors += "Facrory Required. \n";
                }

                if (errors.isNotEmpty || errors != "") {
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
                  Map<String, dynamic> conditions = {
                    "AND": [
                      {
                        "EQUALS": {
                          "Field": "factory_id",
                          "Value": factoryID.toString(),
                        },
                      },
                      {
                        "EQUALS": {
                          "Field": "code",
                          "Value": materialCode.toString(),
                        },
                      },
                    ]
                  };
                  bomItems = [];
                  await appStore.materialApp.list(conditions).then((value) async {
                    if (value.containsKey("status") && value["status"] && value["payload"].isNotEmpty) {
                      Map<String, dynamic> conditions = {
                        "AND": [
                          {
                            "EQUALS": {
                              "Field": "factory_id",
                              "Value": factoryID.toString(),
                            },
                          },
                          {
                            "EQUALS": {
                              "Field": "material_id",
                              "Value": value["payload"][0]["id"],
                            },
                          },
                          {
                            "EQUALS": {
                              "Field": "revision",
                              "Value": int.parse(revision).toString(),
                            },
                          },
                        ]
                      };
                      await appStore.bomApp.list(conditions).then((response) async {
                        if (response["status"]) {
                          await Future.forEach(response["payload"], (dynamic item) async {
                            BomItem bomItem = await BomItem.fromServer(Map<String, dynamic>.from(item));
                            bomItems.add(bomItem);
                          }).then((value) {
                            setState(() {
                              isBomItemsLoaded = false;
                            });
                          });
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
                  });
                }
              },
              child: checkButton(),
            ),
          ],
        ),
        isBomItemsLoaded
            ? const Divider(
                color: Colors.transparent,
              )
            : Container(),
        isBomItemsLoaded
            ? bomItems.isNotEmpty
                ? BOMItemsListWidget(bomItems: bomItems)
                : const Center(
                    child: Text(
                      "No Data Found.",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: formHintTextColor,
                      ),
                    ),
                  )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeChanged,
      builder: (_, theme, child) {
        return isLoadingData
            ? SuperPage(
                childWidget: loader(context),
              )
            : SuperPage(
                childWidget: buildWidget(
                  detailsWidget(),
                  context,
                  "View Bill of Material",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
