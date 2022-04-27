import 'package:eazyweigh/domain/entity/job_item_assignment.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class JobAssignmentListWidget extends StatefulWidget {
  final List<JobItemAssignment> jobItemAssignments;
  const JobAssignmentListWidget({
    Key? key,
    required this.jobItemAssignments,
  }) : super(key: key);

  @override
  State<JobAssignmentListWidget> createState() =>
      _JobAssignmentListWidgetState();
}

class _JobAssignmentListWidgetState extends State<JobAssignmentListWidget> {
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
          widget.jobItemAssignments.sort((a, b) => a.jobItem.material.code
              .toString()
              .compareTo(b.jobItem.material.code.toString()));
        } else {
          widget.jobItemAssignments.sort((a, b) => b.jobItem.material.code
              .toString()
              .compareTo(a.jobItem.material.code.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.jobItemAssignments.sort((a, b) => a
              .jobItem.material.description
              .toString()
              .compareTo(b.jobItem.material.description.toString()));
        } else {
          widget.jobItemAssignments.sort((a, b) => b
              .jobItem.material.description
              .toString()
              .compareTo(a.jobItem.material.description.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.jobItemAssignments.sort((a, b) => a.jobItem.requiredWeight
              .toString()
              .compareTo(b.jobItem.requiredWeight.toString()));
        } else {
          widget.jobItemAssignments.sort((a, b) => b.jobItem.requiredWeight
              .toString()
              .compareTo(a.jobItem.requiredWeight.toString()));
        }
        break;
      case 3:
        if (ascending) {
          widget.jobItemAssignments.sort((a, b) =>
              (a.shiftSchedule.weigher.firstName +
                      " " +
                      a.shiftSchedule.weigher.lastName)
                  .compareTo(b.shiftSchedule.weigher.firstName +
                      " " +
                      b.shiftSchedule.weigher.lastName));
        } else {
          widget.jobItemAssignments.sort((a, b) =>
              (b.shiftSchedule.weigher.firstName +
                      " " +
                      b.shiftSchedule.weigher.lastName)
                  .compareTo(a.shiftSchedule.weigher.firstName +
                      " " +
                      a.shiftSchedule.weigher.lastName));
        }
        break;
      case 4:
        if (ascending) {
          widget.jobItemAssignments.sort((a, b) =>
              (a.shiftSchedule.date.toString().substring(0, 10) +
                      " " +
                      a.shiftSchedule.shift.code.toString())
                  .compareTo(b.shiftSchedule.date.toString().substring(0, 10) +
                      " " +
                      b.shiftSchedule.shift.code.toString()));
        } else {
          widget.jobItemAssignments.sort((a, b) =>
              (b.shiftSchedule.date.toString().substring(0, 10) +
                      " " +
                      b.shiftSchedule.shift.code.toString())
                  .compareTo(a.shiftSchedule.date.toString().substring(0, 10) +
                      " " +
                      a.shiftSchedule.shift.code.toString()));
        }
        break;
      case 5:
        if (ascending) {
          widget.jobItemAssignments.sort((a, b) => a.jobItem.complete
              .toString()
              .compareTo(b.jobItem.complete.toString()));
        } else {
          widget.jobItemAssignments.sort((a, b) => b.jobItem.complete
              .toString()
              .compareTo(a.jobItem.complete.toString()));
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
                          DataColumn(
                            label: Text(
                              "Assigned To",
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
                              "Shift",
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
                              "Status",
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
                        source: _DataSource(context, widget.jobItemAssignments),
                        rowsPerPage: widget.jobItemAssignments.length > 25
                            ? 25
                            : widget.jobItemAssignments.length,
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
  _DataSource(this.context, this._jobItemAssignments) {
    _jobItemAssignments = _jobItemAssignments;
  }

  final BuildContext context;
  List<JobItemAssignment> _jobItemAssignments;
  // ignore: unused_field
  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final jobItemAssignment = _jobItemAssignments[index];
    return DataRow.byIndex(
      index: index,
      selected: jobItemAssignment.selected,
      onSelectChanged: (value) {
        if (jobItemAssignment.selected != value) {
          _selectedCount += value! ? 1 : -1;
          jobItemAssignment.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(
          Text(
            jobItemAssignment.jobItem.material.code,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItemAssignment.jobItem.material.description,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItemAssignment.jobItem.requiredWeight.toString() +
                " " +
                jobItemAssignment.jobItem.uom.code,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItemAssignment.shiftSchedule.weigher.firstName +
                " " +
                jobItemAssignment.shiftSchedule.weigher.lastName,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItemAssignment.shiftSchedule.date.toString().substring(0, 10) +
                " " +
                jobItemAssignment.shiftSchedule.shift.code +
                " Shift",
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          jobItemAssignment.jobItem.complete
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 30.0,
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
  int get rowCount => _jobItemAssignments.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
