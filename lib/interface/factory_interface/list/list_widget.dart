import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/factory_interface/list/list.dart';
import 'package:flutter/material.dart';

class FactoryListWidget extends StatefulWidget {
  const FactoryListWidget({Key? key}) : super(key: key);

  @override
  State<FactoryListWidget> createState() => _FactoryListWidgetState();
}

class _FactoryListWidgetState extends State<FactoryListWidget> {
  List<Factory> factories = [];
  bool isLoadingData = true;

  @override
  void initState() {
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

  Widget listWidget() {
    return factories.isEmpty
        ? const Center(
            child: Text(
              "No Factories Found.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50.0,
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jobs Found",
                style: TextStyle(
                  color: themeChanged.value ? foregroundColor : backgroundColor,
                  fontSize: 30.0,
                ),
              ),
              FactoriesListWidget(
                factories: factories,
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
                  "List Factories",
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
