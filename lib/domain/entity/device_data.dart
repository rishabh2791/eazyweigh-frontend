import 'package:eazyweigh/domain/entity/user.dart';

class DeviceData {
  final String id;
  final String deviceID;
  final double value;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  DeviceData({
    required this.createdAt,
    required this.createdBy,
    required this.deviceID,
    required this.id,
    required this.updatedAt,
    required this.updatedBy,
    this.value = 0,
  });

  @override
  String toString() {
    return id;
  }

  Map<String, dynamic> toJSON() {
    return {
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "device_id": deviceID,
      "id": id,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "value": value,
    };
  }

  factory DeviceData.fromJSON(Map<String, dynamic> jsonObject) {
    DeviceData deviceData = DeviceData(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      deviceID: jsonObject["device_id"],
      id: jsonObject["id"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      value: jsonObject["value"],
    );
    return deviceData;
  }
}
