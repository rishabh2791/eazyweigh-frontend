import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

WeightListener weightListener = WeightListener();

class WeightListener extends ChangeNotifier {
  String weighingScaleAddress = "/dev/ttyUSB0";
  late SerialPort weighingScalePort;
  late SerialPortReader weighingScaleReader;
  ObserverList<Function> listeners = ObserverList<Function>();
  static final WeightListener _weightListener = WeightListener._internal();

  factory WeightListener() {
    return _weightListener;
  }

  WeightListener._internal();

  initWeighingScale() async {
    final addresses = SerialPort.availablePorts;
    print(addresses);
    // for (var address in addresses) {
    //   if (address.contains("ttyUSB")) {
    //     final currentPort = SerialPort(address);
    //     if (currentPort.manufacturer == "FTDI") {
    //       weighingScaleAddress = address;
    //       weighingScalePort = currentPort;
    //     }
    //   }
    // }
    weighingScalePort = SerialPort(weighingScaleAddress);
    if (!weighingScalePort.openReadWrite() || !weighingScalePort.isOpen) {
      weighingScalePort.close();
    }
    weighingScalePort.open(mode: 1);
    weighingScaleReader = SerialPortReader(weighingScalePort);

    weighingScaleReader.stream.listen((data) {
      for (var listener in listeners) {
        listener(data.join());
      }
    });
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
