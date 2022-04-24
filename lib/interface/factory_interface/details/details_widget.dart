import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class FactoryDetailsWidget extends StatefulWidget {
  final Factory fact;
  const FactoryDetailsWidget({
    Key? key,
    required this.fact,
  }) : super(key: key);

  @override
  State<FactoryDetailsWidget> createState() => _FactoryDetailsWidgetState();
}

class _FactoryDetailsWidgetState extends State<FactoryDetailsWidget> {
  Widget detailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fact.name,
          style: const TextStyle(
            color: foregroundColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(
          color: Colors.transparent,
          height: 30.0,
        ),
        const Text(
          "Located At",
          style: TextStyle(
            color: foregroundColor,
          ),
        ),
        const Divider(
          color: Colors.transparent,
          height: 30.0,
        ),
        Text(
          widget.fact.address.line1,
          style: const TextStyle(
            color: foregroundColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(
          color: Colors.transparent,
          height: 10.0,
        ),
        Text(
          widget.fact.address.line2,
          style: const TextStyle(
            color: foregroundColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(
          color: Colors.transparent,
          height: 10.0,
        ),
        Text(
          widget.fact.address.city + " - " + widget.fact.address.zip.toString(),
          style: const TextStyle(
            color: foregroundColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(
          color: Colors.transparent,
          height: 10.0,
        ),
        Text(
          widget.fact.address.state + ", " + widget.fact.address.country,
          style: const TextStyle(
            color: foregroundColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        detailsWidget(),
        context,
        "Factory Details",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
