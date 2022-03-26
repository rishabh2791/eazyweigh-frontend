class Address {
  final String id;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String zip;
  final String country;
  final bool headOffice;
  final String companyID;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;

  Address({
    required this.city,
    required this.country,
    required this.createdAt,
    required this.createdBy,
    required this.headOffice,
    required this.id,
    required this.line1,
    required this.line2,
    required this.state,
    required this.companyID,
    required this.updatedAt,
    required this.updatedBy,
    required this.zip,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "city": city,
      "country": country,
      "created_at": createdAt,
      "created_by_username": createdBy,
      "head_office": headOffice,
      "id": id,
      "line1": line1,
      "line2": line2,
      "state": state,
      "company_id": companyID,
      "updated_at": updatedAt,
      "updated_by_username": updatedBy,
      "zip": zip,
    };
  }

  factory Address.fromJSON(Map<String, dynamic> jsonObject) {
    Address address = Address(
      city: jsonObject["city"],
      country: jsonObject["country"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: jsonObject["created_by_username"],
      headOffice: jsonObject["head_office"],
      id: jsonObject["id"],
      line1: jsonObject["line1"],
      line2: jsonObject["line2"],
      state: jsonObject["state"],
      companyID: jsonObject["company_id"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: jsonObject["updated_by_username"],
      zip: jsonObject["zip"],
    );
    return address;
  }
}
