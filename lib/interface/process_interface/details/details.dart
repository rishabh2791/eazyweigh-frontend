import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/process.dart';
import 'package:eazyweigh/domain/entity/step.dart' as step_entity;
import 'package:eazyweigh/domain/entity/step_type.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ignore: must_be_immutable
class DetailsWidget extends StatefulWidget {
  final Process process;
  final String factoryID;
  List<StepType> stepTypes;
  List<Mat> materials;
  double batchSize;
  DetailsWidget({
    Key? key,
    required this.process,
    required this.factoryID,
    this.stepTypes = const [],
    this.materials = const [],
    this.batchSize = 100.0,
  }) : super(key: key);

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  bool isLoadingData = true;
  late Process process;
  List<Mat> materials = [];
  List<StepType> stepTypes = [];
  int currentIndex = 0, start = 0, end = 2;
  String complete = '{"action":"complete"}';

  @override
  void initState() {
    process = widget.process;
    process.steps.sort((a, b) => a.sequence.compareTo(b.sequence));
    getData();
    scannerListener.addListener(listenToScanner);
    super.initState();
  }

  dynamic listenToScanner(String data) async {
    Map<String, dynamic> scannerData = jsonDecode(data.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "complete":
        setState(() {
          if (currentIndex + 1 <= process.steps.length - 1) {
            currentIndex++;
          } else {
            //TODO complete batch processing.
          }
        });
        break;
      case "logout":
        break;
      default:
        break;
    }
  }

  Future<void> getData() async {
    if (widget.stepTypes.isEmpty) {
      setState(() {
        isLoadingData = true;
      });
      await Future.forEach([
        await getStepTypes(),
        await getMaterials(),
      ], (element) => null).then((value) {
        stepTypes.sort(((a, b) => a.name.compareTo(b.name)));
        materials.sort(((a, b) => a.code.compareTo(b.code)));
        setState(() {
          isLoadingData = false;
        });
      });
    } else {
      stepTypes = widget.stepTypes;
      materials = widget.materials;
      setState(() {
        isLoadingData = false;
      });
    }
  }

  Future<void> getStepTypes() async {
    stepTypes = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": widget.factoryID,
      }
    };
    await appStore.stepTypeApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          StepType stepType = StepType.fromJSON(item);
          stepTypes.add(stepType);
        }
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

  Future<void> getMaterials() async {
    materials = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": widget.factoryID,
      }
    };
    await appStore.materialApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          Mat material = Mat.fromJSON(item);
          materials.add(material);
        }
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

  Widget card(step_entity.Step step, double size, double fontSize, double opacity) {
    Widget thisWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: size,
        height: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.stepType.title,
              style: TextStyle(
                fontSize: fontSize,
                color: formHintTextColor.withOpacity(opacity),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              step.stepType.name.contains("Raw Material")
                  ? step.stepType.body +
                      " " +
                      materials.firstWhere((element) => element.id == step.materialID).code +
                      " - " +
                      materials.firstWhere((element) => element.id == step.materialID).description
                  : step.stepType.name.contains("Agitat")
                      ? step.stepType.body + " " + step.value.toString() + " " + "RPM"
                      : step.stepType.body,
              style: TextStyle(
                fontSize: fontSize,
                color: formHintTextColor.withOpacity(opacity),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              step.stepType.name.contains("Raw Material")
                  ? step.stepType.footer + ": " + (widget.batchSize * step.value / 100).toString() + " KG"
                  : step.stepType.name.contains("Agitat")
                      ? step.stepType.footer + " " + step.duration.toString() + " " + " min"
                      : step.stepType.footer + ": " + (step.value).toString(),
              style: TextStyle(
                fontSize: fontSize,
                color: formHintTextColor.withOpacity(opacity),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
    return thisWidget;
  }

  Widget currentStepWidget(double size, int index, double fontSize, double opacity) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: foregroundColor.withOpacity(opacity),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 10), blurRadius: 10),
        ],
      ),
      child: card(process.steps[index], size, fontSize, opacity),
    );
  }

  Widget processWidget() {
    return BaseWidget(builder: (context, screenSizeInformation) {
      return SizedBox(
        height: screenSizeInformation.screenSize.height - 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Process Steps for " + widget.process.material.code.toString() + " - " + widget.process.material.description,
              style: const TextStyle(
                color: formHintTextColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              height: 75.0,
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentIndex == 0
                    ? Container(
                        width: 300,
                      )
                    : SizedBox(
                        width: 300,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              currentIndex--;
                            });
                          },
                          child: currentStepWidget(200, currentIndex - 1, 16, 0.5),
                        ),
                      ),
                Column(
                  children: [
                    currentStepWidget(400, currentIndex, 32, 1),
                    const Divider(
                      height: 10,
                      color: Colors.transparent,
                    ),
                    currentUser.userRole.role == "Processor"
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                if (currentIndex + 1 <= process.steps.length - 1) {
                                  currentIndex++;
                                } else {
                                  //TODO complete batch processing.
                                }
                              });
                            },
                            child: QrImageView(
                              data: complete,
                              size: 200,
                              backgroundColor: Colors.green,
                              semanticsLabel: "Done",
                            ),
                          )
                        : Container(),
                  ],
                ),
                currentIndex == process.steps.length - 1
                    ? Container(
                        width: 300,
                      )
                    : SizedBox(
                        width: 300,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              currentIndex++;
                            });
                          },
                          child: currentStepWidget(200, currentIndex + 1, 16, 0.5),
                        ),
                      ),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingData ? loader(context) : processWidget();
  }
}
