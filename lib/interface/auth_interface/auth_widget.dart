import 'dart:convert';

import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/interface/auth_interface/login_widget.dart';
import 'package:eazyweigh/interface/auth_interface/registration_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool isLogin = false;
  bool isRegister = false;
  String loginMessage = '{"action": "login"}';
  String registerMessage = '{"action": "register"}';

  @override
  void initState() {
    scannerListener.addListener(listenToScanner);
    super.initState();
  }

  @override
  dispose() {
    isLogin = false;
    isRegister = false;
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

    switch (scannerData["action"]) {
      case "login":
        setState(() {
          isLogin = true;
        });
        break;
      case "register":
        setState(() {
          isRegister = true;
        });
        break;
      default:
    }
  }

  Widget commonWidget() {
    return Center(
      child: SizedBox(
        height: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                QrImage(
                  data: loginMessage,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = true;
                    });
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
            const VerticalDivider(
              color: Colors.white,
            ),
            Column(
              children: [
                QrImage(
                  data: registerMessage,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isRegister = true;
                    });
                  },
                  child: const Text(
                    "Register",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLogin
          ? const LoginWidget()
          : isRegister
              ? const RegistrationWidget()
              : commonWidget(),
    );
  }
}
