import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  final bool disabled;
  final String hint;
  final String initialValue;
  final List<dynamic> itemList;
  final TextEditingController controller;
  const DropDownWidget({
    Key? key,
    required this.disabled,
    required this.hint,
    this.initialValue = "",
    required this.controller,
    required this.itemList,
  }) : super(key: key);

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  late String _chosenValue;

  List<DropdownMenuItem<String>> getMenuItems(List<dynamic> items) {
    _chosenValue = "";
    List<DropdownMenuItem<String>> menuItem = [
      DropdownMenuItem<String>(
        value: "",
        child: Text(
          widget.hint,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: formHintTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    ];
    for (var item in items) {
      DropdownMenuItem<String> newItem = DropdownMenuItem<String>(
        value: item is User ? item.username : item.id,
        child: Text(
          item.toString(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: formHintTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      menuItem.add(newItem);
    }
    return menuItem;
  }

  @override
  void initState() {
    _chosenValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, size) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 400, minWidth: 300),
          width: size.screenType == ScreenType.mobile ? size.screenSize.width * 0.8 : size.screenSize.width * .3,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: secondaryColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  color: shadowColor,
                ),
              ],
            ),
            height: 54.0,
            child: DropdownButton<String>(
              value: _chosenValue,
              isExpanded: true,
              elevation: 10,
              icon: Container(),
              dropdownColor: foregroundColor,
              menuMaxHeight: 300.0,
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              focusColor: Colors.white,
              items: getMenuItems(widget.itemList),
              underline: Container(),
              onChanged: (value) {
                setState(() {
                  _chosenValue = value.toString();
                  widget.controller.text = value.toString();
                });
              },
              hint: Text(
                widget.hint,
                style: const TextStyle(
                  color: formHintTextColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
