import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';

class CompanyCreatePage extends StatefulWidget {
  const CompanyCreatePage({Key? key}) : super(key: key);

  @override
  State<CompanyCreatePage> createState() => _CompanyCreatePageState();
}

class _CompanyCreatePageState extends State<CompanyCreatePage> {
  late TextEditingController usernameController,
      passwordController,
      firstNameController,
      lastNameController,
      emailController,
      companyNameController;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    companyNameController = TextEditingController();
    super.initState();
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
                  "Create New Company",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Administrator Details",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textField(false, firstNameController, "First Name", false),
                textField(false, lastNameController, "Last Name", false),
                textField(false, usernameController, "Username", false),
                textField(true, passwordController, "Password", false),
                textField(false, emailController, "E Mail ID", false),
                const Text(
                  "Company Details",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textField(false, companyNameController, "Company Name", false),
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
                        var username = usernameController.text;
                        var firstName = firstNameController.text;
                        var lastName = lastNameController.text;
                        var password = passwordController.text;
                        var email = emailController.text;
                        var companyName = companyNameController.text;

                        String errors = "";

                        if (username.isEmpty) {
                          errors += "Username Missing.\n";
                        }

                        if (firstName.isEmpty) {
                          errors += "First Name Missing.\n";
                        }

                        if (email.isEmpty) {
                          errors += "Email ID Missing.\n";
                        }

                        if (password.isEmpty) {
                          errors += "Password Missing.\n";
                        }

                        if (companyName.isEmpty) {
                          errors += "Company Name Missing.\n";
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
                          Map<String, dynamic> user = {
                            "username": username,
                            "first_name": firstName,
                            "last_name": lastName,
                            "password": password,
                            "email": email,
                          };
                          Map<String, dynamic> company = {"name": companyName};
                          await appStore.companyApp.create(company).then(
                            (companyResponse) async {
                              if (companyResponse["status"]) {
                                String companyID =
                                    companyResponse["payload"]["id"];
                                Map<String, dynamic> adminRole = {
                                  "company_id": companyID,
                                  "role": "Administrator",
                                  "description": "Administrator for Company",
                                };
                                await appStore.userRoleApp
                                    .create(adminRole)
                                    .then((roleResponse) async {
                                  if (roleResponse["status"]) {
                                    String roleID =
                                        roleResponse["payload"]["id"];
                                    user["user_role_id"] = roleID;
                                    await appStore.userApp
                                        .create(user)
                                        .then((userResponse) async {
                                      if (userResponse["status"]) {
                                        Map<String, String> userCompany = {
                                          "company_id": companyID,
                                          "user_username": username,
                                        };
                                        await appStore.userCompanyApp
                                            .create(userCompany)
                                            .then(
                                          (value) {
                                            if (value["status"]) {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const CustomDialog(
                                                    message:
                                                        "Company Details Created.",
                                                    title: "Info",
                                                  );
                                                },
                                              );
                                              usernameController.text = "";
                                              passwordController.text = "";
                                              firstNameController.text = "";
                                              lastNameController.text = "";
                                              emailController.text = "";
                                              companyNameController.text = "";
                                            } else {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CustomDialog(
                                                    message: value["message"],
                                                    title: "Errors",
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        );
                                      } else {
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                              message: userResponse["message"],
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
                                          message: roleResponse["message"],
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
                                      message: companyResponse["message"],
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
                        usernameController.text = "";
                        passwordController.text = "";
                        firstNameController.text = "";
                        lastNameController.text = "";
                        emailController.text = "";
                        companyNameController.text = "";
                      },
                      child: clearButton(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        createWidget(),
        context,
        "Create Customer",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
