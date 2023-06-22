// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/domain/entity/user_role_access.dart';
import 'package:eazyweigh/interface/address_interface/address_widget.dart';
import 'package:eazyweigh/interface/batch_run/batch_run_widget.dart';
import 'package:eazyweigh/interface/bom_interface/bom_widget.dart';
import 'package:eazyweigh/interface/company_interface/company_widget.dart';
import 'package:eazyweigh/interface/device_data_interface/device_data_widget.dart';
import 'package:eazyweigh/interface/device_interface/device_widget.dart';
import 'package:eazyweigh/interface/device_type_interface/device_type_widget.dart';
import 'package:eazyweigh/interface/factory_interface/factory_widget.dart';
import 'package:eazyweigh/interface/home/home_page.dart';
import 'package:eazyweigh/interface/job_assignment_interface/job_assignment_widget.dart';
import 'package:eazyweigh/interface/job_interface/job_widget.dart';
import 'package:eazyweigh/interface/material_interface/material_widget.dart';
import 'package:eazyweigh/interface/over_issue_interface/over_issue_widget.dart';
import 'package:eazyweigh/interface/process_interface/process_widget.dart';
import 'package:eazyweigh/interface/scanned_data/scanned_data_widget.dart';
import 'package:eazyweigh/interface/shift_interface/shift_widget.dart';
import 'package:eazyweigh/interface/shift_schedule_interface/shift_schedule_widget.dart';
import 'package:eazyweigh/interface/step_type_interface/step_type_widget.dart';
import 'package:eazyweigh/interface/terminal_interface/terminal_widget.dart';
import 'package:eazyweigh/interface/under_issue_interface/under_issue_widget.dart';
import 'package:eazyweigh/interface/unit_of_measure_conversion%20_interface/unit_of_measurement_conversion_widget.dart';
import 'package:eazyweigh/interface/unit_of_measurement_interface/unit_of_measurement_widget.dart';
import 'package:eazyweigh/interface/user_access/user_access_widget.dart';
import 'package:eazyweigh/interface/user_interface/user_widget.dart';
import 'package:eazyweigh/interface/user_role_interface/user_role_widget.dart';
import 'package:eazyweigh/interface/vessel_interface/vessel_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

late User currentUser;
List<UserRoleAccess> userRolePermissions = [];

String baseURL = "http://10.19.1.211/eazyweigh/";
String WEBSOCKET_SERVER_HOST = '10.19.0.210';
int WEBSOCKET_PORT = 8001;
String WEB_SOCKET_URL = 'ws://$WEBSOCKET_SERVER_HOST:$WEBSOCKET_PORT/';

String PRINTER_HOST = '10.19.1.89';
int PRINTER_PORT = 8002;
String PRINTER_URL = 'ws://$PRINTER_HOST:$PRINTER_PORT/';

bool inSubMenu = false;
bool isLoggedIn = false;
bool isRefreshing = false;
bool isLoadingServerData = false;
SharedPreferences? storage;
bool isMenuCollapsed = true;
String menuItemSelected = "Home";
String companyID = "";
String factoryID = "";
late DateTime accessTokenExpiryTime;
ValueNotifier themeChanged = ValueNotifier(true);
late Timer rootTimer;
int idleTimeout = 180;

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

Map<String, dynamic> menuWidgetMapping = {
  "Home": HomePage(username: currentUser.username),
  "Address": const AddressWidget(),
  "Batch Run": const BatchRunWidget(),
  "BOM": const BOMWidget(),
  "Company": const CompanyWidget(),
  "Device": const DeviceWidget(),
  "Device Data": const DeviceDataWidget(),
  "Device Type": const DeviceTypeWidget(),
  "Factory": const FactoryWidget(),
  "Job": const JobWidget(),
  "Job Assignment": const JobAssignmentWidget(),
  "Material": const MaterialWidget(),
  "Over Issue": const OverIssueWidget(),
  "Process": const ProcessWidget(),
  "Scanned Data": const ScannedDataWidget(),
  "Shift": const ShiftWidget(),
  "Shift Schedule": const ShiftScheduleWidget(),
  "Step Type": const StepTypeWidget(),
  "Terminals": const TerminalWidget(),
  "Under Issue": const UnderIssueWidget(),
  "Unit Of Measurement": const UnitOfMeasurementWidget(),
  "UOM Conversion": const UnitOfMeasurementConversionWidget(),
  "User": const UserWidget(),
  "User Roles": const UserRoleWidget(),
  "User Access": const UserAccessWidget(),
  "Vessel": const VesselWidget(),
};

Map<String, List<String>> menuTableMapping = {
  "Home": [],
  "Address": ["addresses"],
  "Batch Run": ["batch_runs"],
  "BOM": ["boms", "bom_items"],
  "Company": ["companies"],
  "Device": ["devices"],
  "Device Data": ["device_data"],
  "Device Type": ["device_types"],
  "Factory": ["factories"],
  "Job": ["jobs", "job_items", "job_item_weighings"],
  "Job Assignment": ["job_item_assignments"],
  "Material": ["materials"],
  "Over Issue": ["over_issues"],
  "Process": ["processes"],
  "Scanned Data": ["scanned_data"],
  "Shift": ["shifts"],
  "Shift Schedule": ["shift_schedules"],
  "Step Type": ["step_types"],
  "Terminals": ["terminals"],
  "Under Issue": ["under_issues"],
  "Unit Of Measurement": ["unit_of_measures"],
  "UOM Conversion": ["unit_of_measure_conversions"],
  "User": ["users", "user_companies", "user_factories"],
  "User Role": ["user_roles"],
  "User Access": [
    "user_role_accesses",
    "user_company_accesses",
    "user_factory_accesses",
    "user_terminal_accesses",
  ],
  "Vessel": ["vessels"],
};
