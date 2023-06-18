import 'dart:convert';

import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/job_item_weighing.dart';
import 'package:eazyweigh/infrastructure/printing_service.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
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
    printingService.addListener(listenToPrintingService);
    super.initState();
  }

  @override
  void dispose() {
    printingService.removeListener(listenToPrintingService);
    super.dispose();
  }

  void listenToPrintingService(String message) {
    Map<String, dynamic> scannerData = jsonDecode(message.replaceAll(";", ":").replaceAll("[", "{").replaceAll("]", "}").replaceAll("'", "\"").replaceAll("-", "_"));
    if (!(scannerData.containsKey("status") && scannerData["status"] == "done")) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomDialog(
            message: "Unable to Print.",
            title: "Error",
          );
        },
      );
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.of(context).pop();
      });
    }
    printingService.close();
  }

  onSortColum(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        if (ascending) {
          widget.jobs.sort((a, b) => a.material.code.toString().compareTo(b.material.code.toString()));
        } else {
          widget.jobs.sort((a, b) => b.material.code.toString().compareTo(a.material.code.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.jobs.sort((a, b) => a.material.description.toString().compareTo(b.material.description.toString()));
        } else {
          widget.jobs.sort((a, b) => b.material.description.toString().compareTo(a.material.description.toString()));
        }
        break;
      case 2:
        if (ascending) {
          widget.jobs.sort((a, b) => a.requiredWeight.toString().compareTo(b.requiredWeight.toString()));
        } else {
          widget.jobs.sort((a, b) => b.requiredWeight.toString().compareTo(a.requiredWeight.toString()));
        }
        break;
      case 3:
        if (ascending) {
          widget.jobs.sort((a, b) => a.material.isWeighed.toString().compareTo(b.material.isWeighed.toString()));
        } else {
          widget.jobs.sort((a, b) => b.material.isWeighed.toString().compareTo(a.material.isWeighed.toString()));
        }
        break;
      case 4:
        if (ascending) {
          widget.jobs.sort((a, b) => a.assigned.toString().compareTo(b.assigned.toString()));
        } else {
          widget.jobs.sort((a, b) => b.assigned.toString().compareTo(a.assigned.toString()));
        }
        break;
      case 5:
        if (ascending) {
          widget.jobs.sort((a, b) => a.complete.toString().compareTo(b.complete.toString()));
        } else {
          widget.jobs.sort((a, b) => b.complete.toString().compareTo(a.complete.toString()));
        }
        break;
      case 6:
        if (ascending) {
          widget.jobs.sort((a, b) => a.verified.toString().compareTo(b.verified.toString()));
        } else {
          widget.jobs.sort((a, b) => b.verified.toString().compareTo(a.verified.toString()));
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
                    cardColor: themeChanged.value ? backgroundColor : foregroundColor,
                    dividerColor: themeChanged.value ? foregroundColor.withOpacity(0.25) : backgroundColor.withOpacity(0.25),
                    textTheme: TextTheme(
                      bodySmall: TextStyle(
                        color: themeChanged.value ? foregroundColor : backgroundColor,
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
                              "Material",
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
                              "Material Name",
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
                              "Quantity",
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
                              "Weighed",
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
                              "Assigned",
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
                              "Complete",
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
                              " ",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeChanged.value ? foregroundColor : backgroundColor,
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
                          printingService,
                        ),
                        rowsPerPage: widget.jobs.length > 25 ? 25 : widget.jobs.length,
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
    return ValueListenableBuilder(
      valueListenable: themeChanged,
      builder: (_, theme, child) {
        return listDetailsWidget();
      },
    );
  }
}

class _DataSource extends DataTableSource {
  _DataSource(
    this.context,
    this._jobItems,
    this._jobCode,
    this._printingService,
  ) {
    _jobItems = _jobItems;
    _jobCode = _jobCode;
    _printingService = _printingService;
  }

  final BuildContext context;
  List<JobItem> _jobItems;
  String _jobCode;
  PrintingService _printingService;
  // ignore: unused_field
  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final jobItem = _jobItems[index];
    return DataRow.byIndex(
      index: index,
      selected: jobItem.selected,
      color: jobItem.material.isWeighed ? MaterialStateProperty.all(Colors.transparent) : MaterialStateProperty.all(Colors.grey),
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
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItem.material.description,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            jobItem.requiredWeight.toStringAsFixed(3) + " " + jobItem.uom.code.toUpperCase(),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          jobItem.material.isWeighed
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
          jobItem.complete
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
          jobItem.verified
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
            "Print Label",
            style: TextStyle(
              fontSize: 16.0,
              color: jobItem.complete ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            jobItem.complete
                ? await appStore.jobWeighingApp.list(jobItem.id).then((response) async {
                    if (response.containsKey("status")) {
                      if (response["status"]) {
                        await Future.forEach(response["payload"], (dynamic item) async {
                          await Future.value(await JobItemWeighing.fromServer(Map<String, dynamic>.from(item))).then((JobItemWeighing jobItemWeighing) {
                            Map<String, dynamic> printingData = {
                              "job_code": _jobCode,
                              "job_id": jobItemWeighing.jobItem.jobID,
                              "weigher": jobItemWeighing.createdBy.firstName + " " + jobItemWeighing.createdBy.lastName,
                              "material_code": jobItemWeighing.jobItem.material.code,
                              "material_description": jobItemWeighing.jobItem.material.description,
                              "weight": jobItemWeighing.weight,
                              "uom": jobItemWeighing.jobItem.uom.code,
                              "batch": jobItemWeighing.batch,
                              "job_item_id": jobItemWeighing.jobItem.id,
                              "job_item_weighing_id": jobItemWeighing.id,
                            };

                            if (jobItemWeighing.jobItem.complete) {
                              printingData["complete"] = true;
                            }

                            printingService.printJobItemLabel(printingData);
                          });
                        });
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
