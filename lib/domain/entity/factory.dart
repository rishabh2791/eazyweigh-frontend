import 'package:eazyweigh/domain/entity/address.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Factory {
  final String companyID;
  final Address address;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  Factory({
    required this.address,
    required this.companyID,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "address": address.toJSON(),
      "company_id": companyID,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  factory Factory.fromJSON(Map<String, dynamic> jsonObject) {
    Factory fact = Factory(
      address: Address.fromJSON(jsonObject["address"]),
      companyID: jsonObject["company_id"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    return fact;
  }
}
