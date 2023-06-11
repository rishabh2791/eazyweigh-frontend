import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/base_widget.dart';
import 'package:eazyweigh/interface/factory_interface/details/details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FactoriesListWidget extends StatefulWidget {
  final List<Factory> factories;
  const FactoriesListWidget({
    Key? key,
    required this.factories,
  }) : super(key: key);

  @override
  State<FactoriesListWidget> createState() => _FactoriesListWidgetState();
}

class _FactoriesListWidgetState extends State<FactoriesListWidget> {
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
          widget.factories.sort((a, b) => a.name.compareTo(b.name));
        } else {
          widget.factories.sort((a, b) => b.name.compareTo(a.name));
        }
        break;
      case 1:
        if (ascending) {
          widget.factories.sort((a, b) => a.address.line1.compareTo(b.address.line1));
        } else {
          widget.factories.sort((a, b) => b.address.line1.compareTo(a.address.line1));
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
                    dividerColor: themeChanged.value ? foregroundColor : backgroundColor,
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
                              "Factory Name",
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
                              "Address",
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
                        source: _DataSource(context, widget.factories),
                        rowsPerPage: widget.factories.length > 25 ? 25 : widget.factories.length,
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
  _DataSource(this.context, this._factories) {
    _factories = _factories;
  }

  final BuildContext context;
  List<Factory> _factories;
  // ignore: unused_field
  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final fact = _factories[index];
    return DataRow.byIndex(
      index: index,
      selected: fact.selected,
      onSelectChanged: (value) {
        if (fact.selected != value) {
          _selectedCount += value! ? 1 : -1;
          fact.selected = value;
          notifyListeners();
          navigationService.push(
            CupertinoPageRoute(
              builder: (BuildContext context) => FactoryDetailsWidget(
                fact: fact,
              ),
            ),
          );
        }
      },
      cells: [
        DataCell(
          Text(
            fact.name,
            style: TextStyle(
              fontSize: 16.0,
              color: themeChanged.value ? foregroundColor : backgroundColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(
          Text(
            fact.address.line1 + ", " + fact.address.line2 + ", " + fact.address.city + " - " + fact.address.zip + ", " + fact.address.state + ", " + fact.address.country,
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
  int get rowCount => _factories.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
