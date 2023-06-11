import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/under_issue_interface/list/hybrid_under_issue.dart';
import 'package:flutter/material.dart';

class UnderIssueList extends StatefulWidget {
  final List<HybridUnderIssue> underIssues;
  const UnderIssueList({
    Key? key,
    required this.underIssues,
  }) : super(key: key);

  @override
  State<UnderIssueList> createState() => _UnderIssueListState();
}

class _UnderIssueListState extends State<UnderIssueList> {
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
          widget.underIssues.sort((a, b) => a.underIssue.createdAt.toString().compareTo(b.underIssue.createdAt.toString()));
        } else {
          widget.underIssues.sort((a, b) => b.underIssue.createdAt.toString().compareTo(a.underIssue.createdAt.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.underIssues.sort((a, b) => a.job.jobCode.toString().compareTo(b.job.jobCode.toString()));
        } else {
          widget.underIssues.sort((a, b) => b.job.jobCode.toString().compareTo(a.job.jobCode.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.underIssues.sort((a, b) => a.underIssue.jobItem.material.code.toString().compareTo(b.underIssue.jobItem.material.code.toString()));
        } else {
          widget.underIssues.sort((a, b) => b.underIssue.jobItem.material.code.toString().compareTo(a.underIssue.jobItem.material.code.toString()));
        }
        break;
      case 3:
        if (ascending) {
          widget.underIssues.sort((a, b) => a.underIssue.jobItem.material.description.toString().compareTo(b.underIssue.jobItem.material.description.toString()));
        } else {
          widget.underIssues.sort((a, b) => b.underIssue.jobItem.material.description.toString().compareTo(a.underIssue.jobItem.material.description.toString()));
        }
        break;
      case 4:
        if (ascending) {
          widget.underIssues.sort((a, b) => a.underIssue.req.toString().compareTo(b.underIssue.req.toString()));
        } else {
          widget.underIssues.sort((a, b) => b.underIssue.req.toString().compareTo(a.underIssue.req.toString()));
        }
        break;
      case 5:
        if (ascending) {
          widget.underIssues.sort((a, b) => (a.underIssue.req - a.underIssue.actual).toString().compareTo((b.underIssue.req - b.underIssue.actual).toString()));
        } else {
          widget.underIssues.sort((a, b) => (b.underIssue.req - b.underIssue.actual).toString().compareTo((a.underIssue.req - a.underIssue.actual).toString()));
        }
        break;
      case 6:
        if (ascending) {
          widget.underIssues.sort((a, b) =>
              (a.underIssue.createdBy.firstName + " " + a.underIssue.createdBy.lastName).toString().compareTo((b.underIssue.createdBy.firstName + " " + b.underIssue.createdBy.lastName).toString()));
        } else {
          widget.underIssues.sort((a, b) =>
              (b.underIssue.createdBy.firstName + " " + b.underIssue.createdBy.lastName).toString().compareTo((a.underIssue.createdBy.firstName + " " + a.underIssue.createdBy.lastName).toString()));
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
                    cardColor: backgroundColor,
                    dividerColor: foregroundColor.withOpacity(0.25),
                    textTheme: const TextTheme(bodySmall: TextStyle(color: foregroundColor)),
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
                              "Date",
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
                              "Job Code",
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
                              "Material Code",
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
                              "Material Name",
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
                              "Under Issued Qty.",
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
                              "Created By",
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
                        source: _DataSource(context, widget.underIssues),
                        rowsPerPage: widget.underIssues.length > 25 ? 25 : widget.underIssues.length,
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
  _DataSource(this.context, this._underIssues) {
    _underIssues = _underIssues;
  }

  final BuildContext context;
  List<HybridUnderIssue> _underIssues;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final underIssues = _underIssues[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            underIssues.underIssue.createdAt.toLocal().toString().substring(0, 10),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            underIssues.job.jobCode,
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            underIssues.underIssue.jobItem.material.code.toString(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            underIssues.underIssue.jobItem.material.description,
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            underIssues.underIssue.req.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            (underIssues.underIssue.req - underIssues.underIssue.actual).toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            underIssues.underIssue.createdBy.firstName + " " + underIssues.underIssue.createdBy.lastName,
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _underIssues.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
