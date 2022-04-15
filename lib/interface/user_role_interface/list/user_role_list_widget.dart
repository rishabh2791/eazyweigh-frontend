import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/user_role.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/user_role_interface/list/user_role_list.dart';
import 'package:eazyweigh/interface/user_role_interface/user_role_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserRoleListWidget extends StatefulWidget {
  const UserRoleListWidget({Key? key}) : super(key: key);

  @override
  State<UserRoleListWidget> createState() => _UserRoleListWidgetState();
}

class _UserRoleListWidgetState extends State<UserRoleListWidget> {
  bool isLoadingPage = true;
  List<UserRole> userRoles = [];

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDetails() async {
    userRoles = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "company_id",
        "Value": companyID,
      }
    };
    await appStore.userRoleApp.list(conditions).then((response) {
      if (response.containsKey("status")) {
        if (response["status"]) {
          for (var item in response["payload"]) {
            UserRole userRole = UserRole.fromJSON(item);
            userRoles.add(userRole);
          }
          userRoles.sort((a, b) => a.role.compareTo(b.role));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(
                message: response["message"],
                title: "Error",
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomDialog(
              message: "Unable to Connect.",
              title: "Error",
            );
          },
        );
      }
      setState(() {
        isLoadingPage = false;
      });
    });
  }

  Widget homeWidget() {
    return SizedBox(
      width: 600,
      child: UserRoleList(userRoles: userRoles),
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
              homeWidget(),
              context,
              "User Roles",
              () {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => const UserRoleWidget(),
                  ),
                );
              },
            ),
          );
  }
}
