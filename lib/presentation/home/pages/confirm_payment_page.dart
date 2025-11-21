// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/get_table_status/get_table_status_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/order/order_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/pos_settings/pos_settings_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/status_table/status_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/dialog/payment_qris_dialog.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';
import 'package:flutter_posresto_app/presentation/home/widgets/save_order_dialog.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../widgets/order_menu.dart';
import '../widgets/success_payment_dialog.dart';

class ConfirmPaymentPage extends StatefulWidget {
  final bool isTable;
  final TableModel? table;
  final String orderType; // 'dine_in' or 'takeaway'
  const ConfirmPaymentPage({
    Key? key,
    required this.isTable,
    this.table,
    this.orderType = 'dine_in', // Default to dine_in
  }) : super(key: key);

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  final totalPriceController = TextEditingController();
  final customerController = TextEditingController();
  bool isPayNow = true;
  bool isCash = true;
  TableModel? selectTable;
  int discountAmount = 0;
  int priceValue = 0;
  int uangPas = 0;
  int uangPas2 = 0;
  int uangPas3 = 0;
  // int discountAmountValue = 0;
  int totalPriceFinal = 0;
  // int taxFinal = 0;
  // int serviceChargeFinal = 0;

  @override
  void initState() {
    context
        .read<GetTableStatusBloc>()
        .add(GetTableStatusEvent.getTablesStatus('available'));
    
    // AUTO-FILL customer name if DINE-IN (from selected table)
    if (widget.orderType == 'dine_in' && widget.table != null) {
      // Get customer name from table
      final customerName = widget.table!.customerName ?? '';
      if (customerName.isNotEmpty) {
        customerController.text = customerName;
        print('✅ Auto-filled customer name from table: $customerName');
      }
    }
    
    super.initState();
  }

  @override
  void dispose() {
    totalPriceController.dispose();
    customerController.dispose();
    super.dispose();
  }

  // ===== HELPER METHODS FOR CONSISTENT CALCULATION =====
  
  /// Calculate discount amount based on type (percentage or fixed)
  int _calculateDiscountAmount(dynamic discountModel, int subtotal) {
    if (discountModel == null) return 0;
    if (discountModel.value == null) return 0;
    
    // Handle both String and int types
    int discountValue;
    final value = discountModel.value;
    
    if (value is String) {
      // String type: use extension method
      final cleanedValue = value.replaceAll('.00', '').trim();
      if (cleanedValue.isEmpty) return 0;
      discountValue = cleanedValue.toIntegerFromText;
    } else if (value is int) {
      // Direct int
      discountValue = value;
    } else if (value is double) {
      // Double to int
      discountValue = value.toInt();
    } else {
      // Fallback: try to parse as string
      try {
        final strValue = value.toString().replaceAll('.00', '').trim();
        if (strValue.isEmpty || strValue == 'null') return 0;
        discountValue = strValue.toIntegerFromText;
      } catch (e) {
        print('⚠️ Error parsing discount value: $e');
        return 0;
      }
    }
    
    // Validate discountValue
    if (discountValue < 0) return 0;
    
    if (discountModel.type == 'percentage') {
      // Percentage: calculate from subtotal
      if (discountValue > 100) discountValue = 100; // Max 100%
      return (discountValue / 100 * subtotal).toInt();
    } else {
      // Fixed discount: return as-is
      // But don't exceed subtotal
      return discountValue > subtotal ? subtotal : discountValue;
    }
  }
  
  /// Calculate tax amount on after-discount subtotal
  int _calculateTaxAmount(int afterDiscount, int taxPercentage) {
    if (taxPercentage == 0) return 0;
    return (afterDiscount * taxPercentage / 100).toInt();
  }
  
  /// Calculate service charge on after-discount subtotal
  int _calculateServiceCharge(int afterDiscount, int servicePercentage) {
    if (servicePercentage == 0) return 0;
    return (afterDiscount * servicePercentage / 100).toInt();
  }
  
