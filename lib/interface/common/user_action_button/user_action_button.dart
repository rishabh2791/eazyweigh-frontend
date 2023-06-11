import 'dart:convert';

import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String table;
  final String accessType;
  final VoidCallback callback;
  final bool showQRCode;
  const UserActionButton({
    Key? key,
    required this.accessType,
    required this.callback,
    required this.icon,
    required this.label,
    required this.table,
    this.showQRCode = true,
  }) : super(key: key);

  @override
  State<UserActionButton> createState() => _UserActionButtonState();
}

String getAccessCode(String tableName, String accessType) {
  String accessCode = "0000";
  for (var userPermission in userRolePermissions) {
    if (userPermission.tableName == tableName) {
      accessCode = userPermission.accessLevel;
    }
  }
  switch (accessType) {
    case "create":
      return accessCode[0];
    case "view":
      return accessCode[1];
    case "update":
      return accessCode[2];
    case "delete":
      return accessCode[3];
    default:
      break;
  }
  return "0";
}

class _UserActionButtonState extends State<UserActionButton> {
  Map<String, String> actionMapping = {
    "create": "create",
    "details": "view",
    "list": "view",
    "update": "update",
    "activate": "update",
    "deactivate": "update",
  };

  @override
  void initState() {
    scannerListener.addListener(listenToScanner);
    super.initState();
  }

  @override
  void dispose() {
    scannerListener.removeListener(listenToScanner);
    super.dispose();
  }

  dynamic listenToScanner(String data) {
    Map<String, dynamic> scannerData = jsonDecode(data.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
    switch (scannerData["action"]) {
      case "navigation":
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    String qrImageViewData = '{"action":"navigation", "table":"' + widget.table + '", "access_type":"' + widget.accessType + '" }';
    return widget.showQRCode
        ? SizedBox(
            width: 200.0,
            height: 250.0,
            child: Tooltip(
              message: widget.label,
              child: InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const LoadingWidget();
                    },
                  );
                  if (getAccessCode(widget.table, widget.accessType) == "1" || (currentUser.userRole.role == "Superuser" && widget.table == "companies")) {
                    widget.callback();
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 500),
                        backgroundColor: themeChanged.value ? foregroundColor : backgroundColor,
                        content: Center(
                          child: Text(
                            "You are not Authorized.",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: themeChanged.value ? backgroundColor : foregroundColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
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
                      children: [
                        QrImageView(
                          data: qrImageViewData,
                          size: 180,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.icon,
                              color: Colors.black,
                              size: 30.0,
                            ),
                            const VerticalDivider(
                              color: Colors.transparent,
                            ),
                            Text(
                              widget.label,
                              style: const TextStyle(
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
          )
        : TextButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const LoadingWidget();
                },
              );
              if (getAccessCode(widget.table, widget.accessType) == "1" || (currentUser.userRole.role == "Superuser" && widget.table == "companies")) {
                widget.callback();
              } else {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 500),
                    backgroundColor: themeChanged.value ? foregroundColor : backgroundColor,
                    content: Center(
                      child: Text(
                        "You are not Authorized.",
                        style: TextStyle(
                          fontSize: 30.0,
                          color: themeChanged.value ? backgroundColor : foregroundColor,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
            child: const Text(
              "Update",
              style: TextStyle(fontSize: 16.0, color: menuItemColor),
            ),
          );
  }
}
