import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/auth_interface/login_widget.dart';
import 'package:eazyweigh/interface/middlewares/refresh_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuperMenuWidget extends StatefulWidget {
  final BuildContext context;
  final Animation<Offset> slideAnimation;
  final AnimationController animationController;
  const SuperMenuWidget(
      {Key? key,
      required this.context,
      required this.animationController,
      required this.slideAnimation})
      : super(key: key);

  @override
  State<SuperMenuWidget> createState() => _SuperMenuWidgetState();
}

class _SuperMenuWidgetState extends State<SuperMenuWidget> {
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  List<Widget> getMenuItems() {
    List<Widget> widgets = [];
    menuItems.forEach((key, value) {
      widgets.add(
        InkWell(
          onTap: () {
            widget.animationController.reverse();
            menuItemSelected = key;
            isMenuCollapsed = true;
            Navigator.of(widget.context).pushAndRemoveUntil(
              CupertinoPageRoute(
                  builder: (BuildContext context) =>
                      menuWidgetMapping[menuItemSelected]),
              (route) => false,
            );
          },
          child: Text(
            key.toUpperCase().replaceAll("_", " "),
            style: TextStyle(
              color: menuItemSelected == key
                  ? menuItemColor
                  : menuItemColor.withOpacity(0.5),
              fontSize: 20.0,
              fontWeight:
                  menuItemSelected == key ? FontWeight.bold : FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
      widgets.add(const SizedBox(
        height: 10.0,
      ));
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  isLoggedIn
                      ? Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            currentUser.firstName + " " + currentUser.lastName,
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: formHintTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(),
                  isLoggedIn
                      ? Text(
                          "@" + currentUser.username,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: formHintTextColor.withOpacity(0.6),
                          ),
                        )
                      : Container(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: getMenuItems(),
                    ),
                  ),
                  isLoggedIn
                      ? TextButton(
                          onPressed: () async {
                            Map<String, String> headers = {
                              "Authorization": "AccessToken " +
                                  (storage?.getString("access_token"))
                                      .toString(),
                            };
                            await appStore.authApp
                                .logout(headers)
                                .then((value) async => await storage?.clear())
                                .then((value) {
                              isLoggedIn = false;
                              isMenuCollapsed = true;
                            }).then((value) {
                              refreshToken(0);
                              menuItemSelected = "Home";
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginWidget(),
                                ),
                              );
                            });
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: formHintTextColor,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
