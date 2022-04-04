import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loading_widget.dart';
import 'package:eazyweigh/interface/home/general_home_page.dart';
import 'package:eazyweigh/interface/job_interface/list/job_list_widget.dart';
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
    getUserDetails();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          if (currentUser.userRole.role == "Operator") {
            menuItemSelected = "Job";
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (BuildContext context) => const JobListWidget(),
              ),
            );
          } else {
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
