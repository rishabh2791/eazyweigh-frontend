class TrueFalse {
  final String id;
  final String description;

  TrueFalse({
    required this.id,
    required this.description,
  });

  @override
  String toString() {
    return description;
  }
}

List<TrueFalse> trueFalse = [
  TrueFalse(id: "True", description: "True"),
  TrueFalse(id: "False", description: "False"),
];
