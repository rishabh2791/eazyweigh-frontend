import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/file_picker/bloc/file_picker_bloc.dart';
import 'package:eazyweigh/interface/common/file_picker/bloc/file_picker_events.dart';
import 'package:eazyweigh/interface/common/file_picker/bloc/file_picker_states.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class FilePickerer extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final Function(FilePickerResult? result) updateParent;
  List<String> allowedExtensions;
  FilePickerer({
    Key? key,
    required this.controller,
    required this.hint,
    required this.label,
    required this.updateParent,
    this.allowedExtensions = const ['csv', 'xlsx'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          FilePickerBloc()..add(FilePickerLoaded()),
      child: FilePickerWidget(
        label: label,
        hint: hint,
        updateParent: updateParent,
        controller: controller,
        allowedExtensions: allowedExtensions,
      ),
    );
  }
}

// ignore: must_be_immutable
class FilePickerWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint;
  final Function(FilePickerResult? result) updateParent;
  List<String> allowedExtensions;
  FilePickerWidget({
    Key? key,
    required this.controller,
    required this.hint,
    required this.label,
    required this.updateParent,
    this.allowedExtensions = const ['csv', 'xlsx'],
  }) : super(key: key);

  @override
  _FilePickerWidgetState createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget filePickerField(ScreenSizeInformation sizeInfo, String labelText,
      hintText, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
      width: sizeInfo.screenType == ScreenType.mobile
          ? sizeInfo.localWidgetSize.width
          : sizeInfo.localWidgetSize.width,
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
          controller: widget.controller,
          style: const TextStyle(color: formLabelTextColor),
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: widget.allowedExtensions,
            );

            if (result != null) {
              widget.updateParent(result);
            } else {}
          },
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
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
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilePickerBloc, FilePickerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 400, minWidth: 300),
          child: BaseWidget(
            builder: (context, size) {
              return filePickerField(
                  size, widget.label, widget.hint, widget.controller);
            },
          ),
        );
      },
    );
  }
}
