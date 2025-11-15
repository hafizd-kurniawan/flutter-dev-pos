import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class DialogSearchPrinter extends StatefulWidget {
  final Function(String) onSelected;
  const DialogSearchPrinter({
    super.key,
    required this.onSelected,
  });

  @override
  State<DialogSearchPrinter> createState() => _DialogSearchPrinterState();
}

class _DialogSearchPrinterState extends State<DialogSearchPrinter> {
  String macName = '';
  String? macConnected;

  bool connected = false;
  List<BluetoothInfo> items = [];

  Future<void> getBluetoots() async {
    setState(() {
      items = [];
    });
    if (!mounted) return;
    final bool result = await PrintBluetoothThermal.bluetoothEnabled;

    var status2 = await Permission.bluetoothScan.status;
    log("Permession: $status2");
    if (status2.isDenied) {
      await Permission.bluetoothScan.request();
    }
    var status = await Permission.bluetoothConnect.status;
    if (status.isDenied) {
      await Permission.bluetoothConnect.request();
    }

    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    log("listResult: $listResult");
    setState(() {
      items = listResult;
    });
  }

  Future<void> connect(String mac) async {
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    if (result) {
      widget.onSelected(mac);
    }

    // AuthLocalDatasource().savePrinter(mac);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Printer connected with Name $mac'),
    //     backgroundColor: AppColors.primary,
    //   ),
    // );
  }

  @override
  void initState() {
    loadPermession();
    getBluetoots();
    super.initState();
  }

  loadPermession() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
    ].request();

    log("statuses: $statuses");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Search Printer'),
      content: SizedBox(
        width: context.deviceWidth / 2,
        child: items.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              )
            : SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index].name),
                      subtitle: Text(items[index].macAdress),
                      onTap: () {
                        connect(items[index].macAdress);
                        widget.onSelected(items[index].macAdress);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
