import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/domain/entity/user_role_access.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loading_widget.dart';
import 'package:eazyweigh/interface/home/general_home_page.dart';
import 'package:eazyweigh/interface/home/operator_home_page.dart';
import 'package:eazyweigh/interface/home/verifier_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getAllDetails();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAllDetails() async {
    await Future.forEach([
      await getUserDetails(),
    ], (element) {})
        .then((value) async {
      await Future.forEach([
        await getUserAuthorizations(),
      ], (element) {});
    });
  }

  Future<void> getUserAuthorizations() async {
    userRolePermissions = [];
    await appStore.userRoleAccessApp
        .list(currentUser.userRole.role)
        .then((response) {
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
            UserRoleAccess userRoleAccess = UserRoleAccess.fromJSON(item);
            userRolePermissions.add(userRoleAccess);
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

  Future<dynamic> getUserDetails() async {
    await appStore.userApp.getUser(widget.username).then((response) async {
      if (response["status"] && response.containsKey("payload")) {
        currentUser = User.fromJSON(response["payload"]);
        Map<String, dynamic> userCondition = {
          "user_username": currentUser.username
        };
        await appStore.userCompanyApp.get(userCondition).then((value) async {
          companyID = value["payload"][0]["company_id"];
          switch (currentUser.userRole.role) {
            case "Operator":
              menuItemSelected = "Job";
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (BuildContext context) => const OperatorHomePage(),
                ),
              );
              break;
            case "Verifier":
              menuItemSelected = "Job";
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (BuildContext context) => const VerifierHomePage(),
                ),
              );
              break;
            default:
              menuItemSelected = "Home";
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (BuildContext context) => const GeneralHomeWidget(),
                ),
              );
          }
        });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: LoadingWidget(),
    );
  }
}
