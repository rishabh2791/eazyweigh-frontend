import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loading_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/home/home_page.dart';
import 'package:eazyweigh/interface/middlewares/refresh_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late TextEditingController usernameController, passwordController;
  late BuildContext buildContext;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    scannerListener.addListener(listenToScanner);
    super.initState();
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    super.dispose();
  }

  dynamic listenToScanner(String data) {
    Map<String, dynamic> scannerData = jsonDecode(data
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\"")
        .replaceAll("-", "_"));
    handleLogin(buildContext, scannerData["username"], scannerData["password"]);
  }

  void handleLogin(BuildContext ctx, String username, password) async {
    String errors = "";
    bool usernameValid = true;
    bool passwordValid = true;
    if (username.isEmpty) {
      usernameValid = false;
      errors += "Username Empty";
    }
    if (password.isEmpty) {
      errors += "\n Password Empty";
      passwordValid = false;
    } else if (password.length < 8) {
      errors += "\n Password Invalid";
      passwordValid = false;
    }
    if (usernameValid && passwordValid) {
      showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return const LoadingWidget();
        },
      );
      Map<String, String> loginDetails = {
        "username": usernameController.text,
        "password": passwordController.text
      };
      await appStore.authApp.login(loginDetails).then((response) async {
        Navigator.of(ctx, rootNavigator: true).pop('dialog');
        if (response["status"]) {
          showDialog(
              context: ctx,
              builder: (BuildContext context) {
                return const LoadingWidget();
              });
          var payload = response["payload"];
          await storage!.setString("username", payload["Username"]);
          await storage!.setString("access_token", payload["AccessToken"]);
          await storage!.setString('refresh_token', payload["RefreshToken"]);
          await storage!.setInt("access_validity", payload["ATDuration"]);
          await storage!.setBool("logged_in", true);
          isLoggedIn = true;
          refreshToken(payload["ATDuration"]);

          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (BuildContext context) => HomePage(
                username: username,
              ),
            ),
          );
        } else {
          showDialog(
            context: ctx,
            builder: (BuildContext context) {
              return CustomDialog(
                message: response["message"],
                title: "Error",
              );
            },
          );
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Error",
            message: errors,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Scan your Login Card.",
              style: TextStyle(
                fontSize: 30.0,
                color: foregroundColor,
              ),
            ),
            const Divider(
              color: Colors.transparent,
            ),
            const Text(
              "or",
              style: TextStyle(
                fontSize: 16.0,
                color: foregroundColor,
              ),
            ),
            const Divider(
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textField(false, usernameController, "Username", false),
                const VerticalDivider(color: Colors.white),
                textField(true, passwordController, "Password", false),
              ],
            ),
            const Divider(
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    var username = usernameController.text;
                    var password = passwordController.text;
                    handleLogin(buildContext, username, password);
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
