import 'package:eazyweigh/application/app_store.dart';
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

  ShiftSchedule._({
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
    return date.toString().substring(0, 10) + " - " + shift.description + " - " + weigher.username;
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

  static Future<ShiftSchedule> fromServer(Map<String, dynamic> jsonObject) async {
    late ShiftSchedule shiftSchedule;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.userApp.getUser(jsonObject["user_username"]).then((userResponse) async {
          await appStore.shiftApp.get(jsonObject["shift_id"]).then((shiftResponse) async {
            shiftSchedule = ShiftSchedule._(
              createdAt: DateTime.parse(jsonObject["created_at"]),
              createdBy: await User.fromServer(createdByResponse["payload"]),
              date: DateTime.parse(jsonObject["date"]),
              id: jsonObject["id"],
              shift: await Shift.fromServer(shiftResponse["payload"]),
              updatedAt: DateTime.parse(jsonObject["updated_at"]),
              updatedBy: await User.fromServer(updatedByResponse["payload"]),
              weigher: await User.fromServer(userResponse["payload"]),
            );
          });
        });
      });
    });

    return shiftSchedule;
  }
}
