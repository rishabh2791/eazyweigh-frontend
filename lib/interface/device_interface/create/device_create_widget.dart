import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/device_type.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/custom_dialog.dart';
import 'package:eazyweigh/interface/common/drop_down_widget.dart';
import 'package:eazyweigh/interface/common/file_picker/file_picker.dart';
import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:eazyweigh/interface/device_interface/create/dropdowns.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

class DeviceCreateWidget extends StatefulWidget {
  const DeviceCreateWidget({Key? key}) : super(key: key);

  @override
  State<DeviceCreateWidget> createState() => _DeviceCreateWidgetState();
}

class _DeviceCreateWidgetState extends State<DeviceCreateWidget> {
  bool isLoadingData = true;
  List<Factory> factories = [];
  List<Vessel> factoryVessels = [];
  List<DeviceType> factoryDeviceTypes = [];
  late FilePickerResult? file;

  late TextEditingController nodeAddressController,
      additionalNodeAddressController,
      readStartController,
      baudRateController,
      byteSizeController,
      stopBitsController,
      timeoutController,
      messageLengthController,
      clearBufferController,
      closePortController,
      commMethodController,
      factoryController,
      vesselController,
      deviceTypeController,
      fileController,
      portController,
      isConstantController,
      constantValueController,
      factorController;

