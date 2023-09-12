import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/job_interface/weighing/material_details.dart';
import 'package:flutter/material.dart';

class MaterialWeighingListWidget extends StatefulWidget {
  final List<MaterialWeighing> weighingMaterials;
  const MaterialWeighingListWidget({
    Key? key,
    required this.weighingMaterials,
  }) : super(key: key);

  @override
  State<MaterialWeighingListWidget> createState() => _MaterialWeighingListWidgetState();
}

class _MaterialWeighingListWidgetState extends State<MaterialWeighingListWidget> {
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
          widget.weighingMaterials.sort((a, b) => a.jobCode.toString().compareTo(b.jobCode.toString()));
        } else {
          widget.weighingMaterials.sort((a, b) => b.jobCode.toString().compareTo(a.jobCode.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.weighingMaterials.sort((a, b) => a.weight.toString().compareTo(b.weight.toString()));
        } else {
          widget.weighingMaterials.sort((a, b) => b.weight.toString().compareTo(a.weight.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.weighingMaterials.sort((a, b) => a.batch.toString().compareTo(b.batch.toString()));
        } else {
          widget.weighingMaterials.sort((a, b) => b.batch.toString().compareTo(a.batch.toString()));
        }
        break;
      case 3:
        if (ascending) {
          widget.weighingMaterials.sort((a, b) => a.updatedBy.toString().compareTo(b.updatedBy.toString()));
        } else {
          widget.weighingMaterials.sort((a, b) => b.updatedBy.toString().compareTo(a.updatedBy.toString()));
        }
        break;
      case 4:
        if (ascending) {
          widget.weighingMaterials.sort((a, b) => a.verified.toString().compareTo(b.verified.toString()));
        } else {
          widget.weighingMaterials.sort((a, b) => b.verified.toString().compareTo(a.verified.toString()));
        }
        break;
      case 5:
        if (ascending) {
          widget.weighingMaterials.sort((a, b) => a.updatedAt.toString().compareTo(b.updatedAt.toString()));
        } else {
          widget.weighingMaterials.sort((a, b) => b.updatedAt.toString().compareTo(a.updatedAt.toString()));
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
                        cardColor: themeChanged.value ? backgroundColor : foregroundColor,
                        dividerColor: themeChanged.value ? foregroundColor : backgroundColor,
                        textTheme: TextTheme(
                          bodySmall: TextStyle(color: themeChanged.value ? foregroundColor : backgroundColor),
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
                                  "Weight",
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
                                  "Batch",
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
                                  "Weighed By",
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
                                  "Verified",
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
                                  "Weighed On",
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
                            source: _DataSource(
                              context,
                              widget.weighingMaterials,
                            ),
                            rowsPerPage: widget.weighingMaterials.length > 25 ? 25 : widget.weighingMaterials.length,
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
  _DataSource(this.context, this._weighingBatches) {
    _weighingBatches = _weighingBatches;
  }

  final BuildContext context;
  List<MaterialWeighing> _weighingBatches;

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
            weighingBatch.weight.toStringAsFixed(3),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            weighingBatch.batch.toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            weighingBatch.updatedBy.toUpperCase(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          weighingBatch.verified
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
          Text(
            weighingBatch.updatedAt.toLocal().toString().substring(0, 19),
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
