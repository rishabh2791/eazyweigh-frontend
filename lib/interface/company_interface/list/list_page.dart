import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({Key? key}) : super(key: key);

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(childWidget: loader(context));
  }
}
