import 'package:flutter/foundation.dart';

const String lineFeed = '\n';

PrintingService printingService = PrintingService();

class PrintingService extends ChangeNotifier {
  static final PrintingService _printingService = PrintingService._internal();

  factory PrintingService() {
    return _printingService;
  }

  int printJobSheet(Map<String, dynamic> data) {
    int done = 1;
    //TODO Printer settings
    return done;
  }

  int printJobItemLabel(Map<String, dynamic> data) {
    int done = 1;
    //TODO Printer settings
    return done;
  }

  PrintingService._internal();
}
