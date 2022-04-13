import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/file_picker/file_picker.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

class UserRoleCreateWidget extends StatefulWidget {
  const UserRoleCreateWidget({Key? key}) : super(key: key);

  @override
  State<UserRoleCreateWidget> createState() => _UserRoleCreateWidgetState();
}

class _UserRoleCreateWidgetState extends State<UserRoleCreateWidget> {
  bool isLoadingPage = true;
  late TextEditingController roleController,
      descriptionController,
      fileController;
  late FilePickerResult? file;

  @override
  void initState() {
    getDetails();
    roleController = TextEditingController();
    descriptionController = TextEditingController();
    fileController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFile(FilePickerResult? result) {
    setState(() {
      file = result;
      fileController.text = result!.files.single.name;
    });
  }

  void getDetails() {
    setState(() {
      isLoadingPage = false;
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
                  "Create New User Role",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textField(false, roleController, "User Role", false),
                textField(
                    false, descriptionController, "Role Description", false),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () async {
                        var description = descriptionController.text;
                        var userRole = roleController.text;

                        String errors = "";

                        if (description.isEmpty || description == "") {
                          errors += "Role Description Missing.\n";
                        }

                        if (userRole.isEmpty) {
                          errors += "User Role Missing.\n";
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

                          Map<String, dynamic> role = {
                            "description": description,
                            "role": userRole,
                            "company_id": companyID,
                          };

                          await appStore.userRoleApp
                              .create(role)
                              .then((response) async {
                            if (response["status"]) {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "User Role Created.",
                                    title: "Info",
                                  );
                                },
                              );
                              roleController.text = "";
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
                    const SizedBox(
                      width: 10.0,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () {
                        roleController.text = "";
                        descriptionController.text = "";
                      },
                      child: clearButton(),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Multiple User Roles",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilePickerer(
                  hint: "Select File",
                  label: "Select File",
                  updateParent: getFile,
                  controller: fileController,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(menuItemColor),
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  onPressed: () async {
                    List<Map<String, dynamic>> userRoles = [];
                    // ignore: prefer_typing_uninitialized_variables
                    var csvData;
                    if (foundation.kIsWeb) {
                      final bytes = utf8.decode(file!.files.single.bytes!);
                      csvData = const CsvToListConverter().convert(bytes);
                    } else {
                      final path = fileController.text;
                      if (path.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const CustomDialog(
                              message: "Select File...",
                              title: "Errors",
                            );
                          },
                        );
                      } else {
                        final csvFile =
                            File(file!.files.single.path.toString()).openRead();
                        csvData = await csvFile
                            .transform(utf8.decoder)
                            .transform(
                              const CsvToListConverter(),
                            )
                            .toList();
                      }
                      for (var element in csvData) {
                        userRoles.add(
                          {
                            "description": element[1],
                            "role": element[0],
                          },
                        );
                      }
                      await appStore.userRoleApp.createMultiple(userRoles).then(
                        (value) {
                          if (value["status"]) {
                            int created = value["payload"]["models"].length;
                            int notCreated = value["payload"]["errors"].length;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  message: "Created " +
                                      created.toString() +
                                      " roles." +
                                      (notCreated != 0
                                          ? "Unable to create " +
                                              notCreated.toString() +
                                              " roles."
                                          : ""),
                                  title: "Info",
                                );
                              },
                            );
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
                        },
                      );
                    }
                  },
                  child: checkButton(),
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
    return isLoadingPage
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: buildWidget(
              createWidget(),
              context,
              "Create User Roles",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
