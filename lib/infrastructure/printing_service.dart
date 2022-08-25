import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  late WebSocketChannel webWebSocketChannel;
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
      if (kIsWeb) {
        webWebSocketChannel = WebSocketChannel.connect(Uri.parse(PRINTER_URL));
        webWebSocketChannel.sink.add(utf8.encode(zplString));
        webWebSocketChannel.stream.listen((event) {
          listenToWebSocket(event);
        });
        webWebSocketChannel.sink.close();
      } else {
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
      }
    } catch (e) {
      _isConnected = false;
      listenToWebSocket("{'status':'Not Done'}");
    }
  }

  Future<void> printVerificationLabel(Map<String, dynamic> data) async {
    String zplString = "^XA";
    zplString += "^FO10,10^GB792,386,3^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,30^FD Job Code: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,50^FD" + data["job_code"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,85^FD Verified By: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,105^FD" + data["verifier"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,140^FD Material Code: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,160^FD" + data["material_code"] + "^FS";
    zplString += "^CFA,15";
    zplString += "^FO30,195^FD Material Name: ^FS";
    zplString += "^CFA,30";
    zplString += "^FO50,215^FD" + data["material_description"] + "^FS";
    zplString += mapToZPLString(data) + "^XZ";

    try {
      if (kIsWeb) {
        webWebSocketChannel = WebSocketChannel.connect(Uri.parse(PRINTER_URL));
        webWebSocketChannel.sink.add(utf8.encode(zplString));
        webWebSocketChannel.stream.listen((event) {
          listenToWebSocket(event);
        });
        webWebSocketChannel.sink.close();
      } else {
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
      }
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
