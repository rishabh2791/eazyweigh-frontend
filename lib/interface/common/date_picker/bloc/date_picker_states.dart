import 'package:flutter/material.dart';

abstract class DatePickerStates {
  const DatePickerStates();
}

class DatePickerLoadedState extends DatePickerStates {}

class DatePickedState extends DatePickerStates {
  final DateTime pickedDate;
  final TextEditingController controller;
  DatePickedState(this.pickedDate, this.controller);
}
