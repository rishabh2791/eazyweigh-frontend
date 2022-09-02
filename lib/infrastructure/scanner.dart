import 'dart:async';

import 'package:eazyweigh/interface/common/time.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const String lineFeed = '\n';

ScannerListener scannerListener = ScannerListener();

class ScannerListener extends ChangeNotifier {
  List<String> _scannedChars = [];
  ObserverList<Function> listeners = ObserverList<Function>();
  DateTime _lastScannedCharCodeTime = DateTime.now();
  final _bufferDuration = const Duration(milliseconds: 1000);
  final _controller = StreamController<String>();

  static final ScannerListener _scannerListener = ScannerListener._internal();

  factory ScannerListener() {
    return _scannerListener;
  }

  ScannerListener._internal();

  barcodeListener() async {
    try {
      RawKeyboard.instance.addListener(_keyBoardCallback);
      // ignore: unnecessary_null_comparison
      _controller.stream.where((char) => char != null).listen(onKeyEvent);
    } catch (e) {
      // print(e.toString());
    }
  }

  void onKeyEvent(String char) {
    checkPendingCharCodesToClear();
    _lastScannedCharCodeTime = DateTime.now();
    if (char == lineFeed) {
      for (var listener in listeners) {
        listener(_scannedChars.join());
      }
      initializeTimer();
      resetScannedCharCodes();
    } else {
      _scannedChars.add(char);
    }
  }

  void checkPendingCharCodesToClear() {
    DateTime now = DateTime.now();
    if (_lastScannedCharCodeTime.isBefore(now.subtract(_bufferDuration))) {
      resetScannedCharCodes();
    }
  }

  void resetScannedCharCodes() {
    _lastScannedCharCodeTime = DateTime.now();
    _scannedChars = [];
  }

  void addScannedCharCode(String charCode) {
    _scannedChars.add(charCode);
  }

  void _keyBoardCallback(RawKeyEvent keyEvent) {
    if (keyEvent.logicalKey.keyId > 255 && keyEvent.data.logicalKey != LogicalKeyboardKey.enter) return;
    if (keyEvent is RawKeyUpEvent) {
      if (keyEvent.data is RawKeyEventDataAndroid) {
        _controller.sink.add(String.fromCharCode(((keyEvent.data) as RawKeyEventDataAndroid).codePoint));
      } else if (keyEvent.data is RawKeyEventDataFuchsia) {
        _controller.sink.add(String.fromCharCode(((keyEvent.data) as RawKeyEventDataFuchsia).codePoint));
      } else if (keyEvent.data.logicalKey == LogicalKeyboardKey.enter) {
        _controller.sink.add(lineFeed);
      } else if (keyEvent.data is RawKeyEventDataWeb) {
        _controller.sink.add(((keyEvent.data) as RawKeyEventDataWeb).keyLabel);
      } else if (keyEvent.data is RawKeyEventDataLinux) {
        _controller.sink.add(((keyEvent.data) as RawKeyEventDataLinux).keyLabel);
      } else if (keyEvent.data is RawKeyEventDataWindows) {
        _controller.sink.add(((keyEvent.data) as RawKeyEventDataWindows).keyLabel);
      } else if (keyEvent.data is RawKeyEventDataMacOs) {
        _controller.sink.add(((keyEvent.data) as RawKeyEventDataMacOs).keyLabel);
      } else if (keyEvent.data is RawKeyEventDataIos) {
        _controller.sink.add(((keyEvent.data) as RawKeyEventDataIos).keyLabel);
      } else {
        _controller.sink.add(keyEvent.character.toString());
      }
    }
  }

  @override
  void addListener(Function listener) {
    listeners.add(listener);
  }

  @override
  void removeListener(Function listener) {
    listeners.remove(listener);
  }
}
