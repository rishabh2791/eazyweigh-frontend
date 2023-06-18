import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure_conversion.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/unit_of_measure_conversion%20_interface/list/list.dart';
import 'package:flutter/material.dart';

class UOMConversionListWidget extends StatefulWidget {
  const UOMConversionListWidget({Key? key}) : super(key: key);

  @override
  State<UOMConversionListWidget> createState() => _UOMConversionListWidgetState();
}

class _UOMConversionListWidgetState extends State<UOMConversionListWidget> {
  List<Factory> factories = [];
  List<UnitOfMeasurementConversion> uomConversions = [];
  bool isLoadingData = false;
  bool isDataLoaded = false;
  late TextEditingController factoryController;

  @override
  void initState() {
    factoryController = TextEditingController();
    super.initState();
    getFactories();
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

  Widget listWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DropDownWidget(
              disabled: false,
              hint: "Factory",
              controller: factoryController,
              itemList: factories,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () async {
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
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return loader(context);
                    },
                  );
                  uomConversions = [];

                  Map<String, dynamic> conditions = {
                    "EQUALS": {
                      "Field": "factory_id",
                      "Value": factoryID,
                    }
                  };
                  await appStore.unitOfMeasurementConversionApp.list(conditions).then((response) async {
                    if (response.containsKey("status") && response["status"]) {
                      await Future.forEach(response["payload"], (dynamic item) async {
                        UnitOfMeasurementConversion unitOfMeasurementConversion = await UnitOfMeasurementConversion.fromServer(Map<String, dynamic>.from(item));
                        uomConversions.add(unitOfMeasurementConversion);
                      }).then((value) {
                        Navigator.of(context).pop();
                        setState(() {
                          isDataLoaded = true;
                        });
                      });
                    }
                  });
                }
              },
              child: checkButton(),
            ),
          ],
        ),
        isDataLoaded
            ? uomConversions.isEmpty
                ? Text(
                    "No Conversions Found",
                    style: TextStyle(
                      color: themeChanged.value ? foregroundColor : backgroundColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : UOMConversionList(uomConversions: uomConversions)
            : const Column()
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
                  "Get UOMConversions List",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
