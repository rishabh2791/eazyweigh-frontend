import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/date_picker/bloc/date_picker_bloc.dart';
import 'package:eazyweigh/interface/common/date_picker/bloc/date_picker_events.dart';
import 'package:eazyweigh/interface/common/date_picker/bloc/date_picker_states.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatePickerWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController dateController;
  const DatePickerWidget({
    Key? key,
    required this.dateController,
    required this.hintText,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DatePickerBloc()..add(DatePickerLoaded()),
      child: DatePicker(
        labelText: labelText,
        hintText: hintText,
        dateController: dateController,
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController dateController;
  const DatePicker({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.dateController,
  }) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != currentDate) {
      dateBloc.add(DatePicked(pickedDate, controller));
    }
  }

  Widget _dateWidget(ScreenSizeInformation sizeInfo, String labelText, hintText, TextEditingController controller) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
          width: sizeInfo.screenType == ScreenType.mobile ? sizeInfo.localWidgetSize.width - 20 : sizeInfo.localWidgetSize.width - 20,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  color: shadowColor,
                ),
              ],
            ),
            child: TextFormField(
              readOnly: true,
              obscureText: false,
              controller: controller,
              style: const TextStyle(
                color: formLabelTextColor,
                fontWeight: FontWeight.bold,
              ),
              onTap: () async {
                _selectDate(widget.dateController);
              },
              decoration: InputDecoration(
                labelText: labelText,
                hintText: hintText,
                labelStyle: const TextStyle(
                  color: formLabelTextColor,
                ),
                hintStyle: const TextStyle(
                  color: formHintTextColor,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: secondaryColor,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: secondaryColor,
                  ),
                ),
                suffixIcon: const Icon(
                  Icons.calendar_view_month,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DatePickerBloc, DatePickerStates>(
      listener: (context, state) {
        if (state is DatePickedState) {}
      },
      builder: (context, state) {
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
