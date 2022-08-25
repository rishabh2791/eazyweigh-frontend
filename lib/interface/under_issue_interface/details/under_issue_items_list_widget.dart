import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/under_issue.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class UnderIssueItemsListWidget extends StatefulWidget {
  final List<UnderIssue> underIssues;
  final Map<String, JobItem> jobItems;
  const UnderIssueItemsListWidget({
    Key? key,
    required this.underIssues,
    required this.jobItems,
  }) : super(key: key);

  @override
  State<UnderIssueItemsListWidget> createState() =>
      _UnderIssueItemsListWidgetState();
}

class _UnderIssueItemsListWidgetState extends State<UnderIssueItemsListWidget> {
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
          widget.underIssues.sort(
              (a, b) => a.weighed.toString().compareTo(b.weighed.toString()));
        } else {
          widget.underIssues.sort(
              (a, b) => b.weighed.toString().compareTo(a.weighed.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.underIssues.sort(
              (a, b) => a.verified.toString().compareTo(b.verified.toString()));
        } else {
          widget.underIssues.sort(
              (a, b) => b.verified.toString().compareTo(a.verified.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.underIssues.sort((a, b) => widget.jobItems[a.id]!.material.code
              .compareTo(widget.jobItems[b.id]!.material.code));
        } else {
          widget.underIssues.sort((a, b) => widget.jobItems[b.id]!.material.code
              .compareTo(widget.jobItems[a.id]!.material.code));
        }
        break;
      case 3:
        if (ascending) {
          widget.underIssues.sort((a, b) => widget
              .jobItems[a.id]!.material.description
              .compareTo(widget.jobItems[b.id]!.material.description));
        } else {
          widget.underIssues.sort((a, b) => widget
              .jobItems[b.id]!.material.description
              .compareTo(widget.jobItems[a.id]!.material.description));
        }
        break;
      case 4:
        if (ascending) {
          widget.underIssues
              .sort((a, b) => (a.req - a.actual).compareTo(b.req - b.actual));
        } else {
          widget.underIssues
              .sort((a, b) => (b.req - b.actual).compareTo(a.req - a.actual));
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
                        source: _DataSource(
                            context, widget.underIssues, widget.jobItems),
                        rowsPerPage: widget.underIssues.length > 25
                            ? 25
                            : widget.underIssues.length,
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
  _DataSource(this.context, this._underIssuesItems, this._jobItems) {
    _underIssuesItems = _underIssuesItems;
    _jobItems = _jobItems;
  }

  final BuildContext context;
  List<UnderIssue> _underIssuesItems;
  Map<String, JobItem> _jobItems;
  // ignore: unused_field
  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final underIssueItem = _underIssuesItems[index];
    return DataRow.byIndex(
      index: index,
      selected: underIssueItem.selected,
      onSelectChanged: (value) {
        if (underIssueItem.selected != value) {
          _selectedCount += value! ? 1 : -1;
          underIssueItem.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(
          Text(
            underIssueItem.weighed.toString().toUpperCase(),
            style: TextStyle(
              fontSize: 16.0,
              color: underIssueItem.weighed ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            underIssueItem.verified.toString().toUpperCase(),
            style: TextStyle(
              fontSize: 16.0,
              color: underIssueItem.verified ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            _jobItems[underIssueItem.id]!.material.code,
            style: TextStyle(
              fontSize: 16.0,
              color: underIssueItem.verified ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            _jobItems[underIssueItem.id]!.material.description,
            style: TextStyle(
              fontSize: 16.0,
              color: underIssueItem.verified ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            (underIssueItem.req - underIssueItem.actual).toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: underIssueItem.verified ? Colors.green : Colors.red,
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
