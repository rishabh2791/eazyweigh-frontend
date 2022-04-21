import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/job_item_weighing.dart';
import 'package:eazyweigh/infrastructure/printing_service.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class JobItemsList extends StatefulWidget {
  final List<JobItem> jobs;
  final String jobCode;
  const JobItemsList({
    Key? key,
    required this.jobs,
    required this.jobCode,
  }) : super(key: key);

  @override
  State<JobItemsList> createState() => _JobItemItemsListState();
}

class _JobItemItemsListState extends State<JobItemsList> {
  bool sort = true, ascending = true;
  int sortingColumnIndex = 0;

  @override
  void initState() {
    printingService.initCommunication();
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
          widget.jobs.sort((a, b) =>
              a.material.code.toString().compareTo(b.material.code.toString()));
        } else {
          widget.jobs.sort((a, b) =>
              b.material.code.toString().compareTo(a.material.code.toString()));
        }
        break;
      case 1:
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
      case 2:
        if (ascending) {
          widget.jobs.sort((a, b) => a.requiredWeight
              .toString()
              .compareTo(b.requiredWeight.toString()));
        } else {
          widget.jobs.sort((a, b) => b.requiredWeight
              .toString()
              .compareTo(a.requiredWeight.toString()));
        }
        break;
      case 3:
        if (ascending) {
          widget.jobs.sort(
              (a, b) => a.assigned.toString().compareTo(b.assigned.toString()));
        } else {
          widget.jobs.sort(
              (a, b) => b.assigned.toString().compareTo(a.assigned.toString()));
        }
        break;
      case 4:
        if (ascending) {
          widget.jobs.sort(
              (a, b) => a.complete.toString().compareTo(b.complete.toString()));
        } else {
          widget.jobs.sort(
              (a, b) => b.complete.toString().compareTo(a.complete.toString()));
        }
        break;
      case 5:
        if (ascending) {
          widget.jobs.sort(
              (a, b) => a.verified.toString().compareTo(b.verified.toString()));
        } else {
          widget.jobs.sort(
              (a, b) => b.verified.toString().compareTo(a.verified.toString()));
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
                          DataColumn(
                            label: const Text(
                              "Assigned",
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
                          const DataColumn(
                            label: Text(
                              " ",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: foregroundColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                        source: _DataSource(
                          context,
                          widget.jobs,
                          widget.jobCode,
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
  _DataSource(this.context, this._jobItems, this._jobCode) {
    _jobItems = _jobItems;
    _jobCode = _jobCode;
  }

  final BuildContext context;
  List<JobItem> _jobItems;
  String _jobCode;
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
        if (jobItem.selected != value) {
          _selectedCount += value! ? 1 : -1;
          jobItem.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(
          Text(
            jobItem.material.code,
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItem.material.description,
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItem.requiredWeight.toString() +
                " " +
                jobItem.uom.code.toUpperCase(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItem.assigned.toString().toUpperCase(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItem.complete.toString().toUpperCase(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItem.verified.toString().toUpperCase(),
            style: const TextStyle(
              fontSize: 16.0,
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            "Print Label",
            style: TextStyle(
              fontSize: 16.0,
              color: jobItem.complete ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            jobItem.complete
                ? await appStore.jobWeighingApp
                    .list(jobItem.id)
                    .then((response) {
                    if (response.containsKey("status")) {
                      if (response["status"]) {
                        for (var item in response["payload"]) {
                          JobItemWeighing jobItemWeighing =
                              JobItemWeighing.fromJSON(item);
                          Map<String, dynamic> printingData = {
                            "job_code": _jobCode,
                            "job_id": jobItemWeighing.jobItem.jobID,
                            "weigher": jobItemWeighing.createdBy.firstName +
                                " " +
                                jobItemWeighing.createdBy.lastName,
                            "material_code":
                                jobItemWeighing.jobItem.material.code,
                            "material_description":
                                jobItemWeighing.jobItem.material.description,
                            "weight": jobItemWeighing.weight,
                            "uom": jobItemWeighing.jobItem.uom.code,
                            "batch": jobItemWeighing.batch,
                            "job_item_id": jobItemWeighing.jobItem.id,
                            "job_item_weighing_id": jobItemWeighing.id,
                          };
                          printingService.printJobItemLabel(printingData);
                        }
                      }
                    }
                  })
                : () {};
          },
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
