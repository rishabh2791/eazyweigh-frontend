import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/company_interface/create/create_widget.dart';
import 'package:eazyweigh/interface/company_interface/details/details_widget.dart';
import 'package:eazyweigh/interface/company_interface/list/list_page.dart';
import 'package:eazyweigh/interface/company_interface/update/update_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyWidget extends StatelessWidget {
  const CompanyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: BaseWidget(
        builder: (context, sizeInformation) {
          return SizedBox(
            height: sizeInformation.screenSize.height,
            width: sizeInformation.screenSize.width,
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const CompanyCreatePage(),
                        ),
                      );
                    },
                    icon: Icons.create,
                    label: "Create",
                    table: "companies",
                    accessType: "create",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const CompanyDetailsPage(),
                        ),
                      );
                    },
                    icon: Icons.get_app,
                    label: "Details",
                    table: "companies",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const CompanyListPage(),
                        ),
                      );
                    },
                    icon: Icons.list,
                    label: "List",
                    table: "companies",
                    accessType: "view",
                  ),
                  UserActionButton(
                    callback: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const CompanyUpdatePage(),
                        ),
                      );
                    },
                    icon: Icons.update,
                    label: "Update",
                    table: "companies",
                    accessType: "Update",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
