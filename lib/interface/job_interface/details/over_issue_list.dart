import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/over_issue_interface/list/hybrid_over_issue.dart';
import 'package:flutter/material.dart';

class OverIssueList extends StatefulWidget {
  final List<HybridOverIssue> overIssues;
  const OverIssueList({
    Key? key,
    required this.overIssues,
  }) : super(key: key);

  @override
  State<OverIssueList> createState() => _OverIssueListState();
}

class _OverIssueListState extends State<OverIssueList> {
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
          widget.overIssues.sort((a, b) => a.overIssue.createdAt
              .toString()
              .compareTo(b.overIssue.createdAt.toString()));
        } else {
          widget.overIssues.sort((a, b) => b.overIssue.createdAt
              .toString()
              .compareTo(a.overIssue.createdAt.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.overIssues.sort((a, b) =>
              a.job.jobCode.toString().compareTo(b.job.jobCode.toString()));
        } else {
          widget.overIssues.sort((a, b) =>
              b.job.jobCode.toString().compareTo(a.job.jobCode.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.overIssues.sort((a, b) => a.overIssue.jobItem.material.code
              .toString()
              .compareTo(b.overIssue.jobItem.material.code.toString()));
        } else {
          widget.overIssues.sort((a, b) => b.overIssue.jobItem.material.code
              .toString()
              .compareTo(a.overIssue.jobItem.material.code.toString()));
        }
        break;
      case 3:
        if (ascending) {
          widget.overIssues.sort((a, b) => a
              .overIssue.jobItem.material.description
              .toString()
              .compareTo(b.overIssue.jobItem.material.description.toString()));
        } else {
          widget.overIssues.sort((a, b) => b
              .overIssue.jobItem.material.description
              .toString()
              .compareTo(a.overIssue.jobItem.material.description.toString()));
        }
        break;
      case 4:
        if (ascending) {
          widget.overIssues.sort((a, b) =>
              a.overIssue.req.toString().compareTo(b.overIssue.req.toString()));
        } else {
          widget.overIssues.sort((a, b) =>
              b.overIssue.req.toString().compareTo(a.overIssue.req.toString()));
        }
        break;
      case 5:
        if (ascending) {
          widget.overIssues.sort((a, b) => (a.overIssue.actual -
                  a.overIssue.req)
              .toString()
              .compareTo((b.overIssue.actual - b.overIssue.req).toString()));
        } else {
          widget.overIssues.sort((a, b) => (b.overIssue.actual -
                  b.overIssue.req)
              .toString()
              .compareTo((a.overIssue.actual - a.overIssue.req).toString()));
        }
        break;
      case 6:
        if (ascending) {
          widget.overIssues.sort((a, b) => (a.overIssue.createdBy.firstName +
                  " " +
                  a.overIssue.createdBy.lastName)
              .toString()
              .compareTo((b.overIssue.createdBy.firstName +
                      " " +
                      b.overIssue.createdBy.lastName)
                  .toString()));
        } else {
          widget.overIssues.sort((a, b) => (b.overIssue.updatedBy.firstName +
                  " " +
                  b.overIssue.updatedBy.lastName)
              .toString()
              .compareTo((a.overIssue.updatedBy.firstName +
                      " " +
                      a.overIssue.updatedBy.lastName)
                  .toString()));
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
          height:
              double.parse((150 + 56 * widget.overIssues.length).toString()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    cardColor: backgroundColor,
                    dividerColor: foregroundColor.withOpacity(0.25),
                    textTheme: const TextTheme(
                        caption: TextStyle(color: foregroundColor)),
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
                            label: const Text(
                              "ID",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: foregroundColor,
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
                            label: const Text(
                              "Required Qty",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: foregroundColor,
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
                            label: const Text(
                              "Over Issued Qty.",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: foregroundColor,
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
                            label: const Text(
                              "Weighed Qty",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: foregroundColor,
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
                            label: const Text(
                              "Weighed By",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: foregroundColor,
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
                            label: const Text(
                              "Verified",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: foregroundColor,
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
                        source: _DataSource(context, widget.overIssues),
                        rowsPerPage: widget.overIssues.length > 25
                            ? 25
                            : widget.overIssues.length,
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
  _DataSource(this.context, this._overIssues) {
    _overIssues = _overIssues;
  }

  final BuildContext context;
  List<HybridOverIssue> _overIssues;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final overIssues = _overIssues[index];
    return DataRow.byIndex(
      index: index,
      color: MaterialStateColor.resolveWith(
        (states) {
          return overIssues.overIssue.weighed
              ? Colors.transparent
              : Colors.blue;
        },
      ),
      cells: [
        DataCell(
          Text(
            overIssues.overIssue.id,
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            overIssues.overIssue.req.toString(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            (overIssues.overIssue.actual - overIssues.overIssue.req).toString(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            overIssues.overIssue.weight.toString(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            overIssues.overIssue.weighed
                ? overIssues.overIssue.updatedBy.firstName +
                    " " +
                    overIssues.overIssue.updatedBy.lastName
                : "Not Weighed",
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          overIssues.overIssue.verified
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
  int get rowCount => _overIssues.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
