import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/interface/address_interface/address_widget.dart';
import 'package:eazyweigh/interface/bom_interface/bom_widget.dart';
import 'package:eazyweigh/interface/bom_item_interface/bom_item_widget.dart';
import 'package:eazyweigh/interface/company_interface/company_widget.dart';
import 'package:eazyweigh/interface/factory_interface/factory_widget.dart';
import 'package:eazyweigh/interface/home/home_page.dart';
import 'package:eazyweigh/interface/job_assignment_interface/job_assignment_widget.dart';
import 'package:eazyweigh/interface/job_interface/job_widget.dart';
import 'package:eazyweigh/interface/job_item_interface/job_item_widget.dart';
import 'package:eazyweigh/interface/material_interface/material_widget.dart';
import 'package:eazyweigh/interface/over_issue_interface/over_issue_widget.dart';
import 'package:eazyweigh/interface/shift_interface/shift_widget.dart';
import 'package:eazyweigh/interface/shift_schedule_interface/shift_schedule_widget.dart';
import 'package:eazyweigh/interface/terminal_interface/terminal_widget.dart';
import 'package:eazyweigh/interface/under_issue_interface/under_issue_widget.dart';
import 'package:eazyweigh/interface/unit_of_measure_conversion%20_interface/unit_of_measurement_conversion_widget.dart';
import 'package:eazyweigh/interface/unit_of_measurement_interface/unit_of_measurement_widget.dart';
import 'package:eazyweigh/interface/user_company_access_interface/user_company_access_widget.dart';
import 'package:eazyweigh/interface/user_factory_access_interface/user_factory_access_widget.dart';
import 'package:eazyweigh/interface/user_interface/user_widget.dart';
import 'package:eazyweigh/interface/user_role_access_interface/user_role_access_widget.dart';
import 'package:eazyweigh/interface/user_role_interface/user_role_widget.dart';
import 'package:eazyweigh/interface/user_terminal_access_interface/user_terminal_access_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

late User currentUser;

bool inSubMenu = false;
bool isLoggedIn = false;
bool isDarkTheme = true;
bool isRefreshing = false;
bool isLoadingServerData = false;
SharedPreferences? storage;
bool isMenuCollapsed = true;
String menuItemSelected = "Home";

Map<String, dynamic> menuWidgetMapping = {
  "Home": HomePage(username: currentUser.username),
  "Address": const AddressWidget(),
  "BOM": const BOMWidget(),
  "BOM Items": const BOMItemWidget(),
  "Company": const CompanyWidget(),
  "Factory": const FactoryWidget(),
  "Job": const JobWidget(),
  "Job Assignment": const JobAssignmentWidget(),
  "Job Item": const JobItemWidget(),
  "Material": const MaterialWidget(),
  "Over Issue": const OverIssueWidget(),
  "Shift": const ShiftWidget(),
  "Shift Schedule": const ShiftScheduleWidget(),
  "Terminals": const TerminalWidget(),
  "Under Issue": const UnderIssueWidget(),
  "Unit Of Measurement": const UnitOfMeasurementWidget(),
  "UOM Conversion": const UnitOfMeasurementConversionWidget(),
  "User": const UserWidget(),
  "User Roles": const UserRoleWidget(),
  "User Company Access": const UserCompanyAccessWidget(),
  "User Factory Access": const UserFactoryAccessWidget(),
  "User Role Access": const UserRoleAccessWidget(),
  "User Terminal Access": const UserTerminalAccessWidget(),
};
