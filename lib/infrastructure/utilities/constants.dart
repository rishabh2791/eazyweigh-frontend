// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

String baseURL = "http://172.26.28.122:8000/";
const primaryColor = Color(0xFF2F2FA2);
const backgroundColor = Color(0xFF161B40);
const foregroundColor = Color(0xFFF9FAF4);
const shadowColor = Color(0x22000000);
const secondaryColor = Color(0xFFD2D2E9);
const bodyTextColor = Color(0xFF8B8B8D);
const formHintTextColor = Color(0xFFF17A7E);
const formLabelTextColor = Color(0xFFF17A7E);
const menuItemColor = Color(0xFF41B853);

const defaultPadding = 20.0;
const defaultDuration = Duration(seconds: 1);
const animationDuration = Duration(milliseconds: 200);
const maxWidth = 1440.0;
const shadowSpread = 5.0;
const shadowBlurRadius = 15.0;

const int accessTokenDuration = 10;

const tabletBreakPoint = 768.0;
const desktopBreakPoint = 1368.0;

const int defaultTimeOut = 7 * 24 * 60 * 60;

const int listPageSize = 25;

const WEBSOCKET_SERVER_HOST = '10.19.0.64';
const WEBSOCKET_PORT = 8010;
const WEB_SOCKET_URL = 'ws://$WEBSOCKET_SERVER_HOST:$WEBSOCKET_PORT/';

const Map<String, List<String>> menuItems = {
  "Home": [],
  "Address": [
    "Create",
    "Edit",
    "List",
  ],
  "BOM": [
    "Create",
    "Details",
    "Update",
  ],
  "Company": [
    "Create",
    "Details",
    "List",
    "Update",
  ],
  "Factory": [
    "Create",
    "Details",
    "List",
    "Update",
  ],
  "Job": [
    "Create",
    "Details",
    "List",
    "Update",
  ],
  "Job Assignment": [
    "Create",
    "Details",
    "Update",
  ],
  "Material": [
    "Create",
    "Details",
    "List",
    "Update",
  ],
  "Over Issue": [
    "Create",
    "List",
    "Update",
  ],
  "Shift": [
    "Create",
    "Details",
    "List",
  ],
  "Shift Schedule": [
    "Create",
    "Details",
    "List",
    "Update",
  ],
  "Terminals": [
    "Create",
    "Details",
    "List",
    "Update",
  ],
  "Under Issue": [
    "Create",
    "List",
    "Update",
  ],
  "Unit Of Measurement": [
    "Create",
    "Details",
    "List",
    "Update",
  ],
  "UOM Conversion": [
    "Create",
    "Details",
    "List",
  ],
  "User": [
    "Create",
    "Details",
    "List",
    "Update",
    "Activate",
    "Deactivate",
  ],
  "User Roles": [
    "Create",
    "Details",
    "List",
    "Update",
  ],
  "User Access": [
    "Role Access",
    "Factory Access",
    "Terminal Access",
  ],
};
