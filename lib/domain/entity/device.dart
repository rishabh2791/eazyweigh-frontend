import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/device_type.dart';
import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';

class Device {
  final String id;
  final Vessel vessel;
  final DeviceType deviceType;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;
  final String port;
  final bool isConstant;
  final double constantValue;
  final int factor;
  final int nodeAddress;
  final int additionalNodeAddress;
  final int readStart;
  final int baudRate;
  final int byteSize;
  final int stopBits;
  final double timeout;
  final bool enabled;
  final int messageLength;
  final bool clearBuffer;
  final bool closePort;
  final String communicationMethod;

  Device._({
    required this.createdAt,
    required this.createdBy,
    required this.deviceType,
    required this.id,
    required this.updatedAt,
    required this.updatedBy,
    required this.vessel,
    required this.nodeAddress,
    required this.additionalNodeAddress,
    required this.baudRate,
    required this.byteSize,
    required this.clearBuffer,
    required this.closePort,
    required this.enabled,
    required this.factor,
    required this.isConstant,
    required this.constantValue,
    required this.messageLength,
    required this.port,
    required this.readStart,
    required this.stopBits,
    required this.timeout,
    required this.communicationMethod,
  });

  @override
  String toString() {
    return vessel.name + " _ " + deviceType.description;
  }

  Map<String, dynamic> toJSON() {
    return {
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "device_type": deviceType.toJSON(),
      "id": id,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "vessel": vessel.toJSON(),
      "port": port,
      "is_constant": isConstant,
      "constant_value": constantValue,
      "factor": factor,
      "node_address": nodeAddress,
      "additional_node_address": additionalNodeAddress,
      "read_start": readStart,
      "baud_rate": baudRate,
      "byte_size": byteSize,
      "stop_bits": stopBits,
      "time_out": timeout,
      "enabled": enabled,
      "message_length": messageLength,
      "clear_buffers_before_each_transaction": clearBuffer,
      "close_port_after_each_call": closePort,
      "communication_method": communicationMethod,
    };
  }

  static Future<Device> fromServer(Map<String, dynamic> jsonObject) async {
    late Device device;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.vesselApp.getVessel(jsonObject["vessel_id"]).then((vesselResponse) async {
          await appStore.deviceTypeApp.getDevice(jsonObject["device_type_id"]).then((deviceTypeResponse) async {
            device = Device._(
              createdAt: DateTime.parse(jsonObject["created_at"]),
              createdBy: await User.fromServer(createdByResponse["payload"]),
              deviceType: await DeviceType.fromServer(deviceTypeResponse["payload"]),
              id: jsonObject["id"],
              updatedAt: DateTime.parse(jsonObject["updated_at"]),
              updatedBy: await User.fromServer(updatedByResponse["payload"]),
              vessel: await Vessel.fromServer(vesselResponse["payload"]),
              nodeAddress: jsonObject["node_address"],
              additionalNodeAddress: jsonObject["additional_node_address"],
              baudRate: int.parse(jsonObject["baud_rate"].toString()),
              byteSize: int.parse(jsonObject["byte_size"].toString()),
              clearBuffer: jsonObject["clear_buffers_before_each_transaction"],
              closePort: jsonObject["close_port_after_each_call"],
              enabled: jsonObject["enabled"],
              factor: int.parse(jsonObject["factor"].toString()),
              isConstant: jsonObject["is_constant"],
              constantValue: double.parse(jsonObject["constant_value"].toString()),
              messageLength: int.parse(jsonObject["message_length"].toString()),
              port: jsonObject["port"],
              readStart: int.parse(jsonObject["read_start"].toString()),
              stopBits: int.parse(jsonObject["stop_bits"].toString()),
              timeout: double.parse(jsonObject["time_out"].toString()),
              communicationMethod: jsonObject["communication_method"],
            );
          });
        });
      });
    });

    return device;
  }
}
