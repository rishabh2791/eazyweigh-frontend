import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/device_type.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';

class DeviceTypeUpdateWidget extends StatefulWidget {
  final DeviceType deviceType;
  const DeviceTypeUpdateWidget({Key? key, required this.deviceType}) : super(key: key);

  @override
  State<DeviceTypeUpdateWidget> createState() => _DeviceTypeUpdateWidgetState();
}

class _DeviceTypeUpdateWidgetState extends State<DeviceTypeUpdateWidget> {
  bool isLoadingData = true;

  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    descriptionController.text = widget.deviceType.description;
    isLoadingData = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget updateWidget() {
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
                  "Update Device Type",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textField(false, descriptionController, "Device Type Description", false),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  onPressed: () async {
                    var description = descriptionController.text;

                    String errors = "";

                    if (description.isEmpty) {
                      errors += "Device Type Description Missing.\n";
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

                      Map<String, dynamic> deviceType = {
                        "description": description,
                      };

                      await appStore.deviceTypeApp.update(widget.deviceType.id, deviceType).then((response) async {
                        if (response["status"]) {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                message: "Device Type Updated",
                                title: "Info",
                              );
                            },
                          );
                          setState(() {
                            widget.deviceType.description = descriptionController.text;
                          });
                          descriptionController.text = "";
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
              updateWidget(),
              context,
              "Update DeviceType",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
