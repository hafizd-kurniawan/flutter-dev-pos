// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/data/dataoutputs/laman_print.dart';
import 'package:flutter_posresto_app/data/dataoutputs/print_dataoutputs.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/pos_settings_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../table/blocs/get_table/get_table_bloc.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/local_product/local_product_bloc.dart';
import '../bloc/order/order_bloc.dart';
import '../bloc/pos_settings/pos_settings_bloc.dart';

class SuccessPaymentDialog extends StatefulWidget {
  const SuccessPaymentDialog({
    Key? key,
    required this.data,
    required this.totalQty,
    required this.totalPrice,
    required this.totalTax,
    required this.totalDiscount,
    required this.subTotal,
    required this.normalPrice,
    required this.totalService,
    required this.draftName,
    this.isTablePaymentPage = false,
  }) : super(key: key);
  final List<ProductQuantity> data;
  final int totalQty;
  final int totalPrice;
  final int totalTax;
  final int totalDiscount;
  final int subTotal;
  final int normalPrice;
  final int totalService;
  final String draftName;
  final bool? isTablePaymentPage;
  @override
  State<SuccessPaymentDialog> createState() => _SuccessPaymentDialogState();
}

class _SuccessPaymentDialogState extends State<SuccessPaymentDialog> {
  // List<ProductQuantity> data = [];
  // int totalQty = 0;
  // int totalPrice = 0;
  
