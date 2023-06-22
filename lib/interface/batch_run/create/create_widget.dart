import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';
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

class BatchRunCreateWidget extends StatefulWidget {
  const BatchRunCreateWidget({Key? key}) : super(key: key);

  @override
  State<BatchRunCreateWidget> createState() => _BatchRunCreateWidgetState();
}

class _BatchRunCreateWidgetState extends State<BatchRunCreateWidget> {
  bool isLoadingData = true;
  List<Factory> factories = [];
  List<Vessel> vessels = [];
  late TextEditingController factoryController, vesselController, jobCodeController;

  @override
  void initState() {
    factoryController = TextEditingController();
    vesselController = TextEditingController();
    jobCodeController = TextEditingController();
    factoryController.addListener(getFactoryVessels);
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
        factories.sort((a, b) => a.name.compareTo(b.name));
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

  Future<dynamic> getFactoryVessels() async {
    setState(() {
      isLoadingData = true;
    });
    vessels = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryController.text,
      }
    };
    await appStore.vesselApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          Vessel vessel = Vessel.fromJSON(item);
          vessels.add(vessel);
        }
        vessels.sort((a, b) => a.name.compareTo(b.name));
      }
    }).then((value) {
      setState(() {
        isLoadingData = false;
      });
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
                  "Start Batch",
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
                DropDownWidget(
                  disabled: false,
                  hint: "Select Vessel",
                  controller: vesselController,
                  itemList: vessels,
                ),
                textField(false, jobCodeController, "Job Code", false),
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () async {
                        Map<String, dynamic> postData = {};
                        var vesselID = vesselController.text;
                        var jobCode = jobCodeController.text;

                        String errors = "";

                        if (factoryController.text.isEmpty) {
                          errors += "Factory Missing.\n";
                        }

                        if (vesselID.isEmpty) {
                          errors += "Vessel Missing.\n";
                        } else {
                          postData["vessel_id"] = vesselID;
                        }

                        if (jobCode.isEmpty) {
                          errors += "Job Code Missing.\n";
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

                          Map<String, dynamic> conditions = {
                            "AND": [
                              {
                                "EQUALS": {
                                  "Field": "job_code",
                                  "Value": jobCode,
                                }
                              },
                              {
                                "EQUALS": {
                                  "Field": "factory_id",
                                  "Value": factoryController.text,
                                }
                              },
                            ]
                          };
                          await appStore.jobApp.list(conditions).then((value) async {
                            if (value.containsKey("status") && value["status"]) {
                              Job job = Job.fromJSON(value["payload"][0]);
                              postData["job_id"] = job.id;
                              var now = DateTime.now().toUtc();
                              String month = now.month < 10 ? "0" + now.month.toString() : now.month.toString();
                              String day = now.day < 10 ? "0" + now.day.toString() : now.day.toString();
                              String hour = now.hour < 10 ? "0" + now.hour.toString() : now.hour.toString();
                              String minute = now.minute < 10 ? "0" + now.minute.toString() : now.minute.toString();
                              String second = now.second < 10 ? "0" + now.second.toString() : now.second.toString();
                              postData["start_time"] = now.year.toString() + "-" + month + "-" + day + "T" + hour + ":" + minute + ":" + second + "Z";
                              await appStore.batchRunApp.create(postData).then((response) async {
                                if (response["status"]) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialog(
                                        message: "Batch Started",
                                        title: "Info",
                                      );
                                    },
                                  );
                                  factoryController.text = "";
                                  vesselController.text = "";
                                  jobCodeController.text = "";
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
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () {
                        factoryController.text = "";
                        vesselController.text = "";
                        jobCodeController.text = "";
                      },
                      child: clearButton(),
                    ),
                  ],
                ),
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
              "Start Batch",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
