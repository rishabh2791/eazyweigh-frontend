import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

abstract class FilePickerEvents {
  const FilePickerEvents();
}

class FilePickerLoaded extends FilePickerEvents {}

class FilePicked extends FilePickerEvents {
  PlatformFile readPath;
  final TextEditingController controller;
  FilePicked(this.readPath, this.controller);
}
