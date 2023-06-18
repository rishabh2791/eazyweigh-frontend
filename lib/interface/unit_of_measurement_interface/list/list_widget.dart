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
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/unit_of_measurement_interface/list/list.dart';
import 'package:flutter/material.dart';

class UOMListWidget extends StatefulWidget {
  const UOMListWidget({Key? key}) : super(key: key);

  @override
  State<UOMListWidget> createState() => _UOMListWidgetState();
}

class _UOMListWidgetState extends State<UOMListWidget> {
  List<Factory> factories = [];
  List<UnitOfMeasure> uoms = [];
  bool isLoadingData = true;
  bool isDataLoaded = false;
  late TextEditingController factoryController;

  @override
  void initState() {
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
        await Future.forEach(response["payload"], (dynamic item) async {
          Factory factory = await Factory.fromServer(Map<String, dynamic>.from(item));
          factories.add(factory);
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
    }).then((value) {
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Widget listWidget() {
    return isDataLoaded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              uoms.isEmpty
                  ? Text(
                      "No Unit of Measures Found",
                      style: TextStyle(color: themeChanged.value ? foregroundColor : backgroundColor, fontSize: 20.0),
                    )
                  : Text(
                      "Found Unit of Measures",
                      style: TextStyle(color: themeChanged.value ? foregroundColor : backgroundColor, fontSize: 20.0),
                    ),
              uoms.isEmpty ? Container() : UOMList(uoms: uoms),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropDownWidget(
                disabled: false,
                hint: "Select Factory",
                controller: factoryController,
                itemList: factories,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                  elevation: MaterialStateProperty.all<double>(5.0),
                ),
                onPressed: () async {
                  var factoryID = factoryController.text;
                  if (factoryID == "" || factoryID.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialog(
                          message: "Factory Required",
                          title: "Errors",
                        );
                      },
                    );
                  } else {
                    Map<String, dynamic> conditions = {
                      "EQUALS": {
                        "Field": "factory_id",
                        "Value": factoryID,
                      }
                    };

                    await appStore.unitOfMeasurementApp.list(conditions).then((response) async {
                      if (response.containsKey("status") && response["status"]) {
                        await Future.forEach(response["payload"], (dynamic item) async {
                          UnitOfMeasure uom = await UnitOfMeasure.fromServer(Map<String, dynamic>.from(item));
                          uoms.add(uom);
                        });
                      }
                    }).then((value) {
                      setState(() {
                        isDataLoaded = true;
                      });
                    });
                  }
                },
                child: checkButton(),
              ),
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
                  listWidget(),
                  context,
                  "Get UOM List",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
