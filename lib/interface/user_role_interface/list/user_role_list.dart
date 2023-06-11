import 'package:eazyweigh/domain/entity/user_role.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:flutter/material.dart';

class UserRoleList extends StatefulWidget {
  final List<UserRole> userRoles;
  const UserRoleList({
    Key? key,
    required this.userRoles,
  }) : super(key: key);

  @override
  State<UserRoleList> createState() => _UserRoleListState();
}

class _UserRoleListState extends State<UserRoleList> {
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
          widget.userRoles.sort((a, b) => a.role.toString().compareTo(b.role.toString()));
        } else {
          widget.userRoles.sort((a, b) => b.role.toString().compareTo(a.role.toString()));
        }
        break;
      case 1:
        if (ascending) {
          widget.userRoles.sort((a, b) => a.description.toString().compareTo(b.description.toString()));
        } else {
          widget.userRoles.sort((a, b) => b.description.toString().compareTo(a.description.toString()));
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
          height: 156 + widget.userRoles.length * 56,
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
                              "Role",
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
                              "Description",
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
                        ],
                        source: _DataSource(
                          context,
                          widget.userRoles,
                        ),
                        rowsPerPage: widget.userRoles.length > 25 ? 25 : widget.userRoles.length,
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
  _DataSource(this.context, this._userRoles) {
    _userRoles = _userRoles;
  }

  final BuildContext context;
  List<UserRole> _userRoles;
  // ignore: unused_field
  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final userRole = _userRoles[index];
    return DataRow.byIndex(
      index: index,
      selected: userRole.selected,
      onSelectChanged: (value) {
        if (userRole.selected != value) {
          _selectedCount += value! ? 1 : -1;
          userRole.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(
          Text(
            userRole.role,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            userRole.description,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _userRoles.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
