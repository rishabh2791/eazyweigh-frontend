import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart'
    as menu;
import 'package:eazyweigh/interface/common/super_widget/super_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SuperPage extends StatefulWidget {
  final Widget childWidget;
  const SuperPage({Key? key, required this.childWidget}) : super(key: key);

  @override
  _SuperPageState createState() => _SuperPageState();
}

class _SuperPageState extends State<SuperPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;
  late ScrollController scrollController;
  late AnimationController animationController;
  String logout = '{"action":"logout"}';

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
    scaleAnimation =
        Tween<double>(begin: 1, end: 0.8).animate(animationController);
    slideAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(animationController);
  }

  @override
  void dispose() {
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeChanged,
      builder: (_, theme, child) {
        return BaseWidget(
          builder: (context, sizeInformation) {
            return Scaffold(
              backgroundColor:
                  themeChanged.value ? backgroundColor : foregroundColor,
              body: Stack(
                children: [
                  menu.SuperMenuWidget(
                    context: context,
                    slideAnimation: slideAnimation,
                    animationController: animationController,
                  ),
                  SuperPageWidget(
                    scaleAnimation: scaleAnimation,
                    childWidget: widget.childWidget,
                    screenType: sizeInformation.screenType,
                  ),
                  isLoggedIn
                      ? currentUser.userRole.role == "Operator" ||
                              currentUser.userRole.role == "Verifier"
                          ? Positioned(
                              left: 20,
                              bottom: 100,
                              child: Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      menu.logout(context);
                                    },
                                    child: QrImage(
                                      data: logout,
                                      size: 150.0,
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                ],
                              ),
                            )
                          : Container()
                      : Container(),
                  isLoggedIn
                      ? Positioned(
                          left: 20,
                          bottom: 20,
                          child: Row(
                            children: [
                              Tooltip(
                                message: themeChanged.value
                                    ? "Switch to Light Theme"
                                    : "Switch to Dark Theme",
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // themeChanged.value = !isDarkTheme;
                                      themeChanged.value = !themeChanged.value;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 10.0, 10.0, 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0)),
                                      color: themeChanged.value
                                          ? foregroundColor
                                          : backgroundColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 0),
                                          blurRadius: 5,
                                          color: shadowColor,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      themeChanged.value
                                          ? Icons.nightlight
                                          : Icons.nightlight_outlined,
                                      color: formHintTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isMenuCollapsed) {
                                      animationController.forward();
                                    } else {
                                      animationController.reverse();
                                    }
                                    isMenuCollapsed = !isMenuCollapsed;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 6.0, 20.0, 6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                    color: themeChanged.value
                                        ? foregroundColor
                                        : backgroundColor,
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 5,
                                        color: shadowColor,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    menuItemSelected
                                        .toUpperCase()
                                        .replaceAll("_", " "),
                                    style: TextStyle(
                                      color: themeChanged.value
                                          ? backgroundColor
                                          : foregroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
