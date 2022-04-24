import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/address.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class AddressListWidget extends StatefulWidget {
  const AddressListWidget({Key? key}) : super(key: key);

  @override
  State<AddressListWidget> createState() => _AddressListWidgetState();
}

class _AddressListWidgetState extends State<AddressListWidget> {
  bool isLoadingData = true;
  List<Address> addresses = [];

  @override
  void initState() {
    getAddresses();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAddresses() async {
    Map<String, dynamic> condition = {
      "EQUALS": {
        "Field": "company_id",
        "Value": companyID,
      }
    };
    await appStore.addressApp.list(condition).then((response) async {
      if (response.containsKey("status")) {
        if (response["status"]) {
          for (var item in response["payload"]) {
            Address address = Address.fromJSON(item);
            addresses.add(address);
          }
        }
      } else {}
    }).then((value) {
      setState(() {
        isLoadingData = false;
      });
    });
  }

  List<Widget> getRows() {
    List<Widget> widgets = [];
    for (var address in addresses) {
      Widget widget = Container(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 10), blurRadius: 10),
          ],
        ),
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.line1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            Text(
              address.line2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            Text(
              address.city,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            Text(
              address.zip,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            Text(
              address.state,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            Text(
              address.country,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      );
      widgets.add(widget);
    }
    return widgets;
  }

  Widget listWidget() {
    return addresses.isEmpty
        ? const Center(
            child: Text("No Addresses Found."),
          )
        : Column(
            children: getRows(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingData
        ? SuperPage(
            childWidget: loader(context),
          )
        : SuperPage(
            childWidget: buildWidget(
              listWidget(),
              context,
              "List Addresses",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
