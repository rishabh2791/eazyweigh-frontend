import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/shift_schedule.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/user_action_button/user_action_button.dart';
import 'package:flutter/material.dart';

class ShiftScheduleList extends StatefulWidget {
  final List<ShiftSchedule> shiftSchedules;
  const ShiftScheduleList({
    Key? key,
    required this.shiftSchedules,
  }) : super(key: key);

  @override
  State<ShiftScheduleList> createState() => _ShiftScheduleListState();
}

class _ShiftScheduleListState extends State<ShiftScheduleList> {
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
          widget.shiftSchedules.sort((a, b) => a.date.compareTo(b.date));
        } else {
          widget.shiftSchedules.sort((a, b) => b.date.compareTo(a.date));
        }
        break;
      case 1:
        if (ascending) {
          widget.shiftSchedules
              .sort((a, b) => a.shift.code.compareTo(b.shift.code));
        } else {
          widget.shiftSchedules
              .sort((a, b) => b.shift.code.compareTo(a.shift.code));
        }
        break;
      case 2:
        if (ascending) {
          widget.shiftSchedules.sort((a, b) =>
              (a.weigher.firstName + " " + a.weigher.lastName)
                  .compareTo((b.weigher.firstName + " " + b.weigher.lastName)));
        } else {
          widget.shiftSchedules.sort((a, b) =>
              (b.weigher.firstName + " " + b.weigher.lastName)
                  .compareTo((a.weigher.firstName + " " + a.weigher.lastName)));
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
          height: 156 + widget.shiftSchedules.length * 56,
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
                              "Date",
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
                              "Weigher",
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
                              " ",
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
                        source: _DataSource(context, widget.shiftSchedules),
                        rowsPerPage: widget.shiftSchedules.length > 25
                            ? 25
                            : widget.shiftSchedules.length,
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
  _DataSource(this.context, this._shiftSchedules) {
    _shiftSchedules = _shiftSchedules;
  }

  final BuildContext context;
  List<ShiftSchedule> _shiftSchedules;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final shiftSchedule = _shiftSchedules[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            shiftSchedule.date.toLocal().toString().substring(0, 10),
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            shiftSchedule.shift.code,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            shiftSchedule.weigher.firstName +
                " " +
                shiftSchedule.weigher.lastName,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            shiftSchedule.date.difference(DateTime.now()) >
                    const Duration(seconds: 0)
                ? "Delete"
                : " ",
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          onTap: () async {
            String accessCode = getAccessCode("shift_schedules", "create");
            if (accessCode == "1" &&
                shiftSchedule.date.difference(DateTime.now()) >
                    const Duration(seconds: 0)) {
              await appStore.shiftScheduleApp
                  .delete(shiftSchedule.id)
                  .then((value) {
                if (value.containsKey("status") && value["status"]) {
                  _shiftSchedules
                      .removeWhere((element) => element.id == shiftSchedule.id);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const CustomDialog(
                        message: "Unable to Delete Shift Schedule.",
                        title: "Error",
                      );
                    },
                  );
                }
              });
            }
          },
        ),
      ],
    );
  }

  @override
  int get rowCount => _shiftSchedules.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
