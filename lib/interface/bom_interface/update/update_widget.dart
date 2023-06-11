import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/bom_item.dart';
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

class BOMUpdateWidget extends StatefulWidget {
  const BOMUpdateWidget({Key? key}) : super(key: key);

  @override
  State<BOMUpdateWidget> createState() => _BOMUpdateWidgetState();
}

class _BOMUpdateWidgetState extends State<BOMUpdateWidget> {
  bool isLoadingData = true;
  bool isBomItemsLoaded = false;
  List<Factory> factories = [];
  List<BomItem> bomItems = [];
  late TextEditingController materialCodeController, factoryController, revisionController;

  @override
  void initState() {
    materialCodeController = TextEditingController();
    factoryController = TextEditingController();
    revisionController = TextEditingController();
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
      if (response.containsKey("status")) {
        if (response["status"]) {
          for (var item in response["payload"]) {
            Factory fact = Factory.fromJSON(item);
            factories.add(fact);
          }
          setState(() {
            isLoadingData = false;
          });
        }
      }
    }).then((value) {
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Widget detailsWidget() {
    return isBomItemsLoaded
        ? const Column()
        : Column(
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
                        isLoadingData = true;
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
                          "factory_id": factoryID.toString(),
                          "material.code": materialCode.toString(),
                          "revision": int.parse(revision),
                        };
                        await appStore.bomApp.list(conditions).then((response) async {
                          if (response["status"]) {
                            for (var item in response["payload"][0]["bom_items"]) {
                              BomItem bomItem = BomItem.fromJSON(item);
                              bomItems.add(bomItem);
                            }
                            setState(() {
                              isBomItemsLoaded = true;
                              isLoadingData = false;
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
                    },
                    child: checkButton(),
                  ),
                ],
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
              "Update Bill of Material",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