  /// Reload saved tax & service settings from local storage and apply to CheckoutBloc
  Future<void> _reloadSavedSettings(BuildContext context) async {
    try {
      final localDatasource = PosSettingsLocalDatasource();
      
      // Get saved tax ID
      final taxId = await localDatasource.getSelectedTaxId();
      
      // Get saved service ID
      final serviceId = await localDatasource.getSelectedServiceId();
      
      // Get PosSettings to find tax & service values
      final posSettingsState = context.read<PosSettingsBloc>().state;
      
      posSettingsState.maybeWhen(
        orElse: () {},
        loaded: (settings) {
          // Apply saved tax if exists
          if (taxId != null) {
            final tax = settings.taxes.firstWhere((t) => t.id == taxId, orElse: () => settings.taxes.first);
            context.read<CheckoutBloc>().add(CheckoutEvent.addTax(tax.value.toInt()));
            log('✅ Restored tax: ${tax.name} = ${tax.value}%');
          }
          
          // Apply saved service if exists
          if (serviceId != null) {
            final service = settings.services.firstWhere((s) => s.id == serviceId, orElse: () => settings.services.first);
            context.read<CheckoutBloc>().add(CheckoutEvent.addServiceCharge(service.value.toInt()));
            log('✅ Restored service: ${service.name} = ${service.value}%');
          }
        },
      );
    } catch (e) {
      log('❌ Error reloading saved settings: $e');
    }
  }
  
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
                'Pembayaran telah sukses dilakukan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SpaceHeight(20.0),
            const Text('METODE BAYAR'),
            const SpaceHeight(5.0),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                final paymentMethod = state.maybeWhen(
                  orElse: () => 'Cash',
                  loaded: (model, orderId) => model.paymentMethod,
                );
                return Text(
                  paymentMethod,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('TOTAL TAGIHAN'),
            const SpaceHeight(5.0),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                final total = state.maybeWhen(
                  orElse: () => 0,
                  loaded: (model, orderId) => model.total,
                );
                return Text(
                  widget.totalPrice.currencyFormatRp,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('NOMINAL BAYAR'),
            const SpaceHeight(5.0),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                log("🔍 OrderBloc State Type: ${state.runtimeType}");
                
                final paymentAmount = state.maybeWhen(
                  orElse: () {
                    log("⚠️ OrderBloc state is NOT loaded, using 0");
                    return 0;
                  },
                  loaded: (model, orderId) {
                    log("✅ OrderBloc LOADED - paymentAmount: ${model.paymentAmount}");
                    return model.paymentAmount;
                  },
                );
                
                log("💰 Final Payment Amount to display: $paymentAmount");
                
                return Text(
                  paymentAmount.currencyFormatRp,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                );
              },
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('KEMBALIAN'),
            const SpaceHeight(5.0),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                log("🔍 KEMBALIAN - OrderBloc State Type: ${state.runtimeType}");
                
                final paymentAmount = state.maybeWhen(
                  orElse: () {
                    log("⚠️ KEMBALIAN - State NOT loaded, paymentAmount = 0");
                    return 0;
                  },
                  loaded: (model, orderId) {
                    log("✅ KEMBALIAN - Got paymentAmount: ${model.paymentAmount}");
                    return model.paymentAmount;
                  },
                );
                
                final total = state.maybeWhen(
                  orElse: () {
                    log("⚠️ KEMBALIAN - State NOT loaded, total = 0");
                    return 0;
                  },
                  loaded: (model, orderId) {
                    log("✅ KEMBALIAN - Got total: ${model.total}");
                    return model.total;
                  },
                );
                
                final kembalian = paymentAmount - total;
                
                log("💵 KEMBALIAN FINAL Calculation:");
                log("   Payment Amount: $paymentAmount");
                log("   Total: $total");
                log("   Kembalian: $kembalian");
                
                return Text(
                  kembalian.currencyFormatRp,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: kembalian < 0 ? Colors.red : Colors.green,
                  ),
                );
              },
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('WAKTU PEMBAYARAN'),
            const SpaceHeight(5.0),
            Text(
              DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now()),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SpaceHeight(20.0),
            Row(
              children: [
                Flexible(
                  child: Button.outlined(
                    onPressed: () async {
                      log('🔙 Kembali button pressed - Clearing items, keeping settings, refreshing products...');
                      
                      // 1. Clear ONLY cart items, KEEP tax/service/discount settings
                      context
                          .read<CheckoutBloc>()
                          .add(const CheckoutEvent.clearItems());
                      
                      // 2. Refresh table list
                      context
                          .read<GetTableBloc>()
                          .add(const GetTableEvent.getTables());
                      
                      // 3. Refresh products to update stock
                      context
                          .read<LocalProductBloc>()
                          .add(const LocalProductEvent.getLocalProduct());
                      log('🔄 Refreshing products to update stock...');
                      
                      // 4. Navigate back to home
                      if (context.mounted) {
                        log('✅ Navigating to home with settings preserved and products refreshed...');
                        context.popToRoot();
                      }
                    },
                    label: 'Kembali',
                  ),
                ),
                const SpaceWidth(8.0),
                Flexible(
                  child: BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) {
                      final paymentAmount = state.maybeWhen(
                        orElse: () => 0,
                        loaded: (model, orderId) => model.paymentAmount,
                      );

                      final kembalian = paymentAmount - widget.totalPrice;
                      return Button.filled(
                        onPressed: () async {
                          final receiptPrinter = await ProductLocalDatasource
                              .instance
                              .getPrinterByCode('receipt');
                          final kitchenPrinter = await ProductLocalDatasource
                              .instance
                              .getPrinterByCode('kitchen');
                          final barPrinter = await ProductLocalDatasource
                              .instance
                              .getPrinterByCode('bar');
                          // final sizeReceipt = '58';
                          // await AuthLocalDataSource().getSizeReceipt();

                          // await LamanPrint.instance.printOrderV3(
                          //   widget.data,
                          //   widget.totalQty,
                          //   widget.totalPrice,
                          //   'Cash',
                          //   paymentAmount,
                          //   kembalian,
                          //   widget.totalTax,
                          //   widget.totalDiscount,
                          //   widget.subTotal,
                          //   1,
                          //   'Cashier Ali',
                          //   widget.draftName,
                          //   int.parse(sizeReceipt),
                          // );

                          // Receipt Printer
                          if (receiptPrinter != null) {
                            final printValue =
                                await PrintDataoutputs.instance.printOrderV3(
                              widget.data,
                              widget.totalQty,
                              widget.totalPrice,
                              'Cash',
                              paymentAmount,
                              kembalian,
                              widget.totalTax,
                              widget.totalDiscount,
                              widget.subTotal,
                              1,
                              'Cashier Bahri',
                              widget.draftName,
                              receiptPrinter.paper.toIntegerFromText,
                            );
                            if (receiptPrinter!.type == 'Bluetooth') {
                              await PrintBluetoothThermal.writeBytes(
                                  printValue);
                            } else {
                              final printer =
                                  PrinterNetworkManager(receiptPrinter.address);
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

                          // Kitchen Printer
                          if (kitchenPrinter != null &&
                              widget.isTablePaymentPage == false) {
                            final printValue =
                                await PrintDataoutputs.instance.printKitchen(
                              widget.data,
                              '',
                              widget.draftName,
                              'Cashier Bahri',
                              kitchenPrinter.paper.toIntegerFromText,
                            );
                            if (kitchenPrinter!.type == 'Bluetooth') {
                              await PrintBluetoothThermal.writeBytes(
                                  printValue);
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
                          if (barPrinter != null &&
                              widget.isTablePaymentPage == false) {
                            final printValue =
                                await PrintDataoutputs.instance.printBar(
                              widget.data,
                              '',
                              widget.draftName,
                              'Cashier Bahri',
                              barPrinter.paper.toIntegerFromText,
                            );
                            if (barPrinter!.type == 'Bluetooth') {
                              await PrintBluetoothThermal.writeBytes(
                                  printValue);
                            } else {
                              final printer =
                                  PrinterNetworkManager(barPrinter.address);
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
                        },
                        label: 'Print',
                      );
                    },
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
