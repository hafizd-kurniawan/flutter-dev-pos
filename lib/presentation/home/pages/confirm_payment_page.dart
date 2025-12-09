// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_posresto_app/core/constants/variables.dart'; // NEW: Import Variables

import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/get_table_status/get_table_status_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/order/order_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/pos_settings/pos_settings_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/status_table/status_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/dialog/payment_qris_dialog.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';
import 'package:flutter_posresto_app/presentation/home/widgets/floating_header.dart';
import 'package:flutter_posresto_app/presentation/home/widgets/save_order_dialog.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';

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
  final VoidCallback? onPaymentSuccess; // NEW: Callback
  const ConfirmPaymentPage({
    Key? key,
    required this.isTable,
    this.table,
    this.orderType = 'dine_in', // Default to dine_in
    this.onPaymentSuccess, // NEW: Callback
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
  int taxFinal = 0;
  int serviceChargeFinal = 0;
  int subTotalFinal = 0;
  List<ProductQuantity> itemsFinal = [];
  String orderNoteFinal = '';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF), // App Background
      body: Stack(
        children: [
          // 1. Main Content
          Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 24, right: 24, bottom: 24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isLarge = constraints.maxWidth > 900;
                
                if (isLarge) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT: Order Summary
                      Expanded(
                        flex: 3,
                        child: _buildOrderSummaryCard(),
                      ),
                      const SizedBox(width: 24),
                      // RIGHT: Payment Details
                      Expanded(
                        flex: 2,
                        child: _buildPaymentDetailsCard(),
                      ),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildOrderSummaryCard(),
                        const SizedBox(height: 24),
                        _buildPaymentDetailsCard(),
                      ],
                    ),
                  );
                }
              },
            ),
          ),

          // 2. Floating Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FloatingHeader(
              title: AppLocalizations.of(context)!.confirm_payment,
              onToggleSidebar: () => Navigator.pop(context),
              isSidebarVisible: false, // Back button mode
              useBackIcon: true, // NEW: Force back icon
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.order_summary,
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.isTable
                ? AppLocalizations.of(context)!.table_name_label(widget.table?.tableName ?? '')
                : AppLocalizations.of(context)!.order_id_label(DateTime.now().millisecondsSinceEpoch.toString().substring(8)),
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // Header Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  AppLocalizations.of(context)!.item,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  AppLocalizations.of(context)!.qty,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  AppLocalizations.of(context)!.price,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Items List
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => Center(child: Text(AppLocalizations.of(context)!.no_items)),
                loaded: (products, discountModel, discount, discountAmount, tax, serviceCharge, totalQuantity, totalPrice, draftName, orderNote) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = products[index];
                      return Row(
                        children: [
                          // NEW: Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: item.product.image != null && item.product.image!.isNotEmpty
                                  ? Image.network(
                                      item.product.image!.toImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 20)),
                                    )
                                  : Container(color: Colors.grey[200], child: const Icon(Icons.image, size: 20)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name ?? '',
                                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                                ),
                                if (item.product.category != null)
                                  Text(
                                    item.product.category?.name ?? 'Category',
                                    style: GoogleFonts.quicksand(fontSize: 10, color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'x${item.quantity}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              (item.product.price!.toIntegerFromText * item.quantity).currencyFormatRp,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          // Totals
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => const SizedBox.shrink(),
                loaded: (products, discountModel, discount, discountAmount, tax, serviceCharge, totalQuantity, totalPrice, draftName, orderNote) {
                  final subTotal = products.fold(0, (prev, el) => prev + (el.product.price!.toIntegerFromText * el.quantity));
                  final discAmt = _calculateDiscountAmount(discountModel, subTotal);
                  final afterDisc = subTotal - discAmt;
                  final taxAmt = _calculateTaxAmount(afterDisc, tax);
                  final servAmt = _calculateServiceCharge(afterDisc, serviceCharge);
                  
                  return Column(
                    children: [
                      _buildTotalRow(AppLocalizations.of(context)!.subtotal, subTotal.currencyFormatRp),
                      const SizedBox(height: 8),
                      
                      // DISCOUNT
                      if (discountModel != null) ...[
                         _buildTotalRow(
                          AppLocalizations.of(context)!.discount, 
                          discountModel.type == 'percentage' 
                              ? '(${discountModel.value}%) -${discAmt.currencyFormatRp}'
                              : '-${discAmt.currencyFormatRp}',
                          isDiscount: true,
                        ),
                        const SizedBox(height: 8),
                      ],

                      // TAX
                      if (tax > 0) ...[
                        _buildTotalRow(AppLocalizations.of(context)!.tax, '($tax%) ${taxAmt.currencyFormatRp}'),
                        const SizedBox(height: 8),
                      ],

                      // SERVICE
                      if (serviceCharge > 0) ...[
                        _buildTotalRow(AppLocalizations.of(context)!.service_charge, '($serviceCharge%) ${servAmt.currencyFormatRp}'),
                        const SizedBox(height: 8),
                      ],
                    ],
                  );
                },
              );
            },
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.total,
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => Text('Rp 0', style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.bold)),
                    loaded: (products, discountModel, discount, discountAmount, tax, serviceCharge, totalQuantity, totalPrice, draftName, orderNote) {
                      final subTotal = products.fold(0, (prev, el) => prev + (el.product.price!.toIntegerFromText * el.quantity));
                      final discAmt = _calculateDiscountAmount(discountModel, subTotal);
                      final afterDisc = subTotal - discAmt;
                      final taxAmt = _calculateTaxAmount(afterDisc, tax);
                      final servAmt = _calculateServiceCharge(afterDisc, serviceCharge);
                      final total = afterDisc + taxAmt + servAmt;
                      
                      // Update state vars for payment
                      priceValue = total;
                      totalPriceFinal = total;
                      
                      // NEW: Calculate Quick Amounts (Uang Pas, etc.)
                      // Use WidgetsBinding to update state after build to avoid error
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && uangPas != total) {
                           setState(() {
                             uangPas = total;
                             // Calculate next logical amounts (e.g. 20k, 50k, 100k)
                             // Simple logic: Round up to nearest 10k, 50k, 100k
                             
                             int amount = total;
                             // Suggestion 2: Next 10k or 50k
                             if (amount < 50000) {
                               uangPas2 = 50000;
                               uangPas3 = 100000;
                             } else if (amount < 100000) {
                               uangPas2 = 100000;
                               uangPas3 = 150000; // or 200k
                             } else {
                               // Round up to nearest 50k
                               int remainder = amount % 50000;
                               if (remainder == 0) {
                                 uangPas2 = amount + 50000;
                               } else {
                                 uangPas2 = amount + (50000 - remainder);
                               }
                               uangPas3 = uangPas2 + 50000;
                             }
                           });
                        }
                      });
                      
                      return Text(
                        total.currencyFormatRp,
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
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
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.grey[600]),
        ),
        Text(
          value,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.green : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.payment_details,
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            AppLocalizations.of(context)!.customer_name,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: widget.orderType == 'dine_in' ? Colors.grey[100] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: customerController,
              enabled: widget.orderType == 'takeaway',
              style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.enter_customer_name,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            AppLocalizations.of(context)!.payment_method,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isCash = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isCash ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCash ? AppColors.primary : Colors.grey[300]!,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.cash,
                      style: GoogleFonts.quicksand(
                        color: isCash ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isCash = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: !isCash ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !isCash ? AppColors.primary : Colors.grey[300]!,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.qris,
                      style: GoogleFonts.quicksand(
                        color: !isCash ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          if (isCash) ...[
            Text(
              AppLocalizations.of(context)!.cash_amount,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Rp', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: totalPriceController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 18),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // Handle manual input
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Quick Amount Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickAmountButton(uangPas, AppLocalizations.of(context)!.exact_amount),
                _buildQuickAmountButton(uangPas2, uangPas2.currencyFormatRp),
                _buildQuickAmountButton(uangPas3, uangPas3.currencyFormatRp),
              ],
            ),
          ],
          
          const SizedBox(height: 32),
          
          BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                loaded: (model, orderId) {
                  // SUCCESS HANDLER
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return SuccessPaymentDialog(
                        data: itemsFinal,
                        totalQty: model.totalItem,
                        totalPrice: model.total,
                        totalTax: taxFinal,
                        totalDiscount: discountAmount,
                        subTotal: subTotalFinal,
                        normalPrice: subTotalFinal, // Assuming normal price is subtotal
                        totalService: serviceChargeFinal,
                        draftName: customerController.text,
                        paymentAmount: isCash ? totalPriceController.text.toIntegerFromText : model.total,
                        paymentMethod: model.paymentMethod,
                        tableName: widget.table?.tableName,
                        orderType: widget.orderType,
                        orderNote: orderNoteFinal,
                        onPaymentSuccess: widget.onPaymentSuccess,
                      );
                    },
                  );
                  
                  if (widget.onPaymentSuccess != null) {
                    widget.onPaymentSuccess!();
                  }
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // 1. VALIDATION: Customer Name
                        final customerName = customerController.text.trim();
                        if (customerName.isEmpty) {
                          NotificationHelper.showWarning(
                            context,
                            widget.orderType == 'takeaway'
                                ? AppLocalizations.of(context)!.customer_name_required_takeaway
                                : AppLocalizations.of(context)!.customer_name_required,
                          );
                          return;
                        }

                        // 2. VALIDATION: Payment Amount (Cash)
                        if (isCash) {
                          final paymentAmountValue = totalPriceController.text.toIntegerFromText;
                          if (paymentAmountValue < totalPriceFinal) {
                            NotificationHelper.showWarning(context, AppLocalizations.of(context)!.payment_amount_insufficient);
                            return;
                          }
                        }

                        // 3. PREPARE DATA
                        // Get latest state values
                        final checkoutState = context.read<CheckoutBloc>().state;
                        final items = checkoutState.maybeWhen(
                          orElse: () => <ProductQuantity>[],
                          loaded: (products, _, __, ___, ____, _____, ______, _______, ________, _________) => products,
                        );
                        
                        final discountModel = checkoutState.maybeWhen(
                          orElse: () => null,
                          loaded: (_, discountModel, __, ___, ____, _____, ______, _______, ________, _________) => discountModel,
                        );
                        
                        final taxPercentage = checkoutState.maybeWhen(
                          orElse: () => 0,
                          loaded: (_, __, ___, ____, tax, _____, ______, _______, ________, _________) => tax,
                        );
                        
                        final servicePercentage = checkoutState.maybeWhen(
                          orElse: () => 0,
                          loaded: (_, __, ___, ____, _____, service, ______, _______, ________, _________) => service,
                        );
                        
                        final orderNote = checkoutState.maybeWhen(
                          orElse: () => '',
                          loaded: (_, __, ___, ____, _____, ______, _______, ________, _________, note) => note,
                        );

                        // Calculate final values
                        final subTotal = items.fold(0, (prev, el) => prev + (el.product.price!.toIntegerFromText * el.quantity));
                        final calculated = _calculateFinalTotal(
                          subtotal: subTotal,
                          discountModel: discountModel,
                          taxPercentage: taxPercentage,
                          servicePercentage: servicePercentage,
                        );
                        
                        final totalDiscount = calculated['discountAmount']!;
                        final finalTax = calculated['taxAmount']!;
                        final totalService = calculated['serviceAmount']!;
                        final finalTotal = calculated['total']!;
                        final paymentAmountValue = isCash ? totalPriceController.text.toIntegerFromText : finalTotal;

                        // SAVE STATE for Dialog
                        setState(() {
                          itemsFinal = items;
                          taxFinal = finalTax;
                          serviceChargeFinal = totalService;
                          subTotalFinal = subTotal;
                          discountAmount = totalDiscount;
                          totalPriceFinal = finalTotal;
                          orderNoteFinal = orderNote;
                        });

                        // 4. EXECUTE PAYMENT
                        if (isCash) {
                          // CASH PAYMENT
                          context.read<OrderBloc>().add(OrderEvent.order(
                            items,
                            totalDiscount,
                            totalDiscount,
                            finalTax,
                            totalService,
                            paymentAmountValue,
                            customerName,
                            widget.isTable ? widget.table!.id! : 0,
                            'paid',
                            'paid',
                            'Cash',
                            finalTotal,
                            widget.orderType,
                            taxPercentage,
                            servicePercentage,
                            orderNote,
                          ));
                        } else {
                          // QRIS PAYMENT
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => PaymentQrisDialog(
                              price: finalTotal,
                              items: items,
                              totalQty: items.fold(0, (p, e) => p + e.quantity),
                              tax: finalTax,
                              discountAmount: totalDiscount,
                              subTotal: calculated['afterDiscount']!,
                              customerName: customerName,
                              discount: totalDiscount,
                              paymentAmount: paymentAmountValue,
                              paymentMethod: 'Qris',
                              tableNumber: widget.isTable ? widget.table!.id! : 0,
                              paymentStatus: 'paid',
                              serviceCharge: totalService,
                              status: 'paid',
                              orderType: widget.orderType,
                              tableName: widget.table?.tableName,
                              orderNote: orderNote,
                              onPaymentSuccess: widget.onPaymentSuccess,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.process_payment,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmountButton(int amount, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          totalPriceController.text = amount.currencyFormatRpV2;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
