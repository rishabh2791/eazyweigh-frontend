import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:flutter/material.dart';

class ScreenSizeInformation {
  final Orientation orientation;
  final ScreenType screenType;
  final Size screenSize;
  final Size localWidgetSize;

  ScreenSizeInformation({
    required this.orientation,
    required this.screenType,
    required this.screenSize,
    required this.localWidgetSize,
  });

  @override
  String toString() {
    // Implement toString method.
    return 'Orientation:$orientation DeviceScreenType:$screenType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}
