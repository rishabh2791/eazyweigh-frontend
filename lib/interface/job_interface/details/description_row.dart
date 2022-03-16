import 'package:flutter/material.dart';

class DescriptionRow extends StatelessWidget {
  final String item;
  final String description;
  const DescriptionRow({
    Key? key,
    required this.item,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
