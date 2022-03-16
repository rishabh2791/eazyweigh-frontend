import 'package:eazyweigh/interface/common/job.dart';
import 'package:eazyweigh/interface/common/next.dart';
import 'package:eazyweigh/interface/common/previous.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:flutter/material.dart';

List<Widget> widgetStack(
  ScreenSizeInformation sizeInformation,
  String jobID,
  bool previousDisabled,
  bool nextDisabled,
) {
  return [
    PreviousWidget(
      isDisabled: previousDisabled,
      screenSizeInformation: sizeInformation,
    ),
    JobWidget(jobID: jobID, screenSizeInformation: sizeInformation),
    NextWidget(
      isDisabled: nextDisabled,
      screenSizeInformation: sizeInformation,
    ),
  ];
}
