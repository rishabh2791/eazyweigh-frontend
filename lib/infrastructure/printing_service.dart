import 'dart:convert';
import 'dart:io';

import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/foundation.dart';

String mapToZPLString(Map<String, dynamic> data) {
  String zplString = "^FO420,30^BQN,2,4^FH^FDMA _7B";
  data.forEach((key, value) {
    zplString += "_22" + key.replaceAll("_", "_5F") + "_22_3A _22" + value.toString() + "_22,";
  });
  zplString = zplString.substring(0, zplString.length - 1);
  zplString += "_7D^FS";
  return zplString;
}

const String lineFeed = '\n';
PrintingService printingService = PrintingService();

class PrintingService extends ChangeNotifier {
  late WebSocket webSocketChannel;
  bool _isConnected = true;
  ObserverList<Function> listeners = ObserverList<Function>();
  static final PrintingService printingService = PrintingService._internal();

  factory PrintingService() {
    return printingService;
  }

  PrintingService._internal();

  @override
  addListener(Function listener) {
    listeners.add(listener);
  }

  @override
  removeListener(Function listener) {
    listeners.remove(listener);
    close();
  }

  close() async {
    try {
      if (_isConnected) {
        await webSocketChannel.close();
      }
    } catch (e) {
      FLog.error(text: e.toString());
    }
  }

  Future<void> printJobItemLabel(Map<String, dynamic> data) async {
    String zplString = "^XA";
    if (data.containsKey("complete")) {
      zplString += "^FO10,10^GB792,386,3^FS";
      data.remove("complete");
    }
    zplString += "^CFA,15";
    zplString += "^FO30,30^FD Job Code: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,50^FD" + data["job_code"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,85^FD Weight: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,105^FD" + data["weight"].toString() + " " + data["uom"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,140^FD Weighed By: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,160^FD" + data["weigher"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,195^FD Material Code: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,215^FD" + data["material_code"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,250^FD Batch: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,270^FD" + data["batch"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,305^FD Material Name: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,325^FD" + data["material_description"] + "^FS";
    zplString += mapToZPLString(data) + "^XZ";

    try {
      await WebSocket.connect(PRINTER_URL).then((webSocket) {
        if (webSocket.readyState == 1) {
          _isConnected = true;
          webSocketChannel = webSocket;
          webSocket.listen(listenToWebSocket);
          webSocket.add(utf8.encode(zplString));
        } else {
          _isConnected = false;
          listenToWebSocket("{'status':'Done'}");
        }
      });
    } catch (e) {
      _isConnected = false;
      listenToWebSocket("{'status':'Not Done'}");
    }
  }

  void listenToWebSocket(message) {
    for (var listener in listeners) {
      listener(message);
    }
  }
}


// ^XA

// ^FO10,10^GB792,386,3^FS

// ^CFA,15
// ^FO30,30^FD Job Code: ^FS
// ^CFA,30
// ^FO50,50^FD158543^FS
// ^CFA,15
// ^FO30,85^FD Weight: ^FS
// ^CFA,30
// ^FO50,105^FD10 KG^FS
// ^CFA,15
// ^FO30,140^FD Weighed By: ^FS
// ^CFA,30
// ^FO50,160^FDWeigher^FS
// ^CFA,15
// ^FO30,195^FD Material Code: ^FS
// ^CFA,30
// ^FO50,215^FD123456^FS
// ^CFA,15
// ^FO30,250^FD Batch: ^FS
// ^CFA,30";
// ^FO50,270^FD123456BA^FS
// ^CFA,15
// ^FO30,305^FD Material Name: ^FS
// ^CFA,30
// ^FO50,325^FDRaw Material 1^FS";

// ^FO420,30^BQN,2,4^FH^FDMA _7B_7D
// _22job_5Fcode_22_3A _22158543_22,
//           _22job_5Fid_22_3A _22abcd_22,
//           _22weigher_22_3A _22Rishabh Kumar_22,
//           _22material_5Fcode_22_3A _22123456_22,
//           _22material_5Fdescription_22_3A _22Raw Material 1_22,
//           _22weight_22_3A _2210_22,
//           _22uom_22_3A _22KG_22,
//           _22batch_22_3A _22123456BA_22,
//           _22job_5Fitem_5Fid_22_3A _22abcdefgh_22,
// ^FS

// ^XZ