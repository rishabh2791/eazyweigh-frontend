import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/loading_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool isLoading = true;
  late TextEditingController usernameController, passwordController;
  late BuildContext buildContext;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    scannerListener.addListener(listenToScanner);
    init();
    super.initState();
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    super.dispose();
  }

  void init() async {
    await Future.forEach([await parseStringToMap()], (element) => null)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> parseStringToMap({String assetsFileName = '.env'}) async {
    final lines = await rootBundle.loadString(assetsFileName);
    Map<String, String> environment = {};
    for (String line in lines.split('\n')) {
      line = line.trim();
      if (line.contains('=') //Set Key Value Pairs on lines separated by =
          &&
          !line.startsWith(RegExp(r'=|#'))) {
        //No need to add emty keys and remove comments
        List<String> contents = line.split('=');
        environment[contents[0]] = contents.sublist(1).join('=');
      }
    }
    baseURL = environment["baseURL"] ?? "http://10.19.1.211/backend/";
    WEBSOCKET_SERVER_HOST =
        environment["WEBSOCKET_SERVER_HOST"] ?? '10.19.0.210';
    PRINTER_HOST = environment["PRINTER_HOST"] ?? '10.19.0.210';
  }

  dynamic listenToScanner(String data) {
    Map<String, dynamic> scannerData = jsonDecode(data
        .replaceAll(";", ":")
        .replaceAll("[", "{")
        .replaceAll("]", "}")
        .replaceAll("'", "\""));
    handleLogin(buildContext, scannerData["username"], scannerData["password"]);
  }

  void handleLogin(BuildContext ctx, String username, String password) async {
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
        "username": username,
        "password": password
      };
      await appStore.authApp.login(loginDetails).then((response) async {
        Navigator.of(ctx, rootNavigator: true).pop('dialog');
        if (!response.containsKey("error")) {
          if (response["status"]) {
            showDialog(
              context: ctx,
              builder: (BuildContext context) {
                return const LoadingWidget();
              },
            );
            var payload = response["payload"];
            await storage!.setString("username", payload["Username"]);
            await storage!.setString("access_token", payload["AccessToken"]);
            await storage!.setString('refresh_token', payload["RefreshToken"]);
            await storage!.setInt("access_validity", payload["ATDuration"]);
            await storage!.setBool("logged_in", true);
            isLoggedIn = true;
            accessTokenExpiryTime = DateTime.now().add(
                Duration(seconds: int.parse(payload["ATDuration"].toString())));

            scannerListener.removeListener(listenToScanner);
            navigationService.pushReplacement(
              CupertinoPageRoute(
                builder: (BuildContext context) => HomePage(username: username),
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
            Future.delayed(const Duration(seconds: 3)).then((value) {
              Navigator.of(context).pop();
            });
          }
        } else {
          showDialog(
            context: ctx,
            builder: (BuildContext context) {
              return const CustomDialog(
                message: "Unable to Connect to Server.",
                title: "Error",
              );
            },
          );
          Future.delayed(const Duration(seconds: 3)).then((value) {
            Navigator.of(context).pop();
          });
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
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      backgroundColor: foregroundColor,
      body: isLoading
          ? loader(context)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                  const Text(
                    "Scan your Login Card.",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: backgroundColor,
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  const Text(
                    "or",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: backgroundColor,
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
