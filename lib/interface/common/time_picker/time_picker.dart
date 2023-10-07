import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TimePickerWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController dateController;
  final Map<String, DateTime> range;
  bool enabled;

  bool isValid;

  TimePickerWidget({
    Key? key,
    required this.dateController,
    required this.hintText,
    required this.labelText,
    this.isValid = true,
    this.enabled = true,
    this.range = const {},
  }) : super(key: key);

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(TextEditingController controller) async {
    TimeOfDay now = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: now);
    if (pickedTime != null && pickedTime != now) {
      setState(() {
        widget.dateController.text = pickedTime.toString();
      });
    }
  }

  Widget _dateWidget(ScreenSizeInformation sizeInfo, String labelText, hintText, TextEditingController controller) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
          width: sizeInfo.screenType == ScreenType.mobile ? sizeInfo.localWidgetSize.width - 20 : sizeInfo.localWidgetSize.width - 20,
          decoration: BoxDecoration(
            color: widget.isValid ? Colors.white : Colors.pink,
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 1,
                color: themeChanged.value ? foregroundColor : backgroundColor,
              ),
            ],
          ),
          child: TextFormField(
            enabled: widget.enabled,
            readOnly: true,
            obscureText: false,
            controller: controller,
            style: TextStyle(
              color: themeChanged.value ? backgroundColor : foregroundColor,
              fontWeight: FontWeight.bold,
            ),
            onTap: () async {
              _selectDate(widget.dateController);
            },
            decoration: InputDecoration(
              fillColor: themeChanged.value ? backgroundColor : foregroundColor,
              labelText: labelText,
              hintText: hintText,
              labelStyle: TextStyle(
                color: themeChanged.value ? backgroundColor : foregroundColor,
                fontWeight: FontWeight.bold,
              ),
              hintStyle: TextStyle(
                color: themeChanged.value ? backgroundColor : foregroundColor,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: themeChanged.value ? backgroundColor : foregroundColor,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.red,
                ),
              ),
              suffixIcon: Icon(
                Icons.calendar_view_month,
                color: themeChanged.value ? backgroundColor : foregroundColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizeInfo) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 400, minWidth: 300),
          child: BaseWidget(
            builder: (context, sizeInfo) {
              return _dateWidget(sizeInfo, widget.labelText, widget.hintText, widget.dateController);
            },
          ),
        );
      },
    );
  }
}
