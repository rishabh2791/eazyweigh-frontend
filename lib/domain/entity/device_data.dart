class DeviceData {
  final String id;
  final String deviceID;
  final double value;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeviceData._({
    required this.createdAt,
    required this.deviceID,
    required this.id,
    required this.updatedAt,
    this.value = 0,
  });

  @override
  String toString() {
    return id;
  }

  Map<String, dynamic> toJSON() {
    return {
      "created_at": createdAt,
      "device_id": deviceID,
      "id": id,
      "updated_at": updatedAt,
      "value": value,
    };
  }

  static Future<DeviceData> fromServer(Map<String, dynamic> jsonObject) async {
    return DeviceData._(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      deviceID: jsonObject["device_id"],
      id: jsonObject["id"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      value: jsonObject["value"],
    );
  }
}
