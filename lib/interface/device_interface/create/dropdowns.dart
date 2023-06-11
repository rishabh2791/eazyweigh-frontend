class DropDownValues<T> {
  T id;
  T value;

  DropDownValues({
    required this.id,
    required this.value,
  });

  @override
  String toString() {
    return value.toString();
  }
}

List<DropDownValues<int>> baudRateValues = [
  DropDownValues(id: 1200, value: 1200),
  DropDownValues(id: 2400, value: 2400),
  DropDownValues(id: 4800, value: 4800),
  DropDownValues(id: 9600, value: 9600),
  DropDownValues(id: 19200, value: 19200),
  DropDownValues(id: 38400, value: 38400),
  DropDownValues(id: 57600, value: 57600),
  DropDownValues(id: 115200, value: 115200),
];

List<DropDownValues<int>> byteSizeValues = [
  DropDownValues(id: 7, value: 7),
  DropDownValues(id: 8, value: 8),
];

List<DropDownValues<int>> stopBitValues = [
  DropDownValues(id: 0, value: 0),
  DropDownValues(id: 1, value: 1),
  DropDownValues(id: 2, value: 2),
];

List<DropDownValues<String>> communicationMethods = [
  DropDownValues(id: "modbus", value: "modbus"),
  DropDownValues(id: "serial", value: "serial"),
  DropDownValues(id: "constant", value: "constant"),
];
