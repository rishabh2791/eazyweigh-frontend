import 'package:eazyweigh/domain/entity/job_item_weighing.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class WeighingBatchList extends StatefulWidget {
  final List<WeighingBatch> weighingBatches;
  final List<Mat> materials;
  const WeighingBatchList({
    Key? key,
    required this.weighingBatches,
    required this.materials,
  }) : super(key: key);

  @override
  State<WeighingBatchList> createState() => _WeighingBatchListState();
}

class _WeighingBatchListState extends State<WeighingBatchList> {
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
          widget.weighingBatches.sort(
              (a, b) => a.jobCode.toString().compareTo(b.jobCode.toString()));
        } else {
          widget.weighingBatches.sort(
              (a, b) => b.jobCode.toString().compareTo(a.jobCode.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.weighingBatches.sort((a, b) {
            Mat materialA = widget.materials
                .firstWhere((element) => element.id == a.jobMaterialID);
            Mat materialB = widget.materials
                .firstWhere((element) => element.id == b.jobMaterialID);
            return materialA.code.compareTo(materialB.code);
          });
        } else {
          widget.weighingBatches.sort((a, b) {
            Mat materialA = widget.materials
                .firstWhere((element) => element.id == a.jobMaterialID);
            Mat materialB = widget.materials
                .firstWhere((element) => element.id == b.jobMaterialID);
            return materialB.code.compareTo(materialA.code);
          });
        }
        break;
      case 2:
        if (ascending) {
          widget.weighingBatches.sort((a, b) {
            Mat materialA = widget.materials
                .firstWhere((element) => element.id == a.jobMaterialID);
            Mat materialB = widget.materials
                .firstWhere((element) => element.id == b.jobMaterialID);
            return materialA.description.compareTo(materialB.description);
          });
        } else {
          widget.weighingBatches.sort((a, b) {
            Mat materialA = widget.materials
                .firstWhere((element) => element.id == a.jobMaterialID);
            Mat materialB = widget.materials
                .firstWhere((element) => element.id == b.jobMaterialID);
            return materialB.description.compareTo(materialA.description);
          });
        }
        break;
      case 3:
        if (ascending) {
          widget.weighingBatches.sort((a, b) => a.requiredWeight
              .toString()
              .compareTo(b.requiredWeight.toString()));
        } else {
          widget.weighingBatches.sort((a, b) => b.requiredWeight
              .toString()
              .compareTo(a.requiredWeight.toString()));
        }
        break;
      case 4:
        if (ascending) {
          widget.weighingBatches.sort((a, b) =>
              a.actualWeight.toString().compareTo(b.actualWeight.toString()));
        } else {
          widget.weighingBatches.sort((a, b) =>
              b.actualWeight.toString().compareTo(a.actualWeight.toString()));
        }
        break;
      case 5:
        if (ascending) {
          widget.weighingBatches.sort((a, b) => a.createdByUsername
              .toString()
              .compareTo(b.createdByUsername.toString()));
        } else {
          widget.weighingBatches.sort((a, b) => b.createdByUsername
              .toString()
              .compareTo(a.createdByUsername.toString()));
        }
        break;
      case 6:
        if (ascending) {
          widget.weighingBatches.sort((a, b) =>
              a.createdAt.toString().compareTo(b.createdAt.toString()));
        } else {
          widget.weighingBatches.sort((a, b) =>
              b.createdAt.toString().compareTo(a.createdAt.toString()));
        }
        break;
      default:
        break;
    }
  }

  Widget listDetailsWidget() {
    return ValueListenableBuilder(
      valueListenable: themeChanged,
      builder: (_, theme, child) {
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
                        cardColor: themeChanged.value
                            ? backgroundColor
                            : foregroundColor,
                        dividerColor: themeChanged.value
                            ? foregroundColor
                            : backgroundColor,
                        textTheme: TextTheme(
                            caption: TextStyle(
                                color: themeChanged.value
                                    ? foregroundColor
                                    : backgroundColor)),
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
                                  "Job Code",
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
                                  "Material",
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
                                  "Material Name",
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
                                  "Required Weight",
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
                                  "Actual Weight",
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
                                  "Weighed By",
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
                                  "Weighed On",
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
                            source: _DataSource(
                              context,
                              widget.weighingBatches,
                              widget.materials,
                            ),
                            rowsPerPage: widget.weighingBatches.length > 25
                                ? 25
                                : widget.weighingBatches.length,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return listDetailsWidget();
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this._weighingBatches, this._materials) {
    _weighingBatches = _weighingBatches;
    _materials = _materials;
  }

  final BuildContext context;
  List<WeighingBatch> _weighingBatches;
  List<Mat> _materials;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final weighingBatch = _weighingBatches[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            weighingBatch.jobCode,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            _materials
                .firstWhere(
                    (element) => weighingBatch.jobMaterialID == element.id)
                .code
                .toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            _materials
                .firstWhere(
                    (element) => weighingBatch.jobMaterialID == element.id)
                .description,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            weighingBatch.requiredWeight
                .toStringAsFixed(3)
                .replaceAllMapped(reg, (Match match) => '${match[1]},'),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            weighingBatch.actualWeight
                .toStringAsFixed(3)
                .replaceAllMapped(reg, (Match match) => '${match[1]},'),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            weighingBatch.createdByUsername.toUpperCase(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            weighingBatch.createdAt.toLocal().toString().substring(0, 10),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _weighingBatches.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
