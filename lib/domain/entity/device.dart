import 'package:eazyweigh/domain/entity/device_data.dart';
import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';

class Device {
  final String id;
  final Vessel vessel;
  final String name;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;
  List<DeviceData> deviceData;

  Device({
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.updatedBy,
    required this.vessel,
    this.deviceData = const [],
  });

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toJSON() {
    return {
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "id": id,
      "name": name,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "vessel": vessel.toJSON(),
    };
  }

  factory Device.fromJSON(Map<String, dynamic> jsonObject) {
    List<DeviceData> deviceData = [];
    if (jsonObject["device_data"].isNotEmpty) {
      for (var data in jsonObject["device_data"]) {
        DeviceData thisDeviceData = DeviceData.fromJSON(data);
        deviceData.add(thisDeviceData);
      }
    }
    Device device = Device(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      id: jsonObject["id"],
      name: jsonObject["name"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      vessel: Vessel.fromJSON(jsonObject["vessel"]),
      deviceData: deviceData,
    );
    return device;
  }
}
