import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/domain/entity/user_role_access.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loading_widget.dart';
import 'package:eazyweigh/interface/home/general_home_page.dart';
import 'package:eazyweigh/interface/home/operator_home_page.dart';
import 'package:eazyweigh/interface/home/superuser_home_page.dart';
import 'package:eazyweigh/interface/process_interface/details/process_details_widget.dart';
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
    await appStore.userRoleAccessApp.list(currentUser.userRole.id).then((response) async {
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
          await Future.forEach(response["payload"], (dynamic item) async {
            UserRoleAccess userRoleAccess = await UserRoleAccess.fromServer(Map<String, dynamic>.from(item));
            userRolePermissions.add(userRoleAccess);
          });
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
        await Future.value(await User.fromServer(Map<String, dynamic>.from(response["payload"]))).then((user) async {
          currentUser = user;
        }).then((value) async {
          Map<String, dynamic> userCondition = {
            "EQUALS": {
              "Field": "user_username",
              "Value": currentUser.username,
            }
          };
          if (currentUser.userRole.role != "Superuser") {
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
                      builder: (BuildContext context) => const OperatorHomePage(),
                    ),
                  );
                  break;
                case "Processor":
                  menuItemSelected = "Process";
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (BuildContext context) => const ProcessDetailsWidget(),
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
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (BuildContext context) => const SuperUserHomePage(),
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
