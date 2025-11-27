// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:share_plus/share_plus.dart'; // NEW: Share Plus

import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/data/dataoutputs/laman_print.dart';
import 'package:flutter_posresto_app/data/dataoutputs/print_dataoutputs.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_storage_helper.dart';
import 'package:flutter_posresto_app/data/datasources/pos_settings_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';
import 'package:flutter_posresto_app/data/datasources/settings_local_datasource.dart'; // NEW

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
    this.paymentAmount, // OPTIONAL with default
    this.isTablePaymentPage = false,
    this.tableName, // NEW: Table name for dine-in
    this.orderType, // NEW: 'dine_in' or 'takeaway'
    this.onPaymentSuccess, // NEW: Callback for success
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
  final int? paymentAmount; // OPTIONAL - use totalPrice as fallback
  final bool? isTablePaymentPage;
  final String? tableName; // NEW: Table name (e.g., "Meja 5")
  final String? orderType; // NEW: Order type (dine_in/takeaway)
  final VoidCallback? onPaymentSuccess; // NEW: Callback
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
            Text(
              'Cash', // Fixed: Cash payment for success dialog
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            // NEW: Show table/order type information
            const Text('TIPE ORDER'),
            const SpaceHeight(5.0),
            Text(
              widget.orderType == 'dine_in' 
                  ? 'Dine In${widget.tableName != null ? " - ${widget.tableName}" : ""}' 
                  : 'Takeaway',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('TOTAL TAGIHAN'),
            const SpaceHeight(5.0),
            Text(
              widget.totalPrice.currencyFormatRp,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('NOMINAL BAYAR'),
            const SpaceHeight(5.0),
            Text(
              (widget.paymentAmount ?? widget.totalPrice).currencyFormatRp,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('KEMBALIAN'),
            const SpaceHeight(5.0),
            Builder(
              builder: (context) {
                final paymentAmt = widget.paymentAmount ?? widget.totalPrice;
                final kembalian = paymentAmt - widget.totalPrice;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kembalian.currencyFormatRp,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: kembalian < 0 ? Colors.red : Colors.green,
                      ),
                    ),
                    if (kembalian < 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '⚠️ Uang kurang!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
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
                  child: Button.filled(
                    onPressed: () async {
                      log('✅ Selesai button pressed - Closing dialog and returning to home...');
                      
                      // 1. Clear ONLY cart items, KEEP tax/service/discount settings
                      context
                          .read<CheckoutBloc>()
                          .add(const CheckoutEvent.clearItems());
                      
                      // 2. ✅ CRITICAL FIX: Reload saved tax & service settings
                      await _reloadSavedSettings(context);
                      log('✅ Tax & Service settings restored from saved preferences');
                      
                      // 3. Refresh table list
                      context
                          .read<GetTableBloc>()
                          .add(const GetTableEvent.getTables());
                      
                      // 4. ✅ CRITICAL FIX: Refresh products from SERVER (not local storage)
                      // This ensures stock is updated after order
                      log('🔄 Fetching fresh products from server...');
                      final productRemote = ProductRemoteDatasource();
                      final productResult = await productRemote.getProducts();
                      
                      await productResult.fold(
                        (error) {
                          log('⚠️ Error refreshing products: $error');
                        },
                        (productResponse) async {
                          // Save to storage
                          if (kIsWeb) {
                            await ProductStorageHelper.saveProducts(productResponse.data ?? []);
                          } else {
                            // Mobile: SQLite
                            await context.read<LocalProductBloc>().productLocalDatasource.deleteAllProducts();
                            await context.read<LocalProductBloc>().productLocalDatasource.insertProducts(productResponse.data ?? []);
                          }
                          
                          // Reload products in UI
                          context.read<LocalProductBloc>().add(const LocalProductEvent.getLocalProduct());
                          log('✅ Products refreshed from server: ${productResponse.data?.length ?? 0} items');
                        },
                      );
                      
                      // 5. Trigger callback if provided
                      if (widget.onPaymentSuccess != null) {
                        log('✅ Triggering onPaymentSuccess callback...');
                        widget.onPaymentSuccess!();
                      }
                      
                      // 6. Close dialog and navigate back to home with popToRoot
                      if (context.mounted) {
                        log('✅ AUTO-REDIRECT: Navigating to home using popToRoot...');
                        context.popToRoot();
                        log('✅ Successfully returned to HomePage');
                      }
                    },
                    label: 'Selesai',
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
                            // Calculate percentages
                            final taxPercentage = widget.subTotal > 0 ? ((widget.totalTax / widget.subTotal) * 100).round() : 0;
                            final servicePercentage = widget.subTotal > 0 ? ((widget.totalService / widget.subTotal) * 100).round() : 0;

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
                              taxPercentage,
                              servicePercentage,
                              widget.orderType ?? 'Dine In', // NEW
                              widget.tableName ?? '', // NEW
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
                const SpaceWidth(10.0),
                Flexible(
                  child: Button.outlined(
                    onPressed: () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('📄 Generating PDF...')),
                        );

                        final paymentAmountValue = widget.paymentAmount ?? widget.totalPrice;
                        final kembalian = paymentAmountValue - widget.totalPrice;
                        
                        log('Generating PDF for order...');
                        
                        // Get current user for Cashier Name
                        final authData = await AuthLocalDataSource().getAuthData();
                        final cashierName = authData?.user?.name ?? 'Cashier';

                        // Calculate percentages
                        final taxPercentage = widget.subTotal > 0 ? ((widget.totalTax / widget.subTotal) * 100).round() : 0;
                        final servicePercentage = widget.subTotal > 0 ? ((widget.totalService / widget.subTotal) * 100).round() : 0;

                        final xFile = await PrintDataoutputs.instance.generateReceiptPdf(
                          widget.data,
                          widget.totalQty,
                          widget.totalPrice,
                          'Cash',
                          paymentAmountValue,
                          kembalian,
                          widget.subTotal,
                          widget.totalDiscount,
                          widget.totalTax,
                          widget.totalService,
                          cashierName,
                          widget.draftName,
                          widget.orderType ?? 'Dine In',
                          widget.tableName ?? '', // NEW
                          taxPercentage,
                          servicePercentage,
                        );
                        
                        print('PDF generated at: ${xFile.path}');
                        // Fetch Settings for Share Text
                        final settings = await SettingsLocalDatasource().getSettings();
                        final appName = settings['app_name'] ?? 'Self Order POS';

                        await Share.shareXFiles([xFile], text: 'Receipt from $appName');
                      } catch (e, stackTrace) {
                        print('Error sharing receipt: $e');
                        print('Stack trace: $stackTrace');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('❌ Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    label: 'Kirim Struk',
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
