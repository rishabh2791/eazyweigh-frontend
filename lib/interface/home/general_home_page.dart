import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:flutter/material.dart';

class GeneralHomeWidget extends StatefulWidget {
  const GeneralHomeWidget({Key? key}) : super(key: key);

  @override
  State<GeneralHomeWidget> createState() => _GeneralHomeWidgetState();
}

class _GeneralHomeWidgetState extends State<GeneralHomeWidget> {
  bool isLoadingPage = true;

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDetails() {
    setState(() {
      isLoadingPage = false;
    });
  }

  Widget homeWidget() {
    return ValueListenableBuilder(
      valueListenable: themeChanged,
      builder: (_, theme, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            20.0,
            50,
            20.0,
            50.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage("assets/img/wipro_logo.png"),
                    width: 200.0,
                    fit: BoxFit.scaleDown,
                  ),
                  Image(
                    image: AssetImage("assets/img/canway.png"),
                    width: 200.0,
                    fit: BoxFit.scaleDown,
                  ),
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: [
                  Text(
                    currentUser.firstName,
                    style: TextStyle(
                      color: themeChanged.value
                          ? foregroundColor
                          : backgroundColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingPage
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: homeWidget(),
          );
  }
}
