import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';

class VesselUpdateWidget extends StatefulWidget {
  final Vessel vessel;
  const VesselUpdateWidget({Key? key, required this.vessel}) : super(key: key);

  @override
  State<VesselUpdateWidget> createState() => _VesselUpdateWidgetState();
}

class _VesselUpdateWidgetState extends State<VesselUpdateWidget> {
  bool isLoadingData = true;

  late TextEditingController nameController, factoryController, fileController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    nameController.text = widget.vessel.name;
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
                  "Update Vessel",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textField(false, nameController, "Vessel Name", false),
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

                    String errors = "";

                    if (name.isEmpty) {
                      errors += "Vessel Name Missing.\n";
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

                      Map<String, dynamic> vessel = {
                        "description": name,
                      };

                      await appStore.vesselApp.update(widget.vessel.id, vessel).then((response) async {
                        if (response["status"]) {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                message: "Vessel Updated",
                                title: "Info",
                              );
                            },
                          );
                          setState(() {
                            widget.vessel.name = nameController.text;
                          });
                          nameController.text = "";
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
              "Update Vessel",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
