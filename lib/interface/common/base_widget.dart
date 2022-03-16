import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:flutter/material.dart';

class BaseWidget extends StatelessWidget {
  final Widget Function(
          BuildContext context, ScreenSizeInformation screenSizeInformation)
      builder;
  const BaseWidget({Key? key, required this.builder}) : super(key: key);

  ScreenType getScreenType(MediaQueryData mediaQueryData) {
    var orientation = mediaQueryData.orientation;
    double deviceWidth = 0;
    if (orientation == Orientation.landscape) {
      deviceWidth = mediaQueryData.size.width;
    } else {
      deviceWidth = mediaQueryData.size.height;
    }
    if (deviceWidth > 1100) {
      return ScreenType.desktop;
    } else if (deviceWidth > 850) {
      return ScreenType.tablet;
    } else {
      return ScreenType.mobile;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(builder: (context, boxSixzing) {
      var screenSizeInformation = ScreenSizeInformation(
        orientation: mediaQuery.orientation,
        screenType: getScreenType(mediaQuery),
        screenSize: mediaQuery.size,
        localWidgetSize: Size(boxSixzing.maxWidth, boxSixzing.maxHeight),
      );
      return builder(context, screenSizeInformation);
    });
    // return builder(context, screenSizeInformation);
  }
}
