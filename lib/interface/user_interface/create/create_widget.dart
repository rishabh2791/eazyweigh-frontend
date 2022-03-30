import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/user_role.dart';
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

class UserCreateWidget extends StatefulWidget {
  const UserCreateWidget({Key? key}) : super(key: key);

  @override
  State<UserCreateWidget> createState() => _UserCreateWidgetState();
}

class _UserCreateWidgetState extends State<UserCreateWidget> {
  bool isLoadingData = true;
  List<UserRole> userRoles = [];
  List<Factory> factories = [];

  late TextEditingController usernameController,
      passwordController,
      firstNameController,
      lastNameController,
      emailController,
      userRoleController,
      factoryController;

  @override
  void initState() {
    super.initState();
    getAllData();
    usernameController = TextEditingController();
    userRoleController = TextEditingController();
    passwordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    factoryController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getAllData() async {
    await Future.forEach([
      await getFactories(),
      await getUserRole(),
    ], (element) {
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Future<dynamic> getFactories() async {
    factories = [];
    Map<String, dynamic> conditions = {"company_id": companyID};
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

  Future<dynamic> getUserRole() async {
    userRoles = [];
    Map<String, dynamic> conditions = {"company_id": companyID};
    await appStore.userRoleApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          if (item["role"] != "Superuser") {
            UserRole userRole = UserRole.fromJSON(item);
            userRoles.add(userRole);
          }
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
                  "Create New User",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textField(false, usernameController, "Username", false),
                textField(true, passwordController, "Password", false),
                textField(false, firstNameController, "First Name", false),
                textField(false, lastNameController, "Last Name", false),
                textField(false, emailController, "EMail", false),
                DropDownWidget(
                  disabled: false,
                  hint: "Select User Role",
                  controller: userRoleController,
                  itemList: userRoles,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Factory",
                  controller: factoryController,
                  itemList: factories,
                ),
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
                        var password = passwordController.text;
                        var firstName = firstNameController.text;
                        var lastName = lastNameController.text;
                        var email = emailController.text;
                        var userRole = userRoleController.text;
                        var factoryName = factoryController.text;

                        String errors = "";

                        if (username.isEmpty) {
                          errors += "Username Missing.\n";
                        }

                        if (password.isEmpty) {
                          errors += "Password Missing.\n";
                        }

                        if (firstName.isEmpty) {
                          errors += "First Name Missing.\n";
                        }

                        if (lastName.isEmpty) {
                          errors += "Last Name Missing.\n";
                        }

                        if (email.isEmpty) {
                          errors += "EMail Missing.\n";
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

                          Map<String, dynamic> user = {
                            "username": username,
                            "password": password,
                            "first_name": firstName,
                            "last_name": lastName,
                            "email": email,
                            "user_role_id": userRole,
                          };
                          await appStore.userApp.create(user).then(
                            (response) async {
                              if (response["status"]) {
                                Map<String, dynamic> userCompany = {
                                  "user_username": username,
                                  "company_id": companyID,
                                };
                                await appStore.userCompanyApp
                                    .create(userCompany)
                                    .then((userCompanyResponse) async {
                                  if (userCompanyResponse["status"]) {
                                    if (factoryName.isNotEmpty) {
                                      Map<String, dynamic> userFactory = {
                                        "user_username": username,
                                        "factory_id": factoryName,
                                      };
                                      await appStore.userFactoryApp
                                          .create(userFactory)
                                          .then(
                                        (value) {
                                          if (value["status"]) {
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const CustomDialog(
                                                  message: "User Created",
                                                  title: "Info",
                                                );
                                              },
                                            );
                                            userRoleController.text = "";
                                            passwordController.text = "";
                                            firstNameController.text = "";
                                            lastNameController.text = "";
                                            emailController.text = "";
                                            factoryController.text = "";
                                            userRoleController.text = "";
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
                                    } else {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const CustomDialog(
                                            message: "User Created",
                                            title: "Info",
                                          );
                                        },
                                      );
                                      userRoleController.text = "";
                                      passwordController.text = "";
                                      firstNameController.text = "";
                                      lastNameController.text = "";
                                      emailController.text = "";
                                      factoryController.text = "";
                                      userRoleController.text = "";
                                    }
                                  } else {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog(
                                          message:
                                              userCompanyResponse["message"],
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
                                      message: response["message"],
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
                        userRoleController.text = "";
                        passwordController.text = "";
                        firstNameController.text = "";
                        lastNameController.text = "";
                        emailController.text = "";
                        factoryController.text = "";
                        userRoleController.text = "";
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
    return isLoadingData
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: buildWidget(
              createWidget(),
              context,
              "Create User",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
