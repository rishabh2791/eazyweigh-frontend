import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/step_type.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';

class StepTypeUpdateWidget extends StatefulWidget {
  final StepType stepType;
  const StepTypeUpdateWidget({Key? key, required this.stepType}) : super(key: key);

  @override
  State<StepTypeUpdateWidget> createState() => _StepTypeUpdateWidgetState();
}

class _StepTypeUpdateWidgetState extends State<StepTypeUpdateWidget> {
  bool isLoadingData = true;

  late TextEditingController nameController, factoryController, titleController, bodyController, footerController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    titleController = TextEditingController();
    bodyController = TextEditingController();
    footerController = TextEditingController();
    nameController.text = widget.stepType.name;
    titleController.text = widget.stepType.title;
    bodyController.text = widget.stepType.body;
    footerController.text = widget.stepType.footer;
    isLoadingData = false;
  }

  @override
  void dispose() {
    super.dispose();
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
                  "Update StepType",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textField(false, nameController, "Step Type Name", false),
                textField(false, titleController, "Display Title", false),
                textField(false, bodyController, "Display Body", false),
                textField(false, footerController, "Display Footer", false),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  onPressed: () async {
                    var name = nameController.text;
                    var title = titleController.text;
                    var body = bodyController.text;
                    var footer = footerController.text;

                    String errors = "";

                    if (name.isEmpty) {
                      errors += "Step Type Name Missing.\n";
                    }

                    if (title.isEmpty) {
                      errors += "Display Title Missing.\n";
                    }

                    if (body.isEmpty) {
                      errors += "Display Body Missing.\n";
                    }

                    if (footer.isEmpty) {
                      errors += "Display Footer Missing.\n";
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

                      Map<String, dynamic> stepType = {
                        "description": name,
                        "title": title,
                        "body": body,
                        "footer": footer,
                      };

                      await appStore.stepTypeApp.update(widget.stepType.id, stepType).then((response) async {
                        if (response["status"]) {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                message: "Step Type Updated",
                                title: "Info",
                              );
                            },
                          );
                          widget.stepType.title = title;
                          widget.stepType.body = body;
                          widget.stepType.footer = footer;
                          setState(() {
                            widget.stepType.name = nameController.text;
                          });
                          nameController.text = "";
                          titleController.text = "";
                          bodyController.text = "";
                          footerController.text = "";
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
                  },
                  child: checkButton(),
                ),
                const Divider(
                  height: 50.0,
                  color: Colors.transparent,
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
              "Update Step Type",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
