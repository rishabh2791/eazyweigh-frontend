import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/scanned_data.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class ScannedDataList extends StatefulWidget {
  final List<ScannedData> scannedData;
  final List<Mat> materials;
  const ScannedDataList({
    Key? key,
    required this.scannedData,
    required this.materials,
  }) : super(key: key);

  @override
  State<ScannedDataList> createState() => _ScannedDataListState();
}

class _ScannedDataListState extends State<ScannedDataList> {
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
          widget.scannedData.sort((a, b) => a.createdAt.toString().substring(0, 10).compareTo(b.createdAt.toString().substring(0, 10)));
        } else {
          widget.scannedData.sort((a, b) => b.createdAt.toString().substring(0, 10).compareTo(a.createdAt.toString().substring(0, 10)));
        }
        break;
      case 1:
        if (ascending) {
          widget.scannedData.sort((a, b) => a.createdAt.toString().substring(11, 16).compareTo(b.createdAt.toString().substring(11, 16)));
        } else {
          widget.scannedData.sort((a, b) => b.createdAt.toString().substring(11, 16).compareTo(a.createdAt.toString().substring(11, 16)));
        }
        break;
      case 2:
        if (ascending) {
          widget.scannedData.sort((a, b) => a.expectedCode.toString().compareTo(b.expectedCode.toString()));
        } else {
          widget.scannedData.sort((a, b) => b.expectedCode.toString().compareTo(a.expectedCode.toString()));
        }
        break;
      case 3:
        if (ascending) {
          widget.scannedData.sort((a, b) => a.actualCode.toString().compareTo(b.actualCode.toString()));
        } else {
          widget.scannedData.sort((a, b) => b.actualCode.toString().compareTo(a.actualCode.toString()));
        }
        break;
      case 4:
        if (ascending) {
          widget.scannedData.sort((a, b) => a.terminal.description.toString().compareTo(b.terminal.description.toString()));
        } else {
          widget.scannedData.sort((a, b) => b.terminal.description.toString().compareTo(a.terminal.description.toString()));
        }
        break;
      case 5:
        if (ascending) {
          widget.scannedData.sort((a, b) => a.job.jobCode.toString().compareTo(b.job.jobCode.toString()));
        } else {
          widget.scannedData.sort((a, b) => b.job.jobCode.toString().compareTo(a.job.jobCode.toString()));
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
                      caption: TextStyle(
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
                        columns: [
                          DataColumn(
                            label: Text(
                              "Date",
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
                              "Time",
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
                              "Job Code",
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
                              "Terminal",
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
                              "Expected Data",
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
                              "Actual Data",
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
                        source: _DataSource(context, widget.scannedData, widget.materials),
                        rowsPerPage: widget.scannedData.length > 25 ? 25 : widget.scannedData.length,
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
  _DataSource(this.context, this._scannedData, this._materials) {
    _scannedData = _scannedData;
    _materials = _materials;
  }

  final BuildContext context;
  List<ScannedData> _scannedData;
  List<Mat> _materials;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final scannedData = _scannedData[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            scannedData.createdAt.toLocal().toString().substring(0, 10),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            scannedData.createdAt.toLocal().toString().substring(11, 16),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            scannedData.job.jobCode,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            scannedData.terminal.description,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            scannedData.expectedCode + " - " + _materials.firstWhere((element) => element.code == scannedData.expectedCode).description,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            scannedData.actualCode + " - " + _materials.firstWhere((element) => element.code == scannedData.actualCode).description,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _scannedData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
