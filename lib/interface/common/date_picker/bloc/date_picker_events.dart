import 'package:flutter/cupertino.dart';

abstract class DatePickerEvents {
  const DatePickerEvents();
}

class DatePickerLoaded extends DatePickerEvents {}

class DatePicked extends DatePickerEvents {
  final DateTime pickedDate;
  final TextEditingController controller;
  DatePicked(this.pickedDate, this.controller);
}
