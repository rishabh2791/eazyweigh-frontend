import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/over_issue.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class OverIssueItemsListWidget extends StatefulWidget {
  final List<OverIssue> overIssues;
  final Map<String, JobItem> jobItems;
  const OverIssueItemsListWidget({
    Key? key,
    required this.overIssues,
    required this.jobItems,
  }) : super(key: key);

  @override
  State<OverIssueItemsListWidget> createState() => _OverIssueItemsListWidgetState();
}

class _OverIssueItemsListWidgetState extends State<OverIssueItemsListWidget> {
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
          widget.overIssues.sort((a, b) => a.weighed.toString().compareTo(b.weighed.toString()));
        } else {
          widget.overIssues.sort((a, b) => b.weighed.toString().compareTo(a.weighed.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.overIssues.sort((a, b) => a.verified.toString().compareTo(b.verified.toString()));
        } else {
          widget.overIssues.sort((a, b) => b.verified.toString().compareTo(a.verified.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.overIssues.sort((a, b) => widget.jobItems[a.id]!.material.code.compareTo(widget.jobItems[b.id]!.material.code));
        } else {
          widget.overIssues.sort((a, b) => widget.jobItems[b.id]!.material.code.compareTo(widget.jobItems[a.id]!.material.code));
        }
        break;
      case 3:
        if (ascending) {
          widget.overIssues.sort((a, b) => widget.jobItems[a.id]!.material.description.compareTo(widget.jobItems[b.id]!.material.description));
        } else {
          widget.overIssues.sort((a, b) => widget.jobItems[b.id]!.material.description.compareTo(widget.jobItems[a.id]!.material.description));
        }
        break;
      case 4:
        if (ascending) {
          widget.overIssues.sort((a, b) => (a.actual - a.req).compareTo(b.actual - b.req));
        } else {
          widget.overIssues.sort((a, b) => (b.actual - b.req).compareTo(a.actual - a.req));
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
                    textTheme: const TextTheme(caption: TextStyle(color: foregroundColor)),
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
                            label: const Text(
                              "Weighed",
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
                              "Material Description",
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
                              "Quantity",
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
                        source: _DataSource(context, widget.overIssues, widget.jobItems),
                        rowsPerPage: widget.overIssues.length > 25 ? 25 : widget.overIssues.length,
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
  _DataSource(this.context, this._overIssuesItems, this._jobItems) {
    _overIssuesItems = _overIssuesItems;
    _jobItems = _jobItems;
  }

  final BuildContext context;
  List<OverIssue> _overIssuesItems;
  Map<String, JobItem> _jobItems;
  // ignore: unused_field
  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final overIssueItem = _overIssuesItems[index];
    return DataRow.byIndex(
      index: index,
      selected: overIssueItem.selected,
      onSelectChanged: (value) {
        if (overIssueItem.selected != value) {
          _selectedCount += value! ? 1 : -1;
          overIssueItem.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(
          Text(
            overIssueItem.weighed.toString().toUpperCase(),
            style: TextStyle(
              fontSize: 16.0,
              color: overIssueItem.weighed ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            overIssueItem.verified.toString().toUpperCase(),
            style: TextStyle(
              fontSize: 16.0,
              color: overIssueItem.verified ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            _jobItems[overIssueItem.id]!.material.code,
            style: TextStyle(
              fontSize: 16.0,
              color: overIssueItem.verified ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            _jobItems[overIssueItem.id]!.material.description,
            style: TextStyle(
              fontSize: 16.0,
              color: overIssueItem.verified ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            (overIssueItem.actual - overIssueItem.req).toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: overIssueItem.verified ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _jobItems.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
