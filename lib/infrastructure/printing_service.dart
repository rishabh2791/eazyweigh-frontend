import 'dart:convert';

import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

String mapToZPLString(Map<String, dynamic> data) {
  String zplString = "^FO490,30^BQN,2,4^FH^FDMA _7B";
  data.forEach((key, value) {
    zplString += "_22" +
        key.replaceAll("_", "_5F") +
        "_22_3A _22" +
        value.toString() +
        "_22,";
  });
  zplString = zplString.substring(0, zplString.length - 1);
  zplString += "_7D^FS";
  return zplString;
}

const String lineFeed = '\n';
PrintingService printingService = PrintingService();

class PrintingService extends ChangeNotifier {
  late WebSocketChannel _printingChannel;
  bool _isConnected = false;
  int tries = 0;
  ObserverList<Function> listeners = ObserverList<Function>();
  static final PrintingService printingService = PrintingService._internal();

  factory PrintingService() {
    return printingService;
  }

  PrintingService._internal();

  initCommunication() async {
    try {
      _printingChannel = WebSocketChannel.connect(Uri.parse(PRINTER_URL));
      _isConnected = true;
      _printingChannel.stream.listen(
        (event) {
          _onReceptionOfMessageFromServer(event);
        },
        onDone: () async {
          if (_isConnected) {
            await initCommunication();
          }
        },
        onError: (error) async {
          tries += 1;
          if (tries < 10) {
            await initCommunication();
          } else {
            FLog.error(
                text:
                    "Unable to Connect to Printer. Too Many Attempts to Connect.");
          }
        },
      );
    } catch (ex) {
      FLog.error(text: "Unable to Connect to Printer");
    }
  }

  reset() {
    _printingChannel.sink.close();
    _isConnected = false;
  }

  send(String message) {
    if (_isConnected) {
      _printingChannel.sink.add(utf8.encode(message));
    }
  }

  @override
  addListener(Function listener) {
    listeners.add(listener);
  }

  @override
  removeListener(Function listener) {
    listeners.remove(listener);
  }

  int printJobSheet(Map<String, dynamic> data) {
    int done = 1;
    String zplString = mapToZPLString(data);
    send(zplString);
    return done;
  }

  Map<String, dynamic> printingData = {
    "job_code": "153847",
    "job_id": "a2a41b82-a6a9-4e2f-966c-550675ae7fcf",
    "weigher": "Operator First",
    "material_code": "110196",
    "material_description": "LIPO EGMS/ SP CITHROL EGMS MB",
    "weight": 0.8,
    "job_item_id": "b476e722-5eb5-4aa1-9f85-e4825bb69676",
  };

  Map<String, dynamic> printingOverIssueData = {
    "job_id": "a2a41b82-a6a9-4e2f-966c-550675ae7fcf",
    "weigher": "Operator First",
    "material_code": "110023",
    "material_description": "Stearic Acid",
    "weight": 0.25,
    "job_item_id": "56221f29-21d4-41cf-9ee9-ae487a1c5c60",
    "under_issue_id": "a129f4ec-a7be-47d8-87d5-46f70cbe2d7f",
  };

  Future<int> printJobItemLabel(Map<String, dynamic> data) async {
    int done = 1;
    String zplString = "^XA";
    zplString += "^CFA,15";
    zplString += "^FO30,30^FD Job Code: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,60^FD" + data["job_code"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,105^FD Weight: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,135^FD" + data["weight"].toString() + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,180^FD Weighed By: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,200^FD" + data["weigher"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,255^FD Material Code: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,285^FD" + data["material_code"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,325^FD Material Name: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,355^FD" + data["material_description"] + "^FS";
    zplString += mapToZPLString(printingData) + "^XZ";
    send(zplString);
    return done;
  }

  _onReceptionOfMessageFromServer(message) {
    _isConnected = true;
    for (var listener in listeners) {
      listener(message);
    }
  }
}
