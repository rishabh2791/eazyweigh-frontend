import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PreviousWidget extends StatelessWidget {
  final bool isDisabled;
  final ScreenSizeInformation screenSizeInformation;
  const PreviousWidget({
    Key? key,
    required this.isDisabled,
    required this.screenSizeInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = '{"action": "navigation","data": {"type": "previous"}}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QrImage(
          data: data,
          foregroundColor: isDisabled ? Colors.white : Colors.black,
          size: screenSizeInformation.screenType == ScreenType.mobile
              ? screenSizeInformation.screenSize.height / 3 * 0.4
              : screenSizeInformation.screenSize.width / 3 * 0.4,
        ),
        Text(
          "Back",
          style: TextStyle(
            fontSize: 30,
            color: isDisabled ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
