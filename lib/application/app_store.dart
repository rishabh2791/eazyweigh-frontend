import 'package:eazyweigh/application/address_app.dart';
import 'package:eazyweigh/application/auth_app.dart';
import 'package:eazyweigh/application/bom_app.dart';
import 'package:eazyweigh/application/bom_item_app.dart';
import 'package:eazyweigh/application/company_app.dart';
import 'package:eazyweigh/application/factory_app.dart';
import 'package:eazyweigh/application/job_app.dart';
import 'package:eazyweigh/application/job_assignment_app.dart';
import 'package:eazyweigh/application/job_item_app.dart';
import 'package:eazyweigh/application/material_app.dart';
import 'package:eazyweigh/application/over_issue_app.dart';
import 'package:eazyweigh/application/scanned_data_app.dart';
import 'package:eazyweigh/application/shift_app.dart';
import 'package:eazyweigh/application/shift_schedule_app.dart';
import 'package:eazyweigh/application/terminal_app.dart';
import 'package:eazyweigh/application/under_issue_app.dart';
import 'package:eazyweigh/application/unit_of_measure_app.dart';
import 'package:eazyweigh/application/unit_of_measure_conversion_app.dart';
import 'package:eazyweigh/application/user_app.dart';
import 'package:eazyweigh/application/user_company_access_app.dart';
import 'package:eazyweigh/application/user_company_app.dart';
import 'package:eazyweigh/application/user_factory_access_app.dart';
import 'package:eazyweigh/application/user_factory_app.dart';
import 'package:eazyweigh/application/user_role_access_app.dart';
import 'package:eazyweigh/application/user_role_app.dart';
import 'package:eazyweigh/application/user_terminal_access_app.dart';
import 'package:eazyweigh/infrastructure/persistance/repo_store.dart';

AppStore appStore = AppStore();

class AppStore {
  final addressApp = AddressApp(addressRepository: repoStore.addressRepo);
  final authApp = AuthApp(authRepository: repoStore.authRepo);
  final bomApp = BOMApp(bomRepository: repoStore.bomRepo);
  final bomItemApp = BOMItemApp(bomItemRepository: repoStore.bomItemRepo);
  final companyApp = CompanyApp(companyRepository: repoStore.companyRepo);
  final factoryApp = FactoryApp(factoryRepository: repoStore.factoryRepo);
  final jobApp = JobApp(jobRepository: repoStore.jobRepo);
  final jobItemApp = JobItemApp(jobItemRepository: repoStore.jobItemRepo);
  final jobAssignmentApp =
      JobAssignmentApp(jobAssignmentRepository: repoStore.jobAssignmentRepo);
  final materialApp = MaterialApp(materialRepository: repoStore.materialRepo);
  final overIssueApp =
      OverIssueApp(overIssueRepository: repoStore.overIssueRepo);
  final shiftApp = ShiftApp(shiftRepository: repoStore.shiftRepo);
  final shiftScheduleApp =
      ShiftScheduleApp(shiftScheduleRepository: repoStore.shiftScheduleRepo);
  final scannedDataApp =
      ScannedDataApp(scannedDataRepository: repoStore.scannedDataRepo);
  final terminalApp = TerminalApp(terminalRepository: repoStore.terminalRepo);
  final underIssueApp =
      UnderIssueApp(underIssueRepository: repoStore.underIssueRepo);
  final unitOfMeasurementApp =
      UnitOfMeasurementApp(unitOfMeasurementRepository: repoStore.uomRepo);
  final unitOfMeasurementConversionApp = UnitOfMeasurementConversionApp(
      unitOfMeasurementConversionRepository: repoStore.uomConversionRepo);
  final userApp = UserApp(userRepository: repoStore.userRepo);
  final userRoleApp = UserRoleApp(userRoleRepository: repoStore.userRoleRepo);
  final userCompanyAccessApp = UserCompanyAccessApp(
      userCompanyAccessRepository: repoStore.userCompanyAccessRepo);
  final userFactoryAccessApp = UserFactoryAccessApp(
      userFactoryAccessRepository: repoStore.userFactoryAccessRepo);
  final userTerminalAccessApp = UserTerminalAccessApp(
      userTerminalAccessRepository: repoStore.userTerminalAccessRepo);
  final userRoleAccessApp =
      UserRoleAccessApp(userRoleAccessRepository: repoStore.userRoleAccessRepo);
  final userCompanyApp =
      UserCompanyApp(userCompanyRepository: repoStore.userCompanyRepo);
  final userFactoryApp =
      UserFactoryApp(userFactoryRepository: repoStore.userFactoryRepo);
}
