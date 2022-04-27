import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/shift.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/shift_interface/list/list.dart';
import 'package:flutter/material.dart';

class ShiftListWidget extends StatefulWidget {
  const ShiftListWidget({Key? key}) : super(key: key);

  @override
  State<ShiftListWidget> createState() => _ShiftListWidgetState();
}

class _ShiftListWidgetState extends State<ShiftListWidget> {
  bool isLoadingData = true;
  bool isDataLoaded = false;
  List<Factory> factories = [];
  List<Shift> shifts = [];
  late TextEditingController factoryController;

  @override
  void initState() {
    getFactories();
    factoryController = TextEditingController();
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

  Widget listWidget() {
    return isDataLoaded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shifts.isEmpty ? "Not Shifts Found" : "Found Shifts",
                style: TextStyle(
                  fontSize: 20.0,
                  color: themeChanged.value ? foregroundColor : backgroundColor,
                ),
              ),
              shifts.isEmpty ? Container() : ShiftList(shifts: shifts),
            ],
          )
        : Row(
            children: [
              DropDownWidget(
                disabled: false,
                hint: "Select Factory",
                controller: factoryController,
                itemList: factories,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(menuItemColor),
                  elevation: MaterialStateProperty.all<double>(5.0),
                ),
                onPressed: () async {
                  shifts = [];
                  var factoryID = factoryController.text;
                  if (factoryID.isEmpty || factoryID == "") {
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
                      },
                    };
                    await appStore.shiftApp.list(conditions).then((response) {
                      if (response.containsKey("status") &&
                          response["status"]) {
                        for (var item in response["payload"]) {
                          Shift shift = Shift.fromJSON(item);
                          shifts.add(shift);
                        }
                      }
                    }).then((value) {
                      setState(() {
                        isLoadingData = false;
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
                  "Get Shifts List",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
