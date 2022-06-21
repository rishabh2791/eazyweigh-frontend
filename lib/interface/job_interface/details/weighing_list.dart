import 'package:eazyweigh/domain/entity/job_item_weighing.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class JobWeighingList extends StatefulWidget {
  final List<JobItemWeighing> jobWeighings;
  const JobWeighingList({
    Key? key,
    required this.jobWeighings,
  }) : super(key: key);

  @override
  State<JobWeighingList> createState() => _JobItemItemsListState();
}

class _JobItemItemsListState extends State<JobWeighingList> {
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
          widget.jobWeighings
              .sort((a, b) => a.id.toString().compareTo(b.id.toString()));
        } else {
          widget.jobWeighings
              .sort((a, b) => b.id.toString().compareTo(a.id.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.jobWeighings.sort((a, b) => a.jobItem.material.code
              .toString()
              .compareTo(b.jobItem.material.code.toString()));
        } else {
          widget.jobWeighings.sort((a, b) => b.jobItem.material.code
              .toString()
              .compareTo(a.jobItem.material.code.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.jobWeighings.sort((a, b) => a.jobItem.material.description
              .toString()
              .compareTo(b.jobItem.material.description.toString()));
        } else {
          widget.jobWeighings.sort((a, b) => b.jobItem.material.description
              .toString()
              .compareTo(a.jobItem.material.description.toString()));
        }
        break;
      case 3:
        if (ascending) {
          widget.jobWeighings.sort(
              (a, b) => a.weight.toString().compareTo(b.weight.toString()));
        } else {
          widget.jobWeighings.sort(
              (a, b) => b.weight.toString().compareTo(a.weight.toString()));
        }
        break;
      case 4:
        if (ascending) {
          widget.jobWeighings.sort((a, b) => (a.createdBy.firstName +
                  " " +
                  a.createdBy.lastName)
              .toString()
              .compareTo((b.createdBy.firstName + " " + b.createdBy.lastName)
                  .toString()));
        } else {
          widget.jobWeighings.sort((a, b) => (b.createdBy.firstName +
                  " " +
                  b.createdBy.lastName)
              .toString()
              .compareTo((a.createdBy.firstName + " " + a.createdBy.lastName)
                  .toString()));
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
              height: double.parse(
                  (150 + 56 * widget.jobWeighings.length).toString()),
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
                                  "Weighing ID",
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
                                  "Quantity",
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
                                  "Batch",
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
                                  "Time Taken (s)",
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
                                  "Verified",
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
                              widget.jobWeighings,
                            ),
                            rowsPerPage: widget.jobWeighings.length > 25
                                ? 25
                                : widget.jobWeighings.length,
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
  _DataSource(this.context, this._jobWeighings) {
    _jobWeighings = _jobWeighings;
  }

  final BuildContext context;
  List<JobItemWeighing> _jobWeighings;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final jobWeighing = _jobWeighings[index];
    return DataRow.byIndex(
      color: MaterialStateColor.resolveWith(
        (states) {
          return jobWeighing.jobItem.complete
              ? Colors.transparent
              : Colors.blue;
        },
      ),
      index: index,
      cells: [
        DataCell(
          Text(
            jobWeighing.id,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobWeighing.weight.toString() + " " + jobWeighing.jobItem.uom.code,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobWeighing.batch,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobWeighing.createdBy.firstName +
                " " +
                jobWeighing.createdBy.lastName,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobWeighing.endTime
                .difference(jobWeighing.startTime)
                .inSeconds
                .toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          jobWeighing.jobItem.verified
              ? const Icon(Icons.check, color: Colors.green)
              : const Icon(
                  Icons.stop,
                  color: Colors.red,
                ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _jobWeighings.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
