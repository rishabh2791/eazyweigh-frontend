import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class CompanyUpdatePage extends StatefulWidget {
  const CompanyUpdatePage({Key? key}) : super(key: key);

  @override
  State<CompanyUpdatePage> createState() => _CompanyUpdatePageState();
}

class _CompanyUpdatePageState extends State<CompanyUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(childWidget: loader(context));
  }
}
