class MaterialTypes {
  final String id;
  final String description;

  MaterialTypes({
    required this.description,
    required this.id,
  });

  @override
  String toString() {
    return description;
  }
}

List<MaterialTypes> materialTypes = [
  MaterialTypes(description: "Raw Material", id: "Raw Material"),
  MaterialTypes(description: "Bulk", id: "Bulk"),
];
