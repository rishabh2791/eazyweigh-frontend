import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/user_role.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/permission_code_selector_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class UserRoleAccessListWidget extends StatefulWidget {
  const UserRoleAccessListWidget({Key? key}) : super(key: key);

  @override
  State<UserRoleAccessListWidget> createState() => _UserRoleAccessListWidgetState();
}

class _UserRoleAccessListWidgetState extends State<UserRoleAccessListWidget> {
  List<String> tables = [];
  List<UserRole> userRoles = [];
  bool isLoadingData = false;
  bool isRoleSelected = false;
  late TextEditingController userRoleController;
  Map<String, TextEditingController> controllers = {};
  Map<String, String> existingPermissions = {};

  @override
  void initState() {
    getAllData();
    userRoleController = TextEditingController();
    userRoleController.addListener(listenToRoleChange);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAllData() async {
    await Future.forEach([
      await getUserRoles(),
      await getTables(),
    ], (element) {
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Future<void> getUserRoles() async {
    userRoles = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "company_id",
        "Value": companyID,
      },
    };
    await appStore.userRoleApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          if (item["role"] != "Superuser") {
            UserRole userRole = UserRole.fromJSON(item);
            userRoles.add(userRole);
          }
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
    userRoles.sort(((a, b) => a.description.compareTo(b.description)));
  }

  Future<void> getTables() async {
    await appStore.commonApp.getTables().then((response) async {
      if (response.containsKey("error")) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              message: response["error"],
              title: "Errors",
            );
          },
        );
      } else {
        if (response["status"]) {
          for (var item in response["payload"]) {
            if (!item.toString().contains("compan")) {
              tables.add(item);
            }
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
      }
    });
  }

  List<Widget> getItems() {
    List<Widget> items = [];
    if (tables.isNotEmpty) {
      for (var table in tables) {
        controllers[table] = TextEditingController();
        controllers[table]!.text = existingPermissions[table] ?? "0000";
        Widget item = PermissionCodeSelector(
          title: table.toString().replaceAll("_", " ").toUpperCase(),
          codeController: controllers[table]!,
        );
        items.add(item);
      }
    }
    return items;
  }

  void listenToRoleChange() async {
    String userRole = userRoleController.text;
    if (userRole.isEmpty || userRole == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomDialog(
            message: "Select User Role",
            title: "Errors",
          );
        },
      ).then((value) {
        setState(() {
          isRoleSelected = false;
        });
      });
    } else {
      setState(() {
        isRoleSelected = true;
        isLoadingData = true;
      });
      await Future.forEach([
        await getUserRoleAcces(userRoleController.text),
      ], (element) {
        setState(() {
          isLoadingData = false;
        });
      });
    }
  }

  Future<void> getUserRoleAcces(String userRole) async {
    existingPermissions = {};
    await appStore.userRoleAccessApp.list(userRole).then((response) {
      if (response.containsKey("error")) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              message: response["error"],
              title: "Errors",
            );
          },
        );
      } else {
        if (response["status"]) {
          for (var item in response["payload"]) {
            existingPermissions[item["table_name"]] = item["access_level"];
          }
        } else {
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
      }
    });
  }

  Widget createWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropDownWidget(
            disabled: false,
            hint: "Select User Role",
            controller: userRoleController,
            itemList: userRoles,
          ),
          isRoleSelected
              ? Column(
                  children: getItems(),
                )
              : Container(),
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
              "User Role Access Levels",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
