import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/terminal_interface/terminal_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssignAsTerminal extends StatefulWidget {
  const AssignAsTerminal({Key? key}) : super(key: key);

  @override
  State<AssignAsTerminal> createState() => _AssignAsTerminalState();
}

class _AssignAsTerminalState extends State<AssignAsTerminal> {
  late TextEditingController apiKeyController;
  @override
  void initState() {
    apiKeyController = TextEditingController();
    super.initState();
  }

  Widget listWidget() {
    return Center(
      child: Row(children: [
        textField(
          false,
          apiKeyController,
          "API Key",
          false,
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
            elevation: MaterialStateProperty.all<double>(5.0),
          ),
          onPressed: () async {
            String apiKey = apiKeyController.text;
            if (apiKey.isEmpty || apiKey == "") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const CustomDialog(
                    message: "API Key Required.",
                    title: "Errors",
                  );
                },
              );
            } else {
              await Future.forEach(
                [await storage!.setString("api_key", apiKey)],
                (element) {
                  navigationService.pushReplacement(
                    CupertinoPageRoute(
                      builder: (BuildContext context) => const TerminalWidget(),
                    ),
                  );
                },
              );
            }
          },
          child: checkButton(),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        listWidget(),
        context,
        "All Job Items",
        () {
          navigationService.pushReplacement(
            CupertinoPageRoute(
              builder: (BuildContext context) => const TerminalWidget(),
            ),
          );
        },
      ),
    );
  }
}
