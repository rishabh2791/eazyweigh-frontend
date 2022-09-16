import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/job_interface/job_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobUpdateWidget extends StatefulWidget {
  const JobUpdateWidget({Key? key}) : super(key: key);

  @override
  State<JobUpdateWidget> createState() => _JobUpdateWidgetState();
}

class _JobUpdateWidgetState extends State<JobUpdateWidget> {
  List<Factory> factories = [];
  bool isLoading = true;
  bool isDataLoaded = false;
  late Job job;
  late TextEditingController factoryController,
      jobCodeController,
      oldQtyController,
      newQtyController;

  @override
  void initState() {
    getFactories();
    factoryController = TextEditingController();
    jobCodeController = TextEditingController();
    oldQtyController = TextEditingController();
    newQtyController = TextEditingController();
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
          isLoading = false;
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

  Widget detailsWidget() {
    return ValueListenableBuilder(
      valueListenable: themeChanged,
      builder: (_, theme, child) {
        return isDataLoaded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Job Code",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: themeChanged.value
                                  ? foregroundColor
                                  : backgroundColor,
                            ),
                          ),
                        ),
                        Text(
                          job.jobCode.toString(),
                          style: TextStyle(
                            fontSize: 30.0,
                            color: themeChanged.value
                                ? foregroundColor
                                : backgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Material",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: themeChanged.value
                                  ? foregroundColor
                                  : backgroundColor,
                            ),
                          ),
                        ),
                        Text(
                          job.material.code.toString() +
                              " " +
                              job.material.description,
                          style: TextStyle(
                            fontSize: 30.0,
                            color: themeChanged.value
                                ? foregroundColor
                                : backgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Old Quantity",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: themeChanged.value
                                  ? foregroundColor
                                  : backgroundColor,
                            ),
                          ),
                        ),
                        Text(
                          job.quantity.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 30.0,
                            color: themeChanged.value
                                ? foregroundColor
                                : backgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            "New Quantity",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: themeChanged.value
                                  ? foregroundColor
                                  : backgroundColor,
                            ),
                          ),
                        ),
                        textField(
                            false, newQtyController, "New Quantity", false),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                    height: 50,
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(menuItemColor),
                            elevation: MaterialStateProperty.all<double>(5.0),
                          ),
                          onPressed: () async {
                            double oldQuantity = job.quantity;
                            double newQuantity =
                                double.parse(newQtyController.text);
                            if (newQuantity == oldQuantity) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "No Change in Quanity",
                                    title: "Error",
                                  );
                                },
                              );
                            } else {
                              Map<String, dynamic> updated = {
                                "quantity": newQuantity,
                              };
                              await appStore.jobApp
                                  .update(job.jobCode, updated)
                                  .then((response) {
                                if (response.containsKey("status") &&
                                    response["status"]) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialog(
                                        message: "Job Updated",
                                        title: "Info",
                                      );
                                    },
                                  );
                                } else {
                                  if (response.containsKey("status")) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog(
                                          message: response["message"],
                                          title: "Error",
                                        );
                                      },
                                    );
                                  } else {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const CustomDialog(
                                          message: "Unable to Update Job",
                                          title: "Error",
                                        );
                                      },
                                    );
                                  }
                                }
                              });
                            }
                          },
                          child: checkButton(),
                        ),
                        const VerticalDivider(
                          color: Colors.transparent,
                          width: 20,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(menuItemColor),
                            elevation: MaterialStateProperty.all<double>(5.0),
                          ),
                          onPressed: () {
                            navigationService.pushReplacement(
                              CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    const JobUpdateWidget(),
                              ),
                            );
                          },
                          child: clearButton(),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get Job Details:",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: themeChanged.value
                          ? backgroundColor
                          : foregroundColor,
                    ),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      DropDownWidget(
                        disabled: false,
                        hint: "Select Factory",
                        controller: factoryController,
                        itemList: factories,
                      ),
                      textField(
                        false,
                        jobCodeController,
                        "Job Code",
                        false,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(menuItemColor),
                          elevation: MaterialStateProperty.all<double>(5.0),
                        ),
                        onPressed: () async {
                          String errors = "";
                          var factoryID = factoryController.text;
                          var jobCode = jobCodeController.text;

                          if (factoryID.isEmpty || factoryID == "") {
                            errors += "Factory Required\n";
                          }

                          if (jobCode == "" || jobCode.isEmpty) {
                            errors += "Job Code Required.\n";
                          }

                          if (errors.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  message: errors,
                                  title: "Error",
                                );
                              },
                            );
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            Map<String, dynamic> conditions = {
                              "AND": [
                                {
                                  "EQUALS": {
                                    "Field": "job_code",
                                    "Value": jobCode,
                                  },
                                },
                                {
                                  "EQUALS": {
                                    "Field": "factory_id",
                                    "Value": factoryID,
                                  },
                                },
                              ],
                            };
                            await appStore.jobApp
                                .list(conditions)
                                .then((value) async {
                              if (value.containsKey("status") &&
                                  value["status"]) {
                                if (value["payload"].isNotEmpty) {
                                  job = Job.fromJSON(value["payload"][0]);
                                }
                              }
                            }).then((value) {
                              setState(() {
                                isDataLoaded = true;
                                isLoading = false;
                              });
                            });
                          }
                        },
                        child: checkButton(),
                      ),
                    ],
                  ),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SuperPage(childWidget: loader(context))
        : SuperPage(
            childWidget: buildWidget(
              detailsWidget(),
              context,
              "Job Update",
              () {
                navigationService.pushReplacement(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => const JobWidget(),
                  ),
                );
              },
            ),
          );
  }
}
