import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

WebSocketUtility socketUtility = WebSocketUtility();

class WebSocketUtility {
  late IOWebSocketChannel _channel;
  bool _isConnected = false;
  int tries = 0;
  ObserverList<Function> listeners = ObserverList<Function>();
  static final WebSocketUtility socketUtility = WebSocketUtility._internal();

  factory WebSocketUtility() {
    return socketUtility;
  }

  WebSocketUtility._internal();

  initCommunication() async {
    try {
      _channel = IOWebSocketChannel.connect(WEB_SOCKET_URL);
      _isConnected = true;
      _channel.stream.listen(
        _onReceptionOfMessageFromServer,
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
            //TODO Logging service.
            print("Unable to Find Weighing Scale.");
          }
        },
      );
    } catch (ex) {
      //TODO logging service
    }
  }

  reset() {
    _channel.sink.close();
    _isConnected = false;
  }

  send(String message) {
    if (_isConnected) {
      _channel.sink.add(message);
    }
  }

  addListener(Function callback) {
    listeners.add(callback);
  }

  removeListener(Function callback) {
    listeners.remove(callback);
  }

  _onReceptionOfMessageFromServer(message) {
    _isConnected = true;
    for (var listener in listeners) {
      listener(message);
    }
  }
}
