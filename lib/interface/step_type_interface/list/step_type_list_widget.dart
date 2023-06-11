import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/step_type.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/step_type_interface/list/list.dart';
import 'package:flutter/material.dart';

class StepTypeListWidget extends StatefulWidget {
  const StepTypeListWidget({Key? key}) : super(key: key);

  @override
  State<StepTypeListWidget> createState() => _StepTypeListWidgetState();
}

class _StepTypeListWidgetState extends State<StepTypeListWidget> {
  List<Factory> factories = [];
  List<StepType> stepTypes = [];
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
                  stepTypes = [];

                  Map<String, dynamic> conditions = {
                    "EQUALS": {
                      "Field": "factory_id",
                      "Value": factoryID,
                    }
                  };
                  await appStore.stepTypeApp.list(conditions).then((response) {
                    if (response.containsKey("status") && response["status"]) {
                      for (var item in response["payload"]) {
                        StepType stepType = StepType.fromJSON(item);
                        stepTypes.add(stepType);
                      }
                      stepTypes.sort((a, b) => a.name.compareTo(b.name));
                    }
                    Navigator.of(context).pop();
                    setState(() {
                      isDataLoaded = true;
                    });
                  });
                }
              },
              child: checkButton(),
            ),
          ],
        ),
        isDataLoaded
            ? stepTypes.isEmpty
                ? const Text(
                    "No Step Types Found",
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : StepTypeList(stepTypes: stepTypes)
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
                  "Step Types List",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
