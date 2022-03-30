import 'package:eazyweigh/domain/entity/shift.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class ShiftSchedule {
  final String id;
  final DateTime date;
  final Shift shift;
  final User weigher;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  ShiftSchedule({
    required this.createdAt,
    required this.createdBy,
    required this.date,
    required this.id,
    required this.shift,
    required this.updatedAt,
    required this.updatedBy,
    required this.weigher,
  });

  @override
  String toString() {
    return date.toString().substring(0, 10) +
        " - " +
        shift.description +
        " - " +
        weigher.username;
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "date": date,
      "id": id,
      "shift": shift.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "user": weigher
    };
  }

  factory ShiftSchedule.fromJSON(Map<String, dynamic> jsonObject) {
    ShiftSchedule shiftSchedule = ShiftSchedule(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      date: DateTime.parse(jsonObject["date"]),
      id: jsonObject["id"],
      shift: Shift.fromJSON(jsonObject["shift"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      weigher: User.fromJSON(jsonObject["user"]),
    );
    return shiftSchedule;
  }
}
