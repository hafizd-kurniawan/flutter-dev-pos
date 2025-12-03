// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/dataoutputs/print_dataoutputs.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';
import 'package:intl/intl.dart';

import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/qris/qris_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/widgets/success_payment_dialog.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../bloc/order/order_bloc.dart';

class PaymentQrisDialog extends StatefulWidget {
  final List<ProductQuantity> items;
  final int discount;
  final int discountAmount;
  final int tax;
  final int serviceCharge;
  final int paymentAmount;
  final String customerName;
  final int tableNumber;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final int price;
  final int totalQty;
  final int subTotal;
  final bool? isTablePaymentPage;
  final String orderType; // 'dine_in' or 'takeaway'
  final String? tableName; // NEW: Table name for display
  final String? orderNote; // NEW: Global Order Note
  final VoidCallback? onPaymentSuccess; // NEW: Callback
  const PaymentQrisDialog({
    super.key,
    required this.items,
    required this.discount,
    required this.discountAmount,
    required this.tax,
    required this.serviceCharge,
    required this.paymentAmount,
    required this.customerName,
    required this.tableNumber,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.price,
    required this.totalQty,
    required this.subTotal,
    this.isTablePaymentPage = false,
    this.orderType = 'dine_in', // Default to dine_in
    this.tableName, // NEW: Optional table name
    this.orderNote, // NEW: Global Order Note
    this.onPaymentSuccess, // NEW: Callback
  });

  @override
  State<PaymentQrisDialog> createState() => _PaymentQrisDialogState();
}

class _PaymentQrisDialogState extends State<PaymentQrisDialog> {
  String orderId = '';
  Timer? timer;

  WidgetsToImageController controller = WidgetsToImageController();
  @override
  void initState() {
    orderId = DateTime.now().millisecondsSinceEpoch.toString();
    context.read<QrisBloc>().add(QrisEvent.generateQRCode(
          orderId,
          widget.price,
          widget.items,
          widget.customerName,
          widget.tableNumber,
          widget.orderType,
          widget.discountAmount,
          widget.tax,
          widget.serviceCharge,
          widget.orderNote ?? '',
        ));
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      scrollable: true,
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.primary,
      content: SizedBox(
        width: context.deviceWidth * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Pembayaran QRIS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ),
            const SpaceHeight(6.0),
            Container(
              width: context.deviceWidth,
              padding: const EdgeInsets.all(14.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: AppColors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocListener<QrisBloc, QrisState>(
                    listener: (context, state) {
                      state.maybeWhen(orElse: () {
                        return;
                      }, qrisResponse: (data) {
                        // Update orderId with the real one from backend (JG-xxxx or ID)
                        // FIX: Use orderId instead of transactionId (which is null)
                        orderId = data.orderId ?? orderId;
                        
                        const onSec = Duration(seconds: 5);
                        timer = Timer.periodic(onSec, (timer) {
                          context
                              .read<QrisBloc>()
                              .add(QrisEvent.checkPaymentStatus(
                                orderId.toString(),
                              ));
                        });
                      }, success: (message) async {
                        log("QRIS DIALOG: Success state received! Message: $message");
                        try {
                            context.read<OrderBloc>().add(OrderEvent.paymentSuccess(
                                widget.items,
                                widget.discount,
                                widget.discountAmount,
                                widget.tax,
                                widget.serviceCharge,
                                widget.paymentAmount,
                                widget.customerName,
                                widget.tableNumber,
                                'paid',
                                'paid',
                                'Qris',
                                widget.price,
                                widget.orderType,
                                widget.subTotal > 0 ? ((widget.tax / widget.subTotal) * 100).round() : 0,
                                widget.subTotal > 0 ? ((widget.serviceCharge / widget.subTotal) * 100).round() : 0,
                                widget.orderNote ?? '',
                            ));
                            
                            log("QRIS DIALOG: Showing SuccessPaymentDialog...");
                            await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => SuccessPaymentDialog(
                                isTablePaymentPage: widget.isTablePaymentPage,
                                data: widget.items,
                                totalQty: widget.totalQty,
                                totalPrice: widget.price,
                                totalTax: widget.tax,
                                totalDiscount: widget.discountAmount,
                                subTotal: widget.subTotal,
                                normalPrice: widget.price,
                                totalService: widget.serviceCharge,
                                draftName: widget.customerName,
                                paymentAmount: widget.paymentAmount,
                                tableName: widget.tableName,
                                orderType: widget.orderType,
                                orderNote: widget.orderNote,
                                paymentMethod: 'QRIS', // NEW: Pass QRIS as payment method
                                onPaymentSuccess: widget.onPaymentSuccess,
                              ),
                            );
                            log("QRIS DIALOG: SuccessPaymentDialog closed.");
                        } catch (e) {
                            log("QRIS DIALOG: ERROR showing success dialog: $e");
                        }
                      });
                    },
                    child: BlocBuilder<QrisBloc, QrisState>(
                      builder: (context, state) {
                        log('state: $state');
                        return state.maybeWhen(
                          orElse: () {
                            return const SizedBox();
                          },
                          success: (message) {
                            return Container(
                              width: 340.0,
                              height: 256.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green, size: 64),
                                    SizedBox(height: 16),
                                    Text("Pembayaran Berhasil!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            );
                          },
                          error: (message) {
                            return Container(
                              width: 340.0,
                              height: 256.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    message,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            );
                          },
                          qrisResponse: (data) {
                            log("QRIS DIALOG: State is qrisResponse");
                            log("QRIS DIALOG: URL/Data: ${data.actions?.first.url}");
                            final url = data.actions?.first.url ?? '';
                            log("QRIS DIALOG: Rendering QR for: $url");

                            if (url.isEmpty) {
                                log("QRIS DIALOG: URL is empty!");
                                return const Center(child: Text("Error: QR Data is Empty", style: TextStyle(color: Colors.red)));
                            }
                            
                            return SizedBox(
                              width: 340.0,
                              height: 350.0,
                              child: WidgetsToImage(
                                controller: controller,
                                child: Container(
                                  width: 340.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: QrImageView(
                                          data: url,
                                          version: QrVersions.auto,
                                          size: 200.0,
                                          backgroundColor: Colors.white,
                                          errorStateBuilder: (cxt, err) {
                                            log("QRIS DIALOG: QR Rendering Error: $err");
                                            return const Center(
                                              child: Text(
                                                "Uh oh! Something went wrong...",
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // const SpaceHeight(5.0),
                                      Text(
                                        NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp ',
                                        ).format(widget.price),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          loading: () {
                            return Container(
                              width: 256.0,
                              height: 256.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                              ),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SpaceHeight(12.0),
                  const Text(
                    'Scan QRIS to make payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SpaceHeight(12.0),
                  //button print qr
                  ElevatedButton(
                    onPressed: () async {
                      final sizeReceipt =
                          await AuthLocalDataSource().getSizeReceipt();
                      final bytes = await controller.capture();
                      final printValue = await PrintDataoutputs.instance
                          .printQRIS(
                              widget.price, bytes!, int.parse(sizeReceipt));
                      await PrintBluetoothThermal.writeBytes(printValue);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Print QRIS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
