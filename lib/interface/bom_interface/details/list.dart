import 'package:eazyweigh/domain/entity/bom_item.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class BOMItemsListWidget extends StatefulWidget {
  final List<BomItem> bomItems;
  const BOMItemsListWidget({
    Key? key,
    required this.bomItems,
  }) : super(key: key);

  @override
  State<BOMItemsListWidget> createState() => _BOMItemsListWidgetState();
}

class _BOMItemsListWidgetState extends State<BOMItemsListWidget> {
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
          widget.bomItems.sort((a, b) => a.material.code.compareTo(b.material.code));
        } else {
          widget.bomItems.sort((a, b) => b.material.code.compareTo(a.material.code));
        }
        break;
      case 1:
        if (ascending) {
          widget.bomItems.sort((a, b) => a.material.description.compareTo(b.material.description));
        } else {
          widget.bomItems.sort((a, b) => b.material.description.compareTo(a.material.description));
        }
        break;
      case 2:
        if (ascending) {
          widget.bomItems.sort((a, b) => a.quantity.compareTo(b.quantity));
        } else {
          widget.bomItems.sort((a, b) => b.quantity.compareTo(a.quantity));
        }
        break;
      case 3:
        if (ascending) {
          widget.bomItems.sort((a, b) => a.uom.code.compareTo(b.uom.code));
        } else {
          widget.bomItems.sort((a, b) => b.uom.code.compareTo(a.uom.code));
        }
        break;
      case 4:
        if (ascending) {
          widget.bomItems.sort((a, b) => a.upperTolerance.compareTo(b.upperTolerance));
        } else {
          widget.bomItems.sort((a, b) => b.upperTolerance.compareTo(a.upperTolerance));
        }
        break;
      case 5:
        if (ascending) {
          widget.bomItems.sort((a, b) => a.lowerTolerance.compareTo(b.lowerTolerance));
        } else {
          widget.bomItems.sort((a, b) => b.lowerTolerance.compareTo(a.lowerTolerance));
        }
        break;
      case 6:
        if (ascending) {
          widget.bomItems.sort((a, b) => a.overIssue.toString().compareTo(b.overIssue.toString()));
        } else {
          widget.bomItems.sort((a, b) => b.overIssue.toString().compareTo(a.overIssue.toString()));
        }
        break;
      case 7:
        if (ascending) {
          widget.bomItems.sort((a, b) => a.underIssue.toString().compareTo(b.underIssue.toString()));
        } else {
          widget.bomItems.sort((a, b) => b.underIssue.toString().compareTo(a.underIssue.toString()));
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
                    dividerColor: themeChanged.value ? foregroundColor : backgroundColor,
                    textTheme: TextTheme(bodySmall: TextStyle(color: themeChanged.value ? foregroundColor : backgroundColor)),
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
                              "Material Code",
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
                              "Material Description",
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
                              "Quantity",
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
                              "UOM",
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
                              "Upper Limit",
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
                              "Lower Limit",
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
                              "Over Issue",
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
                              "Under Issue",
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
                        source: _DataSource(context, widget.bomItems),
                        rowsPerPage: widget.bomItems.length > 25 ? 25 : widget.bomItems.length,
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
  _DataSource(this.context, this._bomItems) {
    _bomItems = _bomItems;
  }

  final BuildContext context;
  List<BomItem> _bomItems;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final bomItem = _bomItems[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            bomItem.material.code,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            bomItem.material.description,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            bomItem.quantity.toStringAsFixed(3),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            bomItem.uom.code,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            (bomItem.quantity * (1 + bomItem.upperTolerance / 100)).toStringAsFixed(3),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            (bomItem.quantity * (1 - bomItem.lowerTolerance / 100)).toStringAsFixed(3),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          bomItem.overIssue
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.stop,
                  color: Colors.red,
                ),
        ),
        DataCell(
          bomItem.underIssue
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.stop,
                  color: Colors.red,
                ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _bomItems.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
