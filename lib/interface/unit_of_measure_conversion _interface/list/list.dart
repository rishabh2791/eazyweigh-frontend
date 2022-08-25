import 'package:eazyweigh/domain/entity/unit_of_measure_conversion.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class UOMConversionList extends StatefulWidget {
  final List<UnitOfMeasurementConversion> uomConversions;
  const UOMConversionList({
    Key? key,
    required this.uomConversions,
  }) : super(key: key);

  @override
  State<UOMConversionList> createState() => _UOMConversionListState();
}

class _UOMConversionListState extends State<UOMConversionList> {
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
          widget.uomConversions.sort((a, b) => a.unitOfMeasure1.code
              .toString()
              .compareTo(b.unitOfMeasure1.code.toString()));
        } else {
          widget.uomConversions.sort((a, b) => b.unitOfMeasure1.code
              .toString()
              .compareTo(a.unitOfMeasure1.code.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.uomConversions.sort(
              (a, b) => a.value2.toString().compareTo(b.value2.toString()));
        } else {
          widget.uomConversions.sort(
              (a, b) => b.value2.toString().compareTo(a.value2.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.uomConversions.sort((a, b) => a.unitOfMeasure2.code
              .toString()
              .compareTo(b.unitOfMeasure2.code.toString()));
        } else {
          widget.uomConversions.sort((a, b) => b.unitOfMeasure2.code
              .toString()
              .compareTo(a.unitOfMeasure2.code.toString()));
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
                    cardColor:
                        themeChanged.value ? backgroundColor : foregroundColor,
                    dividerColor: themeChanged.value
                        ? foregroundColor.withOpacity(0.25)
                        : backgroundColor.withOpacity(0.25),
                    textTheme: TextTheme(
                      caption: TextStyle(
                        color: themeChanged.value
                            ? foregroundColor
                            : backgroundColor,
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
                              "1 Unit Of",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value
                                    ? foregroundColor
                                    : backgroundColor,
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
                              "Equals",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value
                                    ? foregroundColor
                                    : backgroundColor,
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
                              "Units Of",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value
                                    ? foregroundColor
                                    : backgroundColor,
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
                        source: _DataSource(context, widget.uomConversions),
                        rowsPerPage: widget.uomConversions.length > 25
                            ? 25
                            : widget.uomConversions.length,
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
  _DataSource(this.context, this._uomConversions) {
    _uomConversions = _uomConversions;
  }

  final BuildContext context;
  List<UnitOfMeasurementConversion> _uomConversions;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final uomConversion = _uomConversions[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            uomConversion.unitOfMeasure1.code,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            uomConversion.value2.toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            uomConversion.unitOfMeasure2.code,
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
  int get rowCount => _uomConversions.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
