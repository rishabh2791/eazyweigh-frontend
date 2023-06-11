import 'package:eazyweigh/domain/entity/device_type.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:eazyweigh/interface/device_type_interface/update/device_update_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeviceTypeList extends StatefulWidget {
  final List<DeviceType> deviceTypes;
  const DeviceTypeList({
    Key? key,
    required this.deviceTypes,
  }) : super(key: key);

  @override
  State<DeviceTypeList> createState() => _DeviceTypeListState();
}

class _DeviceTypeListState extends State<DeviceTypeList> {
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
          widget.deviceTypes.sort((a, b) => a.fact.name.toString().compareTo(b.fact.name.toString()));
        } else {
          widget.deviceTypes.sort((a, b) => b.fact.name.toString().compareTo(a.fact.name.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.deviceTypes.sort((a, b) => a.description.toString().compareTo(b.description.toString()));
        } else {
          widget.deviceTypes.sort((a, b) => b.description.toString().compareTo(a.description.toString()));
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
                              "Device Type Description",
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
                              " ",
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
                        ],
                        source: _DataSource(context, widget.deviceTypes),
                        rowsPerPage: widget.deviceTypes.length > 25 ? 25 : widget.deviceTypes.length,
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
  _DataSource(this.context, this._deviceTypes) {
    _deviceTypes = _deviceTypes;
  }

  final BuildContext context;
  List<DeviceType> _deviceTypes;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final deviceType = _deviceTypes[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            deviceType.fact.name,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            deviceType.description,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          UserActionButton(
            callback: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (BuildContext context) => DeviceTypeUpdateWidget(
                    deviceType: deviceType,
                  ),
                ),
              );
            },
            icon: Icons.update,
            label: "Update",
            table: "device_types",
            accessType: "update",
            showQRCode: false,
          ),
        )
      ],
    );
  }

  @override
  int get rowCount => _deviceTypes.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
