import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String table;
  final String accessType;
  final VoidCallback callback;
  const UserActionButton({
    Key? key,
    required this.accessType,
    required this.callback,
    required this.icon,
    required this.label,
    required this.table,
  }) : super(key: key);

  @override
  State<UserActionButton> createState() => _UserActionButtonState();
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

  dynamic listenToScanner(String data) {}

  @override
  Widget build(BuildContext context) {
    String qrImageData = '{"table":"' +
        widget.table +
        '", "action":"' +
        widget.label.toLowerCase() +
        '" }';
    return SizedBox(
      width: 200.0,
      height: 250.0,
      child: Tooltip(
        message: widget.label,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const LoadingWidget();
              },
            );
            //TODO User authorization check
            widget.callback();
          },
          // onTap: widget.callback,
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
                  QrImage(
                    data: qrImageData,
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
    );
  }
}
