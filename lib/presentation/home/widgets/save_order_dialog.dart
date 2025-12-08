import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/data/dataoutputs/print_dataoutputs.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../table/blocs/get_table/get_table_bloc.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/order/order_bloc.dart';

class SaveOrderDialog extends StatefulWidget {
  const SaveOrderDialog({
    super.key,
    required this.data,
    required this.totalQty,
    required this.totalPrice,
    required this.totalTax,
    required this.totalDiscount,
    required this.subTotal,
    required this.normalPrice,
    required this.table,
    required this.draftName,
    this.orderNote, // NEW
  });
  final List<ProductQuantity> data;
  final int totalQty;
  final int totalPrice;
  final int totalTax;
  final int totalDiscount;
  final int subTotal;
  final int normalPrice;
  final TableModel table;
  final String draftName;
  final String? orderNote; // NEW

  @override
  State<SaveOrderDialog> createState() => _SaveOrderDialogState();
}

class _SaveOrderDialogState extends State<SaveOrderDialog> {
  // List<ProductQuantity> data = [];
  // int totalQty = 0;
  // int totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Assets.icons.success.svg()),
            const SpaceHeight(16.0),
            const Center(
              child: Text(
                'Order Berhasil Disimpan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SpaceHeight(20.0),
            Row(
              children: [
                Flexible(
                  child: Button.outlined(
                    onPressed: () {
                      context
                          .read<CheckoutBloc>()
                          .add(const CheckoutEvent.started());
                      context
                          .read<GetTableBloc>()
                          .add(const GetTableEvent.getTables());
                      context.popToRoot();
                    },
                    label: 'Kembali',
                  ),
                ),
                const SpaceWidth(8.0),
                Flexible(
                  child: Button.filled(
                    onPressed: () async {
                      final checkerPrinter = await ProductLocalDatasource
                          .instance
                          .getPrinterByCode('checker');
                      final kitchenPrinter = await ProductLocalDatasource
                          .instance
                          .getPrinterByCode('kitchen');
                      final barPrinter = await ProductLocalDatasource.instance
                          .getPrinterByCode('bar');
                      //await AuthLocalDataSource().getSizeReceipt();
                      log("Checker printer: ${checkerPrinter?.toMap()}");
                      log("Kitchen printer: ${kitchenPrinter?.toMap()}");
                      log("Bar printer: ${barPrinter?.toMap()}");
                      // checker printer
                      //await AuthLocalDataSource().getSizeReceipt();
                      // final printValue = await PrintDataoutputs.instance
                      //     .printChecker(widget.data, widget.table.id ?? 0,
                      //         widget.draftName, 'Cashier Ali', 80);
                      // // await PrintBluetoothThermal.writeBytes(printValue);
                      // final printer = PrinterNetworkManager('192.168.123.100');
                      // PosPrintResult connect = await printer.connect();
                      // log("message")
                      // if (connect == PosPrintResult.success) {
                      //   PosPrintResult printing =
                      //       await printer.printTicket(printValue);

                      //   print(printing.msg);
                      // } else {
                      //   log("Failed to connect to printer");
                      // }
                      if (checkerPrinter != null) {
                        final printValue = await PrintDataoutputs.instance
                            .printChecker(
                                widget.data,
                                widget.table.tableName,
                                widget.draftName,
                                'HayoPOS',
                                checkerPrinter.paper.toIntegerFromText,
                                widget.orderNote ?? '', // NEW
                                );
                        if (checkerPrinter.type == 'Bluetooth') {
                          await PrintBluetoothThermal.connect(
                              macPrinterAddress: checkerPrinter.address);
                          await PrintBluetoothThermal.writeBytes(printValue);
                        } else {
                          final printer =
                              PrinterNetworkManager(checkerPrinter.address);
                          PosPrintResult connect = await printer.connect();
                          if (connect == PosPrintResult.success) {
                            PosPrintResult printing =
                                await printer.printTicket(printValue);

                            print(printing.msg);
                            printer.disconnect();
                          } else {
                            log("Failed to connect to printer");
                          }
                        }
                      }

                      if (kitchenPrinter != null) {
                        final printValue =
                            await PrintDataoutputs.instance.printKitchen(
                          widget.data,
                          widget.table.tableName,
                          widget.draftName,
                          'HayoPOS',
                          kitchenPrinter.paper.toIntegerFromText,
                          'Dine In', // Default for SaveOrder
                          widget.table.tableName,
                          widget.orderNote ?? '', // Pass Global Note
                        );
                        if (kitchenPrinter!.type == 'Bluetooth') {
                          await PrintBluetoothThermal.connect(
                              macPrinterAddress: kitchenPrinter.address);
                          await PrintBluetoothThermal.writeBytes(printValue);
                        } else {
                          final printer =
                              PrinterNetworkManager(kitchenPrinter.address);
                          PosPrintResult connect = await printer.connect();
                          if (connect == PosPrintResult.success) {
                            PosPrintResult printing =
                                await printer.printTicket(printValue);
                            printer.disconnect();
                          } else {
                            log("Failed to connect to printer");
                          }
                        }
                      }

                      // bar printer
                      if (barPrinter != null) {
                        final printValue =
                            await PrintDataoutputs.instance.printBar(
                          widget.data,
                          widget.table.tableName,
                          widget.draftName,
                          'HayoPOS',
                          barPrinter.paper.toIntegerFromText,
                          widget.orderNote ?? '', // NEW
                        );
                        if (barPrinter!.type == 'Bluetooth') {
                          await PrintBluetoothThermal.connect(
                              macPrinterAddress: barPrinter.address);
                          await PrintBluetoothThermal.writeBytes(printValue);
                        } else {
                          final printer =
                              PrinterNetworkManager(barPrinter.address);
                          PosPrintResult connect = await printer.connect();
                          log("connect: ${connect.msg}");
                          if (connect == PosPrintResult.success) {
                            PosPrintResult printing =
                                await printer.printTicket(printValue);
                            printer.disconnect();
                          } else {
                            log("Failed to connect to printer");
                          }
                        }
                      }
                    },
                    label: 'Print Checker',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
