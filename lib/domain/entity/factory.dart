import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/address.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Factory {
  final String id;
  final String name;
  final String companyID;
  final Address address;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  Factory._({
    required this.id,
    required this.name,
    required this.address,
    required this.companyID,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  bool selected = false;

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "address": address.toJSON(),
      "company_id": companyID,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  static Future<Factory> fromServer(Map<String, dynamic> jsonObject) async {
    late Factory fact;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        Map<String, dynamic> conditions = {
          "EQUALS": {
            "Field": "id",
            "Value": jsonObject["address_id"],
          }
        };
        await appStore.addressApp.list(conditions).then((addressResponse) async {
          fact = Factory._(
            id: jsonObject["id"],
            name: jsonObject["name"],
            address: await Address.fromServer(addressResponse["payload"][0]),
            companyID: jsonObject["company_id"],
            createdAt: DateTime.parse(jsonObject["created_at"]),
            createdBy: await User.fromServer(createdByResponse["payload"]),
            updatedAt: DateTime.parse(jsonObject["updated_at"]),
            updatedBy: await User.fromServer(updatedByResponse["payload"]),
          );
        });
      });
    });

    return fact;
  }
}
