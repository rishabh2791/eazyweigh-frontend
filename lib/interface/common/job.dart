import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:eazyweigh/interface/common/screem_size_information.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class JobWidget extends StatelessWidget {
  final String jobID;
  final ScreenSizeInformation screenSizeInformation;
  const JobWidget({
    Key? key,
    required this.jobID,
    required this.screenSizeInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = '{"action": "selection","data": {"type": "job","id": "' + jobID + '"}}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QrImageView(
          data: data,
          size: screenSizeInformation.screenType == ScreenType.mobile ? screenSizeInformation.screenSize.height / 3 * 0.6 : screenSizeInformation.screenSize.width / 3 * 0.6,
        ),
        Text(
          jobID,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
