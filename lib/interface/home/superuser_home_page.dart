import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/company_interface/create/create_widget.dart';
import 'package:eazyweigh/interface/company_interface/list/list_page.dart';
import 'package:eazyweigh/interface/user_interface/create/create_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuperUserHomePage extends StatefulWidget {
  const SuperUserHomePage({Key? key}) : super(key: key);

  @override
  State<SuperUserHomePage> createState() => _SuperUserHomePageState();
}

class _SuperUserHomePageState extends State<SuperUserHomePage> {
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
                  InkWell(
                    onTap: () {
                      navigationService.push(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const CompanyCreatePage(),
                        ),
                      );
                    },
                    child: Tooltip(
                      message: "Create Company",
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 230.0,
                          width: 180.0,
                          decoration: const BoxDecoration(
                            color: menuItemColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.create,
                                color: Colors.black,
                                size: 100.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  VerticalDivider(
                                    color: Colors.transparent,
                                  ),
                                  Text(
                                    "Create Company",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      navigationService.push(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const UserCreateWidget(),
                        ),
                      );
                    },
                    child: Tooltip(
                      message: "Create Superuser",
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 230.0,
                          width: 180.0,
                          decoration: const BoxDecoration(
                            color: menuItemColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.create,
                                color: Colors.black,
                                size: 100.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  VerticalDivider(
                                    color: Colors.transparent,
                                  ),
                                  Text(
                                    "Create Superuser",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      navigationService.push(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const CompanyListPage(),
                        ),
                      );
                    },
                    child: Tooltip(
                      message: "View Companies",
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 230.0,
                          width: 180.0,
                          decoration: const BoxDecoration(
                            color: menuItemColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.remove_red_eye,
                                color: Colors.black,
                                size: 100.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  VerticalDivider(
                                    color: Colors.transparent,
                                  ),
                                  Text(
                                    "View Companies",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Tooltip(
                      message: "View Superusers",
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 230.0,
                          width: 180.0,
                          decoration: const BoxDecoration(
                            color: menuItemColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.remove_red_eye,
                                color: Colors.black,
                                size: 100.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  VerticalDivider(
                                    color: Colors.transparent,
                                  ),
                                  Text(
                                    "View Superusers",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
