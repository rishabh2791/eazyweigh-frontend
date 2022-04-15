import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/job_interface/details/job_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobList extends StatefulWidget {
  final List<Job> jobs;
  const JobList({
    Key? key,
    required this.jobs,
  }) : super(key: key);

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
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
          widget.jobs.sort(
              (a, b) => a.jobCode.toString().compareTo(b.jobCode.toString()));
        } else {
          widget.jobs.sort(
              (a, b) => b.jobCode.toString().compareTo(a.jobCode.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.jobs.sort((a, b) =>
              a.material.code.toString().compareTo(b.material.code.toString()));
        } else {
          widget.jobs.sort((a, b) =>
              b.material.code.toString().compareTo(a.material.code.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.jobs.sort((a, b) => a.material.description
              .toString()
              .compareTo(b.material.description.toString()));
        } else {
          widget.jobs.sort((a, b) => b.material.description
              .toString()
              .compareTo(a.material.description.toString()));
        }
        break;
      case 3:
        if (ascending) {
          widget.jobs.sort(
              (a, b) => a.quantity.toString().compareTo(b.quantity.toString()));
        } else {
          widget.jobs.sort(
              (a, b) => b.quantity.toString().compareTo(a.quantity.toString()));
        }
        break;
      case 4:
        if (ascending) {
          widget.jobs.sort((a, b) => a.jobItems.length
              .toString()
              .compareTo(b.jobItems.length.toString()));
        } else {
          widget.jobs.sort((a, b) => b.jobItems.length
              .toString()
              .compareTo(a.jobItems.length.toString()));
        }
        break;
      case 5:
        if (ascending) {
          widget.jobs.sort(
              (a, b) => a.complete.toString().compareTo(b.complete.toString()));
        } else {
          widget.jobs.sort(
              (a, b) => b.complete.toString().compareTo(a.complete.toString()));
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
                              "Material",
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
                              "Job Size",
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
                              "Job Items",
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
                              "Complete",
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
                          context,
                          widget.jobs,
                        ),
                        rowsPerPage:
                            widget.jobs.length > 25 ? 25 : widget.jobs.length,
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
  _DataSource(this.context, this._jobs) {
    _jobs = _jobs;
  }

  final BuildContext context;
  List<Job> _jobs;
  // ignore: unused_field
  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final job = _jobs[index];
    return DataRow.byIndex(
      index: index,
      selected: job.selected,
      onSelectChanged: (value) {
        if (job.selected != value) {
          _selectedCount += value! ? 1 : -1;
          job.selected = value;
          notifyListeners();
          navigationService.pushReplacement(
            CupertinoPageRoute(
              builder: (BuildContext context) => JobDetailsWidget(
                  jobCode: job.jobCode, jobItems: job.jobItems),
            ),
          );
        }
      },
      cells: [
        DataCell(
          Text(
            job.jobCode,
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            job.material.code,
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            job.material.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            job.quantity.toString() + " " + job.uom.code,
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            job.jobItems.length.toString(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            job.complete.toString().toUpperCase(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _jobs.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
