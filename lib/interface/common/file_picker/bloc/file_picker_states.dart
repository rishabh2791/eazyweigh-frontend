import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

abstract class FilePickerStates {
  const FilePickerStates();
}

class FilePickerLoadedState extends FilePickerStates {}

class FilePickedState extends FilePickerStates {
  PlatformFile readPath;
  final TextEditingController controller;
  FilePickedState(this.readPath, this.controller);
}
