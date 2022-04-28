import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class JobItemsListWidget extends StatefulWidget {
  final List<JobItem> jobItems;
  const JobItemsListWidget({
    Key? key,
    required this.jobItems,
  }) : super(key: key);

  @override
  State<JobItemsListWidget> createState() => _JobItemsListWidgetState();
}

class _JobItemsListWidgetState extends State<JobItemsListWidget> {
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
          widget.jobItems.sort(
              (a, b) => a.selected.toString().compareTo(b.selected.toString()));
        } else {
          widget.jobItems.sort(
              (a, b) => b.selected.toString().compareTo(a.selected.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.jobItems.sort(
              (a, b) => a.assigned.toString().compareTo(b.assigned.toString()));
        } else {
          widget.jobItems.sort(
              (a, b) => b.assigned.toString().compareTo(a.assigned.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.jobItems
              .sort((a, b) => a.material.code.compareTo(b.material.code));
        } else {
          widget.jobItems
              .sort((a, b) => b.material.code.compareTo(a.material.code));
        }
        break;
      case 3:
        if (ascending) {
          widget.jobItems.sort((a, b) =>
              a.material.description.compareTo(b.material.description));
        } else {
          widget.jobItems.sort((a, b) =>
              b.material.description.compareTo(a.material.description));
        }
        break;
      case 4:
        if (ascending) {
          widget.jobItems
              .sort((a, b) => a.requiredWeight.compareTo(b.requiredWeight));
        } else {
          widget.jobItems
              .sort((a, b) => b.requiredWeight.compareTo(a.requiredWeight));
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
                              "Selected",
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
                              "Assigned",
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
                              "Material Code",
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
                              "Material Description",
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
                        ],
                        source: _DataSource(context, widget.jobItems),
                        rowsPerPage: widget.jobItems.length > 25
                            ? 25
                            : widget.jobItems.length,
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
  _DataSource(this.context, this._jobItems) {
    _jobItems = _jobItems;
  }

  final BuildContext context;
  List<JobItem> _jobItems;
  // ignore: unused_field
  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final jobItem = _jobItems[index];
    return DataRow.byIndex(
      index: index,
      selected: jobItem.selected,
      onSelectChanged: (value) {
        if (!jobItem.assigned) {
          if (jobItem.selected != value) {
            _selectedCount += value! ? 1 : -1;
            jobItem.selected = value;
            notifyListeners();
          }
        }
      },
      cells: [
        DataCell(
          jobItem.selected
              ? const Icon(
                  Icons.check,
                  color: Colors.red,
                )
              : Container(),
        ),
        DataCell(
          jobItem.assigned
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
            jobItem.material.code,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItem.material.description,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItem.requiredWeight.toStringAsFixed(3),
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
  int get rowCount => _jobItems.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