  @override
  void initState() {
    super.initState();
    getFactories();
    nodeAddressController = TextEditingController();
    additionalNodeAddressController = TextEditingController();
    readStartController = TextEditingController();
    baudRateController = TextEditingController();
    byteSizeController = TextEditingController();
    stopBitsController = TextEditingController();
    timeoutController = TextEditingController();
    messageLengthController = TextEditingController();
    clearBufferController = TextEditingController();
    clearBufferController.text = "1";
    closePortController = TextEditingController();
    closePortController.text = "1";
    commMethodController = TextEditingController();
    vesselController = TextEditingController();
    deviceTypeController = TextEditingController();
    fileController = TextEditingController();
    portController = TextEditingController();
    isConstantController = TextEditingController();
    isConstantController.text = "0";
    constantValueController = TextEditingController();
    factorController = TextEditingController();
    factoryController = TextEditingController();
    factoryController.addListener(getBackendData);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> getFactories() async {
    factories = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "company_id",
        "Value": companyID,
      }
    };
    await appStore.factoryApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          Factory fact = Factory.fromJSON(item);
          factories.add(fact);
        }
        setState(() {
          isLoadingData = false;
        });
      } else {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              message: response["message"],
              title: "Errors",
            );
          },
        );
      }
    });
  }

  Future<dynamic> getBackendData() async {
    setState(() {
      isLoadingData = true;
    });
    await Future.forEach([await getFactoryVessels(), await getFactoryDeviceTypes()], (element) {}).then((value) {
      setState(() {
        isLoadingData = false;
      });
    });
  }

  Future<dynamic> getFactoryVessels() async {
    factoryVessels = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryController.text,
      }
    };
    await appStore.vesselApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          Vessel vessel = Vessel.fromJSON(item);
          factoryVessels.add(vessel);
        }
      }
    });
  }

  Future<dynamic> getFactoryDeviceTypes() async {
    factoryDeviceTypes = [];
    Map<String, dynamic> conditions = {
      "EQUALS": {
        "Field": "factory_id",
        "Value": factoryController.text,
      }
    };
    await appStore.deviceTypeApp.list(conditions).then((response) async {
      if (response["status"]) {
        for (var item in response["payload"]) {
          DeviceType deviceType = DeviceType.fromJSON(item);
          factoryDeviceTypes.add(deviceType);
        }
      }
    });
  }

  getFile(FilePickerResult? result) {
    setState(() {
      file = result;
      fileController.text = result!.files.single.name;
    });
  }

  Widget createWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create New Device",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Factory",
                  controller: factoryController,
                  itemList: factories,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Vessel",
                  controller: vesselController,
                  itemList: factoryVessels,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Select Device Type",
                  controller: deviceTypeController,
                  itemList: factoryDeviceTypes,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Communication Method",
                  controller: commMethodController,
                  itemList: communicationMethods,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textField(false, portController, "Communication Port", false),
                Row(
                  children: [
                    Container(
                      height: 60.0,
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Transform.scale(
                        scale: 2.0,
                        child: Checkbox(
                          value: isConstantController.text == "1" ? true : false,
                          fillColor: MaterialStateProperty.all(menuItemColor),
                          activeColor: menuItemColor,
                          onChanged: (bool? value) {
                            setState(
                              () {
                                isConstantController.text = isConstantController.text == "1" ? "0" : "1";
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Is Constant",
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                textField(false, constantValueController, "Constant Value", false),
                textField(false, factorController, "Scaling Factor", false),
                textField(false, nodeAddressController, "Node Address", false),
                textField(false, additionalNodeAddressController, "Additional Node Address", false),
                textField(false, readStartController, "Read Start Register Address", false),
                DropDownWidget(
                  disabled: false,
                  hint: "Baud Rate",
                  controller: baudRateController,
                  itemList: baudRateValues,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Byte Size",
                  controller: byteSizeController,
                  itemList: byteSizeValues,
                ),
                DropDownWidget(
                  disabled: false,
                  hint: "Stop Bits",
                  controller: stopBitsController,
                  itemList: stopBitValues,
                ),
                textField(false, timeoutController, "Timeout", false),
                textField(false, messageLengthController, "Message Length (Bytes to Read)", false),
                Row(
                  children: [
                    Container(
                      height: 60.0,
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Transform.scale(
                        scale: 2.0,
                        child: Checkbox(
                          value: clearBufferController.text == "1" ? true : false,
                          fillColor: MaterialStateProperty.all(menuItemColor),
                          activeColor: menuItemColor,
                          onChanged: (bool? value) {
                            setState(
                              () {
                                clearBufferController.text = clearBufferController.text == "1" ? "0" : "1";
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Clear Buffer Before Each Transaction",
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 60.0,
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Transform.scale(
                        scale: 2.0,
                        child: Checkbox(
                          value: closePortController.text == "1" ? true : false,
                          fillColor: MaterialStateProperty.all(menuItemColor),
                          activeColor: menuItemColor,
                          onChanged: (bool? value) {
                            setState(
                              () {
                                closePortController.text = closePortController.text == "1" ? "0" : "1";
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Close Port After Each Call",
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () async {
                        Map<String, dynamic> postData = {};
                        var vesselID = vesselController.text;
                        var deviceTypeID = deviceTypeController.text;
                        var commMethod = commMethodController.text;
                        var commPort = portController.text;
                        var isConstant = isConstantController.text;
                        var constantValue = constantValueController.text;
                        var scalingfactor = factorController.text;
                        var nodeAddress = nodeAddressController.text;
                        var additionalNodeAddress = additionalNodeAddressController.text;
                        var readStart = readStartController.text;
                        var baudRate = baudRateController.text;
                        var byteSize = byteSizeController.text;
                        var stopBits = stopBitsController.text;
                        var timeout = timeoutController.text;
                        var messageLength = messageLengthController.text;
                        var clearBuffer = clearBufferController.text;
                        var closePort = closePortController.text;

                        String errors = "";

                        //TODO check all fields
                        if (vesselID.isEmpty) {
                          errors += "Vessel Missing.\n";
                        } else {
                          postData["vessel_id"] = vesselID;
                        }

                        if (deviceTypeID.isEmpty) {
                          errors += "Device Type Missing.\n";
                        } else {
                          postData["device_type_id"] = deviceTypeID;
                        }

                        if (commMethod.isEmpty) {
                          errors += "Communication Method Missing.\n";
                        } else {
                          postData["communication_method"] = commMethod;
                        }

                        if (commMethod.isNotEmpty) {
                          postData["port"] = commPort;
                        }

                        if (isConstant == "1" && constantValue.isEmpty) {
                          errors += "Constant Value Missing for Constant Value Device.\n";
                        } else {
                          try {
                            if (isConstant == "1") {
                              postData["constant_value"] = double.parse(constantValue);
                            }
                          } catch (e) {
                            errors += "Constant Value is not a Number.\n";
                          }
                        }

                        if (scalingfactor.isNotEmpty) {
                          try {
                            postData["factor"] = int.parse(scalingfactor);
                          } catch (e) {
                            errors += "Scaling Factor is not a Number.\n";
                          }
                        }

                        if (nodeAddress.isNotEmpty) {
                          try {
                            postData["node_address"] = int.parse(nodeAddress);
                          } catch (e) {
                            errors += "Node Address is not a Number.\n";
                          }
                        }

                        if (additionalNodeAddress.isNotEmpty) {
                          try {
                            postData["additional_node_address"] = int.parse(additionalNodeAddress);
                          } catch (e) {
                            errors += "Additional Node Address is not a Number.\n";
                          }
                        }

                        if (readStart.isNotEmpty) {
                          try {
                            postData["read_start"] = int.parse(readStart);
                          } catch (e) {
                            errors += "Read Start is not a Number.\n";
                          }
                        }

                        if (baudRate.isNotEmpty) {
                          try {
                            postData["baud_rate"] = int.parse(baudRate);
                          } catch (e) {
                            errors += "Baud Rate is not a Number.\n";
                          }
                        }

                        if (byteSize.isNotEmpty) {
                          try {
                            postData["byte_size"] = int.parse(byteSize);
                          } catch (e) {
                            errors += "Byte Size is not a Number.\n";
                          }
                        }

                        if (stopBits.isNotEmpty) {
                          try {
                            postData["stop_bits"] = int.parse(stopBits);
                          } catch (e) {
                            errors += "Stop Bits is not a Number.\n";
                          }
                        }

                        if (timeout.isNotEmpty) {
                          try {
                            postData["time_out"] = double.parse(timeout);
                          } catch (e) {
                            errors += "Timeout is not a Number.\n";
                          }
                        }

                        if (messageLength.isNotEmpty) {
                          try {
                            postData["message_length"] = int.parse(messageLength);
                          } catch (e) {
                            errors += "Message Length is not a Number.\n";
                          }
                        }

                        postData["clear_buffers_before_each_transaction"] = clearBuffer == "1" ? true : false;
                        postData["close_port_after_each_call"] = closePort == "1" ? true : false;

                        if (errors.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                message: errors,
                                title: "Errors",
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return loader(context);
                            },
                          );

                          await appStore.deviceApp.create(postData).then((response) async {
                            if (response["status"]) {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                    message: "Device Created",
                                    title: "Info",
                                  );
                                },
                              );
                              factoryController.text = "";
                              vesselController.text = "";
                              commMethodController.text = "";
                              portController.text = "";
                              isConstantController.text = "";
                              constantValueController.text = "";
                              factorController.text = "";
                              nodeAddressController.text = "";
                              additionalNodeAddressController.text = "";
                              readStartController.text = "";
                              baudRateController.text = "";
                              byteSizeController.text = "";
                              stopBitsController.text = "";
                              timeoutController.text = "";
                              messageLengthController.text = "";
                              clearBufferController.text = "";
                              closePortController.text = "";
                            } else {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                    message: response["message"],
                                    title: "Errors",
                                  );
                                },
                              );
                            }
                          });
                        }
                      },
                      child: checkButton(),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                        elevation: MaterialStateProperty.all<double>(5.0),
                      ),
                      onPressed: () {
                        factoryController.text = "";
                        vesselController.text = "";
                        commMethodController.text = "";
                        portController.text = "";
                        isConstantController.text = "";
                        constantValueController.text = "";
                        factorController.text = "";
                        nodeAddressController.text = "";
                        additionalNodeAddressController.text = "";
                        readStartController.text = "";
                        baudRateController.text = "";
                        byteSizeController.text = "";
                        stopBitsController.text = "";
                        timeoutController.text = "";
                        messageLengthController.text = "";
                        clearBufferController.text = "";
                        closePortController.text = "";
                      },
                      child: clearButton(),
                    ),
                  ],
                ),
                const Divider(
                  height: 50.0,
                  color: Colors.transparent,
                ),
                const Text(
                  "Create Multiple New Devices",
                  style: TextStyle(
                    color: formHintTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                FilePickerer(
                  hint: "Select File",
                  label: "Select File",
                  updateParent: getFile,
                  controller: fileController,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(menuItemColor),
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  onPressed: () async {
                    List<Map<String, dynamic>> devices = [];
                    // ignore: prefer_typing_uninitialized_variables
                    var csvData;
                    final path = fileController.text;
                    if (path.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomDialog(
                            message: "Select File...",
                            title: "Errors",
                          );
                        },
                      );
                    } else {
                      if (foundation.kIsWeb) {
                        final bytes = utf8.decode(file!.files.single.bytes!);
                        csvData = const CsvToListConverter().convert(bytes);
                      } else {
                        final csvFile = File(file!.files.single.path.toString()).openRead();
                        csvData = await csvFile
                            .transform(utf8.decoder)
                            .transform(
                              const CsvToListConverter(),
                            )
                            .toList();
                      }
                      csvData.forEach((element) {
                        //TODO correct this.
                        Map<String, dynamic> device = {
                          "name": element[1],
                          "vessel_id": element[0],
                        };
                        devices.add(device);
                      });
                      await appStore.deviceApp.createMultiple(devices).then((response) {
                        if (response.containsKey("status") && response["status"]) {
                          int created = response["payload"]["models"].length;
                          int notCreated = response["payload"]["errors"].length;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                message: "Created " + created.toString() + " devices." + (notCreated != 0 ? "Unable to create " + notCreated.toString() + " devices." : ""),
                                title: "Info",
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                message: "Unable to Create Devices",
                                title: "Errors",
                              );
                            },
                          );
                        }
                      });
                    }
                  },
                  child: checkButton(),
                ),
              ],
            ),
          ),
        ],
      ),
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
              createWidget(),
              context,
              "Create Device",
              () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}