  /// Calculate final total with all charges
  Map<String, int> _calculateFinalTotal({
    required int subtotal,
    required dynamic discountModel,
    required int taxPercentage,
    required int servicePercentage,
  }) {
    // Step 1: Calculate discount
    final discountAmount = _calculateDiscountAmount(discountModel, subtotal);
    
    // Step 2: After discount
    final afterDiscount = subtotal - discountAmount;
    
    // Step 3: Calculate tax (on after discount)
    final taxAmount = _calculateTaxAmount(afterDiscount, taxPercentage);
    
    // Step 4: Calculate service (on after discount)
    final serviceAmount = _calculateServiceCharge(afterDiscount, servicePercentage);
    
    // Step 5: Final total
    final total = afterDiscount + taxAmount + serviceAmount;
    
    return {
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'afterDiscount': afterDiscount,
      'taxAmount': taxAmount,
      'serviceAmount': serviceAmount,
      'total': total,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Hero(
        tag: 'confirmation_screen',
        child: Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Konfirmasi',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.isTable
                                      ? 'Orders Table ${widget.table?.tableName}'
                                      : 'Orders #1',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                height: 60.0,
                                width: 60.0,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                        const Divider(),
                        const SpaceHeight(24.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Item',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 160,
                            ),
                            SizedBox(
                              width: 50.0,
                              child: Text(
                                'Qty',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                'Price',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(8),
                        const Divider(),
                        const SpaceHeight(8),
                        BlocBuilder<CheckoutBloc, CheckoutState>(
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () => const Center(
                                child: Text('No Items'),
                              ),
                              loaded: (products,
                                  discountModel,
                                  discount,
                                  discountAmount,
                                  tax,
                                  serviceCharge,
                                  totalQuantity,
                                  totalPrice,
                                  draftName) {
                                if (products.isEmpty) {
                                  return const Center(
                                    child: Text('No Items'),
                                  );
                                }
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      OrderMenu(data: products[index]),
                                  separatorBuilder: (context, index) =>
                                      const SpaceHeight(12.0),
                                  itemCount: products.length,
                                );
                              },
                            );
                          },
                        ),
                        const SpaceHeight(8.0),
                        const Divider(),
                        const SpaceHeight(4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sub total',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final price = state.maybeWhen(
                                    orElse: () => 0,
                                    loaded: (products,
                                            discountModel,
                                            discount,
                                            discountAmount,
                                            tax,
                                            serviceCharge,
                                            totalQuantity,
                                            totalPrice,
                                            draftName) =>
                                        products.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element.product.price!
                                                      .toIntegerFromText *
                                                  element.quantity),
                                        ));
                                return Text(
                                  price.currencyFormatRp,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Diskon',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () => const Text('-'),
                                  loaded: (products,
                                      discountModel,
                                      discount,
                                      discountAmount,
                                      tax,
                                      serviceCharge,
                                      totalQuantity,
                                      totalPrice,
                                      draftName) {
                                    if (discountModel == null) {
                                      return const Text('-');
                                    }

                                    final discountValue = discountModel.value!
                                        .replaceAll('.00', '')
                                        .toIntegerFromText;

                                    final subTotal = products.fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue +
                                          (element.product.price!
                                                  .toIntegerFromText *
                                              element.quantity),
                                    );

                                    // Calculate based on type
                                    final int finalDiscount;
                                    final String displayText;
                                    
                                    if (discountModel.type == 'percentage') {
                                      finalDiscount = (discountValue / 100 * subTotal).toInt();
                                      displayText = '$discountValue % (${finalDiscount.currencyFormatRp})';
                                    } else {
                                      // Fixed type
                                      finalDiscount = discountValue;
                                      displayText = '${finalDiscount.currencyFormatRp}';
                                    }

                                    // Update discountAmount for service calculation
                                    this.discountAmount = finalDiscount;

                                    return Text(
                                      displayText,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(4.0),
                        // Tax Row - Only show if enabled in PosSettings
                        BlocBuilder<PosSettingsBloc, PosSettingsState>(
                          builder: (context, settingsState) {
                            return settingsState.maybeWhen(
                              orElse: () => const SizedBox.shrink(),
                              loaded: (settings) {
                                // Hide if taxes disabled
                                if (settings.taxes.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Pajak',
                                      style: TextStyle(color: AppColors.grey),
                                    ),
                                    BlocBuilder<CheckoutBloc, CheckoutState>(
                                      builder: (context, state) {
                                        return state.maybeWhen(
                                          orElse: () => const Text('0 %'),
                                          loaded: (products,
                                              discountModel,
                                              discount,
                                              discountAmount,
                                              tax,
                                              serviceCharge,
                                              totalQuantity,
                                              totalPrice,
                                              draftName) {
                                            if (tax == 0) {
                                              return const Text('0 %');
                                            }

                                            final subTotal = products.fold(
                                              0,
                                              (previousValue, element) =>
                                                  previousValue +
                                                  (element.product.price!
                                                          .toIntegerFromText *
                                                      element.quantity),
                                            );

                                            // Calculate discount amount
                                            final int discountAmountValue;
                                            if (discountModel != null) {
                                              final discountValue = discountModel.value!
                                                  .replaceAll('.00', '')
                                                  .toIntegerFromText;
                                              if (discountModel.type == 'percentage') {
                                                discountAmountValue = (discountValue / 100 * subTotal).toInt();
                                              } else {
                                                discountAmountValue = discountValue;
                                              }
                                            } else {
                                              discountAmountValue = 0;
                                            }

                                            final afterDiscount = subTotal - discountAmountValue;
                                            final finalTax = (afterDiscount * tax / 100).toInt();

                                            return Text(
                                              '$tax % (${finalTax.currencyFormatRp})',
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const SpaceHeight(4.0),
                        // Service Charge Row - Only show if enabled in PosSettings
                        BlocBuilder<PosSettingsBloc, PosSettingsState>(
                          builder: (context, settingsState) {
                            return settingsState.maybeWhen(
                              orElse: () => const SizedBox.shrink(),
                              loaded: (settings) {
                                // Hide if services disabled
                                if (settings.services.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Biaya Layanan',
                                      style: TextStyle(color: AppColors.grey),
                                    ),
                                    BlocBuilder<CheckoutBloc, CheckoutState>(
                                      builder: (context, state) {
                                        return state.maybeWhen(
                                          orElse: () => const Text('0 %'),
                                          loaded: (products,
                                              discountModel,
                                              discount,
                                              discountAmount,
                                              tax,
                                              serviceCharge,
                                              totalQuantity,
                                              totalPrice,
                                              draftName) {
                                            if (serviceCharge == 0) {
                                              return const Text('0 %');
                                            }

                                            final subTotal = products.fold(
                                              0,
                                              (previousValue, element) =>
                                                  previousValue +
                                                  (element.product.price!
                                                          .toIntegerFromText *
                                                      element.quantity),
                                            );

                                            // Calculate discount amount
                                            final int discountAmountValue;
                                            if (discountModel != null) {
                                              final discountValue = discountModel.value!
                                                  .replaceAll('.00', '')
                                                  .toIntegerFromText;
                                              if (discountModel.type == 'percentage') {
                                                discountAmountValue = (discountValue / 100 * subTotal).toInt();
                                              } else {
                                                discountAmountValue = discountValue;
                                              }
                                            } else {
                                              discountAmountValue = 0;
                                            }

                                            final afterDiscount = subTotal - discountAmountValue;
                                            final nominalServiceCharge = (serviceCharge / 100 * afterDiscount).toInt();

                                            return Text(
                                              '$serviceCharge % (${nominalServiceCharge.currencyFormatRp})',
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const SpaceHeight(10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () => const Text('Rp 0'),
                                  loaded: (products,
                                      discountModel,
                                      discount,
                                      discountAmount,
                                      tax,
                                      serviceCharge,
                                      totalQuantity,
                                      totalPrice,
                                      draftName) {
                                    // Calculate subtotal
                                    final subTotal = products.fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue +
                                          (element.product.price!
                                                  .toIntegerFromText *
                                              element.quantity),
                                    );

                                    // Calculate discount amount (percentage or fixed)
                                    final int discountAmountValue;
                                    if (discountModel != null) {
                                      final discountValue = discountModel.value!
                                          .replaceAll('.00', '')
                                          .toIntegerFromText;
                                      if (discountModel.type == 'percentage') {
                                        discountAmountValue = (discountValue / 100 * subTotal).toInt();
                                      } else {
                                        // Fixed discount
                                        discountAmountValue = discountValue;
                                      }
                                    } else {
                                      discountAmountValue = 0;
                                    }

                                    // After discount
                                    final afterDiscount = subTotal - discountAmountValue;

                                    // Calculate tax
                                    final finalTax = (afterDiscount * tax / 100).toInt();

                                    // Calculate service charge
                                    final service = (serviceCharge / 100 * afterDiscount).toInt();

                                    // Final total
                                    final total = afterDiscount + finalTax + service;

                                    // Update state variables
                                    priceValue = total;
                                    totalPriceController.text = total.currencyFormatRpV2;
                                    uangPas = total;
                                    uangPas2 = uangPas ~/ 50000 * 50000 + 50000;
                                    uangPas3 = uangPas ~/ 50000 * 50000 + 100000;
                                    totalPriceFinal = total;

                                    return Text(
                                      total.currencyFormatRp,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.isTable != true) ...[
                              const Text(
                                'Pembayaran',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SpaceHeight(16.0),
                              Row(
                                children: [
                                  isPayNow
                                      ? Button.filled(
                                          width: 180.0,
                                          height: 52.0,
                                          onPressed: () {
                                            isPayNow = true;
                                            setState(() {});
                                          },
                                          label: 'Bayar Sekarang',
                                        )
                                      : Button.outlined(
                                          width: 180.0,
                                          height: 52.0,
                                          onPressed: () {
                                            isPayNow = true;
                                            setState(() {});
                                          },
                                          label: 'Bayar Sekarang'),
                                  SpaceWidth(16),
                                  isPayNow
                                      ? Button.outlined(
                                          width: 180.0,
                                          height: 52.0,
                                          onPressed: () {
                                            isPayNow = false;
                                            log("price Value: ${priceValue}");
                                            setState(() {});
                                          },
                                          label: 'Bayar Nanti')
                                      : Button.filled(
                                          width: 180.0,
                                          height: 52.0,
                                          onPressed: () {
                                            isPayNow = false;
                                            log("price Value2: ${priceValue}");
                                            setState(() {});
                                          },
                                          label: 'Bayar Nanti',
                                        )
                                ],
                              ),
                            ],
                            const SpaceHeight(8.0),
                            if (!isPayNow) ...[
                              const Divider(),
                              const SpaceHeight(8.0),
                              const Text(
                                'Meja',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SpaceHeight(12.0),
                              BlocBuilder<GetTableStatusBloc,
                                      GetTableStatusState>(
                                  builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () =>
                                      const CircularProgressIndicator(),
                                  success: (tables) {
                                    if (selectTable == null &&
                                        widget.table != null) {
                                      selectTable = tables.firstWhere(
                                        (t) => t.id == widget.table!.id,
                                        orElse: () => tables.first,
                                      );
                                    }
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<TableModel>(
                                          isExpanded: true,
                                          value: selectTable,
                                          onChanged: (TableModel? newValue) {
                                            setState(() {
                                              selectTable = newValue;
                                            });
                                          },
                                          items: tables
                                              .map<
                                                  DropdownMenuItem<TableModel>>(
                                                (TableModel value) =>
                                                    DropdownMenuItem<
                                                        TableModel>(
                                                  value: value,
                                                  child: Text(value.tableName),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ],
                            const SpaceHeight(8.0),
                            const Divider(),
                            const SpaceHeight(8.0),
                            const Text(
                              'Customer',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SpaceHeight(12.0),
                            TextFormField(
                              controller: customerController,
                              enabled: widget.orderType == 'takeaway', // DISABLE for dine-in
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                hintText: widget.orderType == 'dine_in' 
                                    ? 'Nama Customer (dari meja)' 
                                    : 'Nama Customer',
                                filled: widget.orderType == 'dine_in',
                                fillColor: widget.orderType == 'dine_in' 
                                    ? Colors.grey[200] 
                                    : null,
                              ),
                              style: TextStyle(
                                color: widget.orderType == 'dine_in' 
                                    ? Colors.grey[600] 
                                    : Colors.black,
                              ),
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SpaceHeight(8.0),
                            if (isPayNow) ...[
                              const Divider(),
                              const SpaceHeight(8.0),
                              const Text(
                                'Metode Bayar',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SpaceHeight(12.0),
                              Row(
                                children: [
                                  isCash
                                      ? Button.filled(
                                          width: 120.0,
                                          height: 50.0,
                                          onPressed: () {
                                            isCash = true;
                                            setState(() {});
                                          },
                                          label: 'Cash',
                                        )
                                      : Button.outlined(
                                          width: 120.0,
                                          height: 50.0,
                                          onPressed: () {
                                            isCash = true;
                                            setState(() {});
                                          },
                                          label: 'Cash',
                                        ),
                                  const SpaceWidth(8.0),
                                  isCash
                                      ? Button.outlined(
                                          width: 120.0,
                                          height: 50.0,
                                          onPressed: () {
                                            isCash = false;
                                            setState(() {});
                                          },
                                          label: 'QRIS',
                                        )
                                      : Button.filled(
                                          width: 120.0,
                                          height: 50.0,
                                          onPressed: () {
                                            isCash = false;
                                            setState(() {});
                                          },
                                          label: 'QRIS',
                                        ),
                                ],
                              ),
                              const SpaceHeight(8.0),
                              const Divider(),
                              const SpaceHeight(8.0),
                              const Text(
                                'Total Bayar',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SpaceHeight(12.0),
                              BlocBuilder<CheckoutBloc, CheckoutState>(
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: totalPriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      hintText: 'Total harga',
                                    ),
                                    onChanged: (value) {
                                      priceValue = value.toIntegerFromText;
                                      final int newValue =
                                          value.toIntegerFromText;
                                      totalPriceController.text =
                                          newValue.currencyFormatRp;
                                      totalPriceController.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: totalPriceController
                                                      .text.length));
                                    },
                                  );
                                },
                              ),
                              const SpaceHeight(20.0),
                              BlocBuilder<CheckoutBloc, CheckoutState>(
                                builder: (context, state) {
                                  return Row(
                                    children: [
                                      Button.filled(
                                        width: 150.0,
                                        onPressed: () {
                                          totalPriceController.text = uangPas
                                              .toString()
                                              .currencyFormatRpV2;
                                          priceValue = uangPas;
                                        },
                                        label: 'UANG PAS',
                                      ),
                                      const SpaceWidth(20.0),
                                      Button.filled(
                                        width: 150.0,
                                        onPressed: () {
                                          totalPriceController.text = uangPas2
                                              .toString()
                                              .currencyFormatRpV2;
                                          priceValue = uangPas2;
                                        },
                                        label: uangPas2
                                            .toString()
                                            .currencyFormatRpV2,
                                      ),
                                      const SpaceWidth(20.0),
                                      Button.filled(
                                        width: 150.0,
                                        onPressed: () {
                                          totalPriceController.text = uangPas3
                                              .toString()
                                              .currencyFormatRpV2;
                                          priceValue = uangPas3;
                                        },
                                        label: uangPas3
                                            .toString()
                                            .currencyFormatRpV2,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ]
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ColoredBox(
                          color: AppColors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Button.outlined(
                                    onPressed: () => context.pop(),
                                    label: 'Kembali',
                                  ),
                                ),
                                const SpaceWidth(8.0),
                                BlocListener<CheckoutBloc, CheckoutState>(
                                  listener: (context, state) {
                                    state.maybeWhen(
                                        orElse: () {},
                                        savedDraftOrder: (orderDraftId) {
                                          log("PRICEVALUE: ${priceValue}");

                                          final newTabel = TableModel(
                                              id: widget.isTable
                                                  ? widget.table!.id
                                                  : selectTable?.id,
                                              name: widget.isTable
                                                  ? widget.table!.tableName
                                                  : selectTable?.tableName ??
                                                      '0',
                                              status: 'occupied',
                                              capacity: widget.isTable
                                                  ? widget.table!.capacity
                                                  : selectTable?.capacity ?? 4,
                                              paymentAmount: priceValue.toDouble(),
                                              orderId: orderDraftId);
                                          log('new tabel: ${newTabel.toMap()}');
                                          context
                                              .read<StatusTableBloc>()
                                              .add(StatusTableEvent.statusTabel(
                                                newTabel,
                                              ));
                                        });
                                  },
                                  child:
                                      BlocBuilder<CheckoutBloc, CheckoutState>(
                                    builder: (context, state) {
                                      // Extract state data
                                      final discountModel = state.maybeWhen(
                                        orElse: () => null,
                                        loaded: (products,
                                                discountModel,
                                                discount,
                                                discountAmount,
                                                tax,
                                                serviceCharge,
                                                totalQuantity,
                                                totalPrice,
                                                draftName) =>
                                            discountModel,
                                      );

                                      final subtotal = state.maybeWhen(
                                        orElse: () => 0,
                                        loaded: (products,
                                                discountModel,
                                                discount,
                                                discountAmount,
                                                tax,
                                                serviceCharge,
                                                totalQuantity,
                                                totalPrice,
                                                draftName) =>
                                            products.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element.product.price!
                                                      .toIntegerFromText *
                                                  element.quantity),
                                        ),
                                      );

                                      final taxPercentage = state.maybeWhen(
                                        orElse: () => 0,
                                        loaded: (products,
                                                discountModel,
                                                discount,
                                                discountAmount,
                                                tax,
                                                serviceCharge,
                                                totalQuantity,
                                                totalPrice,
                                                draftName) =>
                                            tax,
                                      );

                                      final servicePercentage = state.maybeWhen(
                                        orElse: () => 0,
                                        loaded: (products,
                                                discountModel,
                                                discount,
                                                discountAmount,
                                                tax,
                                                serviceCharge,
                                                totalQuantity,
                                                totalPrice,
                                                draftName) =>
                                            serviceCharge,
                                      );

                                      // Use helper method for consistent calculation
                                      final calculated = _calculateFinalTotal(
                                        subtotal: subtotal,
                                        discountModel: discountModel,
                                        taxPercentage: taxPercentage,
                                        servicePercentage: servicePercentage,
                                      );
                                      
                                      final totalDiscount = calculated['discountAmount']!;
                                      final afterDiscount = calculated['afterDiscount']!;
                                      final finalTax = calculated['taxAmount']!;
                                      final totalServiceCharge = calculated['serviceAmount']!;
                                      final finalTotal = calculated['total']!;

                                      List<ProductQuantity> items =
                                          state.maybeWhen(
                                        orElse: () => [],
                                        loaded: (products,
                                                discountModel,
                                                discount,
                                                discountAmount,
                                                tax,
                                                serviceCharge,
                                                totalQuantity,
                                                totalPrice,
                                                draftName) =>
                                            products,
                                      );
                                      final totalQty = items.fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue + element.quantity,
                                      );

                                      return Flexible(
                                        child: Button.filled(
                                          onPressed: () async {
                                            // VALIDATION: Customer name wajib diisi!
                                            if (customerController.text.trim().isEmpty) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('⚠️ Nama customer wajib diisi!'),
                                                  backgroundColor: Colors.orange,
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                              return;
                                            }
                                            
                                            // FIX: Check isPayNow FIRST, then check table
                                            if (!isPayNow && widget.isTable) {
                                              // BAYAR NANTI (Save Draft) for dine-in
                                              log("💾 Save Draft: discountAmountValue: $totalDiscount");
                                              context.read<CheckoutBloc>().add(
                                                    CheckoutEvent
                                                        .saveDraftOrder(
                                                      widget.isTable == true
                                                          ? widget.table!.id!
                                                          : selectTable!.id!,
                                                      customerController.text,
                                                      totalDiscount.toInt(),
                                                    ),
                                                  );
                                              await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) =>
                                                    SaveOrderDialog(
                                                  data: items,
                                                  totalQty: totalQty,
                                                  totalPrice: totalPriceFinal,
                                                  totalTax: finalTax,
                                                  totalDiscount: totalDiscount,
                                                  subTotal: afterDiscount,
                                                  normalPrice: subtotal,
                                                  table: widget.table!,
                                                  draftName:
                                                      customerController.text,
                                                ),
                                              );
                                            } else if (isPayNow) {
                                              // BAYAR SEKARANG (Cash/QRIS)
                                              // context.read<CheckO>().add(
                                              //     OrderEvent.addPaymentMethod(
                                              //         items,
                                              //         totalPrice,
                                              //         finalTax,
                                              //         discount != null
                                              //             ? discount.value
                                              //                 .replaceAll(
                                              //                     '.00', '')
                                              //                 .toIntegerFromText
                                              //             : 0,
                                              //         finalDiscountAmount,
                                              //         finalService,
                                              //         subTotal,
                                              //         totalPriceController.text
                                              //             .toIntegerFromText,
                                              //         auth?.user.name ?? '-',
                                              //         totalQuantity,
                                              //         auth?.user.id ?? 1,
                                              //         isCash
                                              //             ? 'Cash'
                                              //             : 'QR Pay'));
                                              if (isCash) {
                                                final paymentAmountValue = totalPriceController
                                                    .text
                                                    .toIntegerFromText;
                                                
                                                log("💰 PAYMENT DETAILS:");
                                                log("   Subtotal: $subtotal");
                                                log("   Discount: $totalDiscount");
                                                log("   After Discount: $afterDiscount");
                                                log("   Tax: $finalTax");
                                                log("   Service: $totalServiceCharge");
                                                log("   TOTAL: $finalTotal");
                                                log("   Payment Amount: $paymentAmountValue");
                                                log("   Kembalian: ${paymentAmountValue - finalTotal}");
                                                
                                                // Trigger order save
                                                final tableNumber = (widget.orderType == 'dine_in' && widget.table != null) 
                                                    ? widget.table!.id! 
                                                    : 0;
                                                
                                                context.read<OrderBloc>().add(
                                                    OrderEvent.order(
                                                        items,
                                                        totalDiscount, // Use calculated discount
                                                        totalDiscount,
                                                        finalTax,
                                                        totalServiceCharge, // FIX: Use calculated service charge
                                                        paymentAmountValue,
                                                        customerController.text,
                                                        tableNumber, // Use actual table ID for dine_in, 0 for takeaway
                                                        'paid', // Changed: was 'completed', now 'paid' for order tracking
                                                        'paid',
                                                        'Cash',
                                                        finalTotal,
                                                        widget.orderType)); // Pass order type
                                                
                                                log("⏳ Waiting for OrderBloc to emit loaded state...");
                                                
                                                // Wait for OrderBloc to complete and emit _Loaded state
                                                await context.read<OrderBloc>().stream.firstWhere(
                                                  (state) => state.maybeWhen(
                                                    orElse: () => false,
                                                    loaded: (model, orderId) => true,
                                                  ),
                                                );
                                                
                                                log("✅ OrderBloc loaded! Opening success dialog...");
                                                
                                                // Now show dialog with loaded state
                                                if (context.mounted) {
                                                  await showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) =>
                                                        SuccessPaymentDialog(
                                                      data: items,
                                                      totalQty: totalQty,
                                                      totalPrice: totalPriceFinal,
                                                      totalTax: finalTax,
                                                      totalDiscount: totalDiscount,
                                                      subTotal: afterDiscount,
                                                      normalPrice: subtotal,
                                                      totalService: totalServiceCharge,
                                                      draftName:
                                                          customerController.text,
                                                      paymentAmount: paymentAmountValue, // Pass actual payment
                                                      tableName: widget.table?.name, // NEW: Pass table name
                                                      orderType: widget.orderType, // NEW: Pass order type
                                                    ),
                                                  );
                                                }
                                              } else {
                                                final tableNumber = (widget.orderType == 'dine_in' && widget.table != null) 
                                                    ? widget.table!.id! 
                                                    : 0;
                                                    
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      PaymentQrisDialog(
                                                    price: totalPriceFinal,
                                                    items: items,
                                                    totalQty: totalQty,
                                                    tax: finalTax,
                                                    discountAmount: totalDiscount,
                                                    subTotal: afterDiscount,
                                                    customerName:
                                                        customerController.text,
                                                    discount: totalDiscount,
                                                    paymentAmount:
                                                        totalPriceController
                                                            .text
                                                            .toIntegerFromText,
                                                    paymentMethod: 'Qris',
                                                    tableNumber: tableNumber,
                                                    paymentStatus: 'paid',
                                                    serviceCharge: totalServiceCharge,
                                                    status: 'paid', // Changed: was 'completed', now 'paid' for order tracking
                                                    orderType: widget.orderType,
                                                    tableName: widget.table?.name, // NEW: Pass table name
                                                  ),
                                                );
                                              }
                                            } else {
                                              // Bayar Nanti (Save Draft)
                                              context.read<CheckoutBloc>().add(
                                                    CheckoutEvent
                                                        .saveDraftOrder(
                                                      widget.isTable == true
                                                          ? widget.table!.id!
                                                          : selectTable!.id!,
                                                      customerController.text,
                                                      totalDiscount,
                                                    ),
                                                  );
                                              await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) =>
                                                    SaveOrderDialog(
                                                  data: items,
                                                  totalQty: totalQty,
                                                  totalPrice: totalPriceFinal,
                                                  totalTax: finalTax,
                                                  totalDiscount: totalDiscount,
                                                  subTotal: afterDiscount,
                                                  normalPrice: subtotal,
                                                  table: selectTable!,
                                                  draftName:
                                                      customerController.text,
                                                ),
                                              );
                                            }
                                          },
                                          label: isPayNow
                                              ? 'Bayar'
                                              : 'Simpan Order',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
