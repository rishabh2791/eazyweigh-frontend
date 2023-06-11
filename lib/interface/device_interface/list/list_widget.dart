import 'package:eazyweigh/domain/entity/device.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/device_interface/update/device_update_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeviceList extends StatefulWidget {
  final List<Device> devices;
  const DeviceList({
    Key? key,
    required this.devices,
  }) : super(key: key);

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  bool sort = true, ascending = true;
  int sortingColumnIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onSortColum(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        if (ascending) {
          widget.devices.sort((a, b) => a.vessel.fact.name.toString().compareTo(b.vessel.fact.name.toString()));
        } else {
          widget.devices.sort((a, b) => b.vessel.fact.name.toString().compareTo(a.vessel.fact.name.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.devices.sort((a, b) => a.vessel.name.toString().compareTo(b.vessel.name.toString()));
        } else {
          widget.devices.sort((a, b) => b.vessel.name.toString().compareTo(a.vessel.name.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.devices.sort((a, b) => (a.vessel.toString() + " _ " + a.deviceType.description).compareTo((b.vessel.toString() + " _ " + b.deviceType.description)));
        } else {
          widget.devices.sort((a, b) => (b.vessel.toString() + " _ " + b.deviceType.description).compareTo((a.vessel.toString() + " _ " + a.deviceType.description)));
        }
        break;
      default:
        break;
    }
  }

  Widget listDetailsWidget() {
    return BaseWidget(
      builder: (context, sizeInfo) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          width: sizeInfo.screenSize.width,
          height: sizeInfo.screenSize.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    cardColor: themeChanged.value ? backgroundColor : foregroundColor,
                    dividerColor: themeChanged.value ? foregroundColor.withOpacity(0.25) : backgroundColor.withOpacity(0.25),
                    textTheme: TextTheme(
                      bodySmall: TextStyle(
                        color: themeChanged.value ? foregroundColor : backgroundColor,
                      ),
                    ),
                  ),
                  child: ListView(
                    children: [
                      PaginatedDataTable(
                        showCheckboxColumn: false,
                        showFirstLastButtons: true,
                        sortAscending: sort,
                        sortColumnIndex: sortingColumnIndex,
                        columnSpacing: 20.0,
                        arrowHeadColor: themeChanged.value ? foregroundColor : backgroundColor,
                        columns: [
                          DataColumn(
                            label: Text(
                              "Factory",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: Text(
                              "Vessel",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: Text(
                              "Device Description",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: Text(
                              "Communication Method",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: Text(
                              "Port",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: Text(
                              "Node Address",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: Text(
                              "Additional Node Address",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: Text(
                              "Baud Rate",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: Text(
                              "Message Length",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortingColumnIndex = columnIndex;
                              });
                              onSortColum(columnIndex, ascending);
                            },
                          ),
                          // DataColumn(
                          //   label: Text(
                          //     " ",
                          //     style: TextStyle(
                          //       fontSize: 20.0,
                          //       color: themeChanged.value ? foregroundColor : backgroundColor,
                          //       fontWeight: FontWeight.bold,
                          //       fontStyle: FontStyle.italic,
                          //     ),
                          //   ),
                          //   onSort: (columnIndex, ascending) {
                          //     setState(() {
                          //       sort = !sort;
                          //       sortingColumnIndex = columnIndex;
                          //     });
                          //     onSortColum(columnIndex, ascending);
                          //   },
                          // ),
                        ],
                        source: _DataSource(context, widget.devices),
                        rowsPerPage: widget.devices.length > 25 ? 25 : widget.devices.length,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return listDetailsWidget();
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this._devices) {
    _devices = _devices;
  }

  final BuildContext context;
  List<Device> _devices;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final device = _devices[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            device.vessel.fact.name,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            device.vessel.name,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            (device.vessel.toString() + " - " + device.deviceType.description),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            device.communicationMethod,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            device.port,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            device.nodeAddress.toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            device.additionalNodeAddress.toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            device.baudRate.toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            device.messageLength.toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        // DataCell(
        //   UserActionButton(
        //     callback: () {
        //       Navigator.of(context).pushReplacement(
        //         CupertinoPageRoute(
        //           builder: (BuildContext context) => DeviceUpdateWidget(
        //             device: device,
        //           ),
        //         ),
        //       );
        //     },
        //     icon: Icons.update,
        //     label: "Update",
        //     table: "devices",
        //     accessType: "update",
        //     showQRCode: false,
        //   ),
        // )
      ],
    );
  }

  @override
  int get rowCount => _devices.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
